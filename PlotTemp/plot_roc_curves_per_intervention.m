function h_figs = plot_roc_curves_per_intervention(...
		F,classifiers,stateVar,predStates,titleStr,pooled)
	% Specific/max inflations by speeds in subplots
	% Plot ROC curves for states of specific intervention levels.
	%
	% Panel [no of states]x4 matrix setup:
	% - one panel row for each speed
	% - one panel colum for each pooled state
	%
	% Curves overlaid in each panels for:
	% - NHA as classifier
	% - Power as classifier
	
	speeds = [2200,2500,2800,3100];
	
	spec = get_specs_for_plot_NHA;
	
	k=1;
	h_figs(k) = figure(spec.fig{:},...
			'Name',[titleStr,' - ',classifiers{k},' as NHA classifier'],...
			'Position',[10,100,1080,700] ...
			);
	hold on
	h = tiledlayout(size(predStates,1),numel(speeds)+1,...
			'Padding','compact',...
			'TileIndexing','columnmajor',...
			'TileSpacing','compact'...
			);
% 		title(h,titleStr,spec.subTit{:},'VerticalAlignment','bottom');
		
	for k=1:numel(classifiers)
		
		for j=1:numel(speeds)
			
			for i=1:size(predStates,1)
				
				if k==1 
					h_ax(i,j) = nexttile;
					if j==1, h_yax(i) = copyobj(h_ax(i,j),gcf); end
					if i==3, h_xax(j) = copyobj(h_ax(i,j),gcf); end
					% Add annotations
					% -----------------------------
					if i==1,h_subTit(i,j) = title({string(speeds(j))+" RPM",''}); end
					
					if j==numel(speeds)
						subStr = num2str(min(round(unique(...
							F.arealOccl_pst(F.(stateVar)==predStates{i,1})))));
						text(1.10,0.5,{['\bf{',predStates{i,2},'}'],...
							['\rm{',subStr,'% areal occl.}']},...
							'FontSize',11);
				end
				
				end
				
				hold on
				h_ax(i,j).ColorOrderIndex = k;
				if pooled 
					state_inds = F.(stateVar)>=predStates{i,1};
				else
					state_inds = F.(stateVar)==predStates{i,1};
				end
				inds = (state_inds | F.interventionType=='Control' )...
					& F.pumpSpeed==speeds(j);
				
				% Plot NHA
				% -----------------------------
				
				[X,Y,~,AUC_boot] = perfcurve(F.(stateVar)(inds),...
					F.(classifiers{k})(inds),predStates{i,1},"NBoot",10);
				
				h_nha(k) = plot(h_ax(i,j),X(:,1),Y(:,1), ...
					'LineWidth',2 ...
					...'Color', [37,52,148]/256 ... dark blue
					...'Color', [44,127,184]/256 ... medium blue
				    );
 				if k>1
 					set(h_nha(k),'LineWidth',2); 
				%	h_nha(k).Color = [h_nha(k).Color, .6];
					h_nha(k).LineStyle = ':';
				else					
					set(h_nha(k),'LineWidth',3);
				end
				
% 				h_a = patch([X(:,1);1],[Y(:,1);0],'red',...
% 					'FaceColor',h_nha(i).Color,...
% 					'FaceAlpha',0.10,...
% 					'EdgeColor','none');
				
				% Plot Power
				%{
				if i==size(predStates,1)
					[X2,Y2,~,AUC2_boot] = perfcurve(F.(stateVar)(inds),...
						F.P_LVAD_drop(inds),predStates{i,1},"NBoot",1);
					
					h_pow(i) = plot(X2(:,1),Y2(:,1),...
						'LineWidth',1.5,...
						...'Color',[65,182,196]/256,...
						'Color',[.3 .3 .3 .35],...
						'LineStyle','-'...
						);
					h_a = area(X2(:,1),Y2(:,1),...
						'FaceColor',h_pow(i).Color,...
						'FaceAlpha',0.05,...
						'EdgeColor','none');
					text(0.8,0.05,sprintf("AUC=%2.2f (%2.2f, %2.2f)",...
						AUC2_boot(1),AUC2_boot(2),AUC2_boot(3)));
				
				end
				%}
				
% 				if k==1
%   				plot([0,1],[0,1],'-',...
%   					'Color',[0.8906,0.1016,0.1094,0.25],...
%   					'LineWidth',1.5);
% 					
				set(h_ax(i,j),spec.ax{:})
				pbaspect(h_ax(i,j),[1 1 1]);
				xlim([0,1])
				ylim([0,1])
				
				
%  				text(0.07,0.95,sprintf("AUC=%2.2f (%2.2f, %2.2f)",...
%  					AUC_boot(1),AUC_boot(2),AUC_boot(3)));
				%text(0.07,0.95,sprintf("AUC=%2.2f",AUC_boot(1)),spec.text{:});
				end
				
			end
			
		end
		
		if k==numel(classifiers)
			%h_leg = legend([h_nha(end),h_pow(end)],{'NHA','Power drop'},spec.leg{:}); %'\it{-\DeltaP}\rm_{LVAD}'
			%h_leg.Title.String = 'Classifier';
			
			h_leg = legend(h_nha,{'x','y','z'},spec.leg{:}); %'\it{-\DeltaP}\rm_{LVAD}'
			h_leg.Title.String = 'Direction';
			
			format_axes_in_plot_ROC(h_ax,spec)
			set(h_subTit,spec.subTit{:})
			
			h_leg.Position(3) = 0.065;
			h_leg.Position(1) = 0.83;
			h_leg.Position(2) = 0.01;%h_ax(end,end).Position(2);
			
			% // Add the new axes:
			for i=1:3
				h_yax(i).Position = h_ax(i,1).Position;
				h_yax(i).Position(1) = h_yax(i).Position(1)-0.015;
				h_yax(i).XAxis.Visible = 'off';
				h_yax(i).YLim = h_ax(i,1).YLim;
				h_yax(i).YTick = h_ax(i,1).YTick;
			end
			format_axes_in_plot_NHA(h_yax,spec.ax,spec.axTick)
			
			set(h_yax,'Color','none');
			set(h_yax,'YGrid','off');
			set(h_yax,'XGrid','off');
			set(h_yax,'YColor',[0,0,0])
			
			% Add the new axes:
			for j=1:numel(h_xax)
				h_xax(j).YAxis.Visible = 'off';
				h_xax(j).XLim = h_ax(3,j).XLim;
				h_xax(j).XTick = h_ax(3,j).XTick;
				h_xax(j).XTickLabel = h_ax(3,j).XTickLabel;
				h_xax(1,j).Position = h_ax(3,j).Position;
				h_xax(1,j).Position(2) = h_xax(1,j).Position(2)-0.025;
			end
			
			set(h_xax,'XTick',0:0.2:1);
			set(h_xax,'XTickLabel',string(0:0.2:1));
			format_axes_in_plot_NHA(h_xax,spec.ax,spec.axTick)
			set(h_xax,'Color','none');
			set(h_xax,'XGrid','off');
			set(h_xax,'YGrid','off');
			set(h_xax,'XColor',[0,0,0])
			
			
%			h_xlab = xlabel(h,'1 - Specificity');
% 			get(h_xlab)
% 			%h_xlab.Position(1) = h_xlab.Position(1)-0.05;
% 			h_ylab = ylabel(h,'Sensitivity');
		
		
		end
		
		
	end
		
