function [h_lines,h_backPts,h_backLines] = plot_group_and_individual_data(...
		h_ax,G,F,speeds,xVar,xLims,nhaVars,backPtsSpec,markers,lineSpec,R)

	seqs = unique(F.seq);
	yVar = nhaVars{1};
	yLims = nhaVars{2};
	G.(xVar) = double(string((G.(xVar))));
	F.(xVar) = double(string((F.(xVar))));

for j=1:numel(speeds)
	
	% Plot background points
	h_ax.ColorOrderIndex=j;
	
	F_rpm_inds = F.pumpSpeed==speeds(j);
	F_y = F.(yVar)(F_rpm_inds);
	F_x = round(double(string(F.(xVar)(F_rpm_inds)))+mod(j,2)*0.003*diff(xLims));
	F_x(isnan(F_x)) = 0;
	h_backPts(j) = scatter(F_x,F_y,backPtsSpec{:},'Marker',markers{j});
	
	% Plot background lines
	for k=1:numel(seqs)
		h_ax.ColorOrderIndex=j;
		F_x = double(string(F.(xVar)(F_rpm_inds & F.seq==seqs(k))));%+j*0.10-0.20;
		F_y = F.(yVar)(F_rpm_inds & F.seq==seqs(k));
		F_x(isnan(F_x)) = 0;
		max_x_ind = F_x==max(F_x);
		min_x_ind = F_x==min(F_x);
		h_backLines(j,k) = plot(F_x,F_y,'LineWidth',0.6);
		h_backLines(j,k).Color = [h_backLines(j).Color,0.4];
	end
end

for j=1:numel(speeds)
	
	% Plot background points
	h_ax.ColorOrderIndex=j;
	
	% Plot aggregated values in heavy lines
	G.(xVar)(isnan(G.(xVar))) = 0;
	G = sortrows(G,xVar);
	G_rpm_inds = G.pumpSpeed==speeds(j);
	G_y = G.(yVar)(G_rpm_inds);
	G_x = round(G.(xVar)(G_rpm_inds),0);%+j*0.05-0.10;
	h_lines(j) = plot(G_x,double(G_y),lineSpec{:},...
		'Marker',markers{j},'Color',h_backLines(j).Color);
	h_lines(j).MarkerFaceColor = h_lines(j).Color;
	
	% Add p value label at line endpoints
	%%{
 	if not(isempty(R))
		p = R.(yVar)(ismember(R.pumpSpeed,speeds(j)));
 		%text(G_x(end)+0.055*diff(xLims),G_y(end),'p='+extractAfter(p,'p='),'FontSize',9);
 		if double(extractBetween(p,' (',')'))<=0.05
 			text(G_x(end)+0.05*diff(xLims),G_y(end),'*','FontSize',16);
 		end
 	end
	%}
	
	interventionTicks = G_x(2:end)';
	xticks(unique([0,interventionTicks,xLims(2)]));
	if numel(interventionTicks)==1
		xticklabels({'0',['\bf{',num2str(interventionTicks),'}'],num2str(xLims(2))});
	end
			
	% Adjust axis limits; y only if specified by user
	if not(isempty(yLims)), ylim(yLims); end
	xlim(xLims)
			
end
