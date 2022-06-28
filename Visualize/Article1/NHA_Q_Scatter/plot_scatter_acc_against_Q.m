function h_figs = plot_scatter_acc_against_Q(F,vars)

sc_specs = {
    11,...
    'filled',...
    'MarkerFaceAlpha',0.1,...
    'MarkerEdgeColor','flat',...
    'MarkerEdgeAlpha',0.7,...
    'LineWidth',0.40
    };

speeds = unique(F.pumpSpeed);%[2200,2500,2800,3100];
    
for i=1:size(vars,1)
    var = vars{i,1};
    h_figs(i) = figure(...
		'Name',['Plot 3a: ',var,' against Q'],...
		'Position',[50,50,1000,1000]);
        
    eff_ind = F.interventionType=='Effect';
    nom_ind = F.categoryLabel=='Nominal';
    ctrl_ind = F.interventionType=='Control' & not(nom_ind);
	h = tiledlayout(2,2,'Padding','tight','TileSpacing','tight');
    
    for j=1:numel(speeds)
        h_ax(j) = nexttile;
        
        rpm_ind = F.pumpSpeed==speeds(j);
        hold on
        scatter(F.Q_mean(eff_ind&rpm_ind),F.(var)(eff_ind&rpm_ind),...
            sc_specs{:},...
            'Marker','v')
        scatter(F.Q_mean(ctrl_ind&rpm_ind),F.(var)(ctrl_ind&rpm_ind),...
            sc_specs{:},...
            'Marker','v');
        scatter(F.Q_mean(nom_ind&rpm_ind),F.(var)(nom_ind&rpm_ind),...
            'Marker','hexagram');
        
        if not(isempty(vars{i,2}))
            ylim(vars{i,2})
        end
        xlim(h_ax(j),[1,7.3])
        
        title(string(speeds(j))+" RPM",...
            'FontWeight','normal',...
            'Position',[mean(xlim),diff(ylim)*0.92,0],...
            'HorizontalAlignment','center');
        if j==1
            legend({'Balloon','Clamp','Nominal'},...
                'Interpreter','none',...
                'Location','northwest'...
            ); 
        end
        
    end
    
    set_Q_scatter_style(h_ax);
    xlabel(h,'Q (L/min)','Interpreter','none')
    ylabel(h,var,'Interpreter','none')
    
end

