function [h_lines,h_backPts,h_backLines] = plot_group_and_individual_data_G1(...
		h_ax,G,F,speeds,xVar,xLims,nhaVars,spec,R)

	seqs = unique(F.seq);
	yVar = nhaVars{1};
	yLims = nhaVars{2};
	G.(xVar) = double(string((G.(xVar))));
	F.(xVar) = double(string((F.(xVar))));
	F = sortrows(F,xVar);
	
for j=1:numel(speeds)
	
	% Plot background points
	h_ax.ColorOrderIndex=j;
	
	F_rpm_inds = F.pumpSpeed==speeds(j);
	F_y = F.(yVar)(F_rpm_inds);
	F_x = F.(xVar)(F_rpm_inds);
	F_x(isnan(F_x)) = 0;
	h_backPts(j) = scatter(F_x, F_y, spec.backPts{:},...
		'Marker',spec.speedMarkers{j});
	
	% Plot background lines
	for k=1:numel(seqs)
		h_ax.ColorOrderIndex=j;
		F_x = F.(xVar)(F_rpm_inds & F.seq==seqs(k));
		F_y = F.(yVar)(F_rpm_inds & F.seq==seqs(k));
		F_x(isnan(F_x)) = 0;
		h_backLines(j,k) = plot(F_x, F_y, spec.backLines{:});
		h_backLines(j,k).Color = [h_backLines(j).Color,0.5];
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
	G_x = G.(xVar)(G_rpm_inds);
	if isempty(G_y), G_y = nan; G_x = nan; end
	h_lines(j) = plot(G_x, double(G_y), spec.line{:},...
		'Marker',spec.speedMarkers{j},...
		'Color',h_backLines(j).Color);
	h_lines(j).MarkerFaceColor = h_lines(j).Color;
	
	% Add p value label at line endpoints
	if not(isempty(R))
		p = R.(yVar)(ismember(R.pumpSpeed,speeds(j)));
 		%text(G_x(end)+0.055*diff(xLims),G_y(end),'p='+extractAfter(p,'p='),'FontSize',9);
 		if double(extractBetween(p,' (',')'))<=0.05
 			text(G_x(end)+0.05*diff(xLims),G_y(end),'*',...
				spec.asterix{:});
 		end
	end
	
	interventionTicks = G_x(2:end)';
	xticks(unique([0,interventionTicks,xLims(2)]));

	% Adjust axis limits; y only if specified by user
	if not(isempty(yLims)), ylim(yLims); end
	xlim(xLims)
			
end
