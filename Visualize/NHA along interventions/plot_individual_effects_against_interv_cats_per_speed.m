function h_fig = plot_individual_effects_against_interv_cats_per_speed(...
		yVars,type,F,supTit)

	specs = get_plot_specs;
	speeds = [2500,2800];

	yLabel = 'Classifier values, \itD';
	xLabel = 'Intervention type';
	balCats = {
		'Nominal'
		'PCI 1'
		'PCI 2'
		'PCI 3'
		'RHC'
		};

	% Which and order of control interventions
	%ctrl_levels = [80,60,40,20,10];
	ctrl_levels = [10,20,40,60,80];

	F_drop_inds = contains(string(F.analysis_id),'.1 #2') | F.contingency;
	F = F(not(F_drop_inds),:);

	for j=1:size(yVars,1)

		h_fig(j) = figure(...
			'Name',sprintf('%s - %s as NHA',supTit,yVars{j,1}),...
			'Position',[1.8,32.2,760.6,1038.4]);
		h_tiles = tiledlayout(numel(speeds),1,...
			'TileSpacing', 'tight',...
			'Padding', 'tight'...
			);

		for s=1:numel(speeds)
			h_ax(s) = nexttile;
			var = yVars{j,1};
			h_err = [];
			h = gca;

			diams = [];
			for i=1:numel(balCats)

				F_inds_i = F.categoryLabel==balCats(i) & F.pumpSpeed==speeds(s);
				F_i = F(F_inds_i,:);

				if strcmp(balCats{i},'Nominal') && strcmpi(type{1},'relative')
					F_i.(var) = zeros(height(F_i),1);
				end

				hold on
				h.ColorOrderIndex=i;

				x = double(string(F_i.balDiam));
				x(isnan(x)) = 0;
				plot(F_i.balDiam,F_i.(var),...
					'LineStyle','none','Marker','.','MarkerSize',20,'Color',h.ColorOrder(i,:))

				diams = [diams;x];
			end

			F_aft = F(F.categoryLabel=='Afterload increase',:);
			F_pre = F(F.categoryLabel=='Preload decrease',:);

			M = numel(ctrl_levels);
			for m=1:M
				F_aft.balDiam(F_aft.QRedTarget_pst==ctrl_levels(m)) = -M+m-1-0.08;
				F_pre.balDiam(F_pre.QRedTarget_pst==ctrl_levels(m)) = -M+m-1+0.08;
			end

			F_aft_n = F_aft(F_aft.pumpSpeed==speeds(s),:);
			plot(F_aft_n.balDiam,F_aft_n.(var),...
				'LineStyle','none','Marker','.','MarkerSize',20,'Color',[0,0,0,0.5])

			F_pre_n = F_pre(F_pre.pumpSpeed==speeds(s),:);
			plot(F_pre_n.balDiam,F_pre_n.(var),...
				'LineStyle','none','Marker','.',...
				'MarkerSize',20,'Color',[0.5,0.5,0.5,0.5],'MarkerFaceColor',[0.5,0.5,0.5])

			xline([0.5,2.83],...
				'LineWidth',0.75,...
				'LineStyle','--'...
				);

			xlim([-5.2,12.2])
			if not(isempty(yVars{j,2}))
				ylim(yVars{j,2})
			end

			if s==1
				xlims = xlim;
				ylims = ylim;
				text(-0.5*abs(xlims(1)),ylims(2)*0.95,{'\bf{Control}','\rm{Clamp & nominal}'},...
					'FontSize',16,...
					'HorizontalAlignment','center',...
					'VerticalAlignment','top'...
					);

				text(xlims(2)*0.5,ylims(2)*0.95,{'\bf{Effect}','\rm{Inflated balloons}'},...
					'FontSize',16,...
					'HorizontalAlignment','center',...
					'VerticalAlignment','top'...
					);
			end

			h = gca;
			h.XTick = unique([-5:1:-1,diams']);

			h.XTickLabel(1:5) = strrep(cellstr(string(ctrl_levels)),'Q reduced, ','');
			h.XTickLabelRotation = 90;
			h.YGrid = 'on';
			h.GridAlpha = 0.4;
			h.GridLineStyle = ':';
			h.XTick(ismember(h.XTickLabel,'1.67')) = 1.59;
			h.XTick(ismember(h.XTickLabel,'1.73')) = 1.66;
			h.XTick(ismember(h.XTickLabel,'2.33')) = 2.35;
			try
				h.XTickLabel{ismember(h.XTickLabel,'1.73')} = "\newline1.73";
			catch
			end
			h.YTick(end) = [];

			if not(numel(speeds))
				h.XTickLabel = {};
				%h.TickLength = [0,0];
			end
			h.TickLength = [0,0];
			h.FontSize = 10;

		end

		% Add annotations and formatting of lines, text and ticks
		% ---------------------------------------------------
		title(h_tiles,supTit,specs.supTit{:});
		ylabel(h_tiles,yLabel);
		xlabel(h_tiles,xLabel);
		
		leg_entries = [
			'No catheter'
			string(balCats(2))
			string(balCats(3))
			string(balCats(4))
			string(balCats(5))
			'Afterload'
			'Preload'
			];
		h_leg = legend(h_err,leg_entries,...
			'Location','southeastoutside',...
			'Box','off',...
			'FontSize',16 ...
			);
		h_leg.Title.String = 'States';
		
	end

	set(h_ax,specs.effIntervAx{:});

