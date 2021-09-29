function [h_lines,h_backPts,h_backLines] = plot_circulation_data_in_catheter_panels(...
		h_ax,G,F,speeds,xVar,xLims,nhaVars,backPtsSpec,markers,lineSpec,R)

	seqs = unique(F.seq);
	yVar = nhaVars{1};
	yLims = nhaVars{2};
	
flow = F.Q_LVAD_mean()
power =

for j=1:numel(speeds)
	
	% Plot background points
	h_ax.ColorOrderIndex=j;
	
	F_rpm_inds = F.pumpSpeed==speeds{j};
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
		h_backLines(j,k) = plot(F_x(min_x_ind|max_x_ind),F_y(min_x_ind|max_x_ind));
		h_backLines(j,k).Color = [h_backLines(j).Color,0.25];
	end
end

for j=1:numel(speeds)
	
	% Plot background points
	h_ax.ColorOrderIndex=j;
	
	% Plot aggregated values in heavy lines
	G_rpm_inds = G.pumpSpeed==double(string(speeds{j}));
	G_y = G.(yVar)(G_rpm_inds);
	G_x = round(double(string(G.(xVar)(G_rpm_inds))),0);%+j*0.05-0.10;
	G_x(isnan(G_x)) = 0;
	h_lines(j) = plot(G_x([1,end]),double(G_y([1,end])),lineSpec{:},...
		'Marker',markers{j},'Color',h_backLines(j).Color);
	h_lines(j).MarkerFaceColor = h_lines(j).Color;
	
	maxBalTick = G_x(end);
	xticklabels({'0',['\bf{',num2str(maxBalTick),'}'],num2str(xLims(2))});
	xticks([0,maxBalTick,xLims(2)]);
			
	% Adjust axis limits; y only if specified by user
	if not(isempty(yLims)), ylim(yLims); end
	xlim(xLims)
			
end
