function h_figs = plot_scatter_relative_acc_and_Q_LVAD_against_Q(F,F_rel,vars)
    
    sc_specs = {
        12,...
        'filled',...
        'MarkerFaceAlpha',0.15,...
        'MarkerEdgeColor','flat',...
        'MarkerEdgeAlpha',0.7,...
        'LineWidth',0.4
        };
    
    speeds = [2200,2500,2800,3100];
    
    for i=1:size(vars,1)
        var = vars{i,1};
        h_figs(i) = figure(...
            'Name',['Plot 3b: Relative ',var,' and Q_LVAD against Q'],...
            'Position',[50,50,1000,1000]);
        
        eff_ind = F_rel.interventionType=='Effect';
        nom_ind = F_rel.categoryLabel=='Nominal';
        ctrl_ind = F_rel.interventionType=='Control' & not(nom_ind);
        
        h = tiledlayout(2,2,'Padding','tight','TileSpacing','tight');
        for j=1:numel(speeds)
			
            h_ax(j) = nexttile;
            
            rpm_ind = F_rel.pumpSpeed==speeds(j)
            hold on
            h_ax(j).ColorOrderIndex = 4;
            scatter(F.Q_mean(ctrl_ind&rpm_ind),F_rel.Q_LVAD_mean(ctrl_ind&rpm_ind),...
                sc_specs{:},...
                'Marker','o')
            scatter(F.Q_mean(eff_ind&rpm_ind),F_rel.Q_LVAD_mean(eff_ind&rpm_ind),...
                sc_specs{:},...
                'Marker','o')
            h_ax(j).ColorOrderIndex = 1;
            scatter(F.Q_mean(eff_ind&rpm_ind),F_rel.(var)(eff_ind&rpm_ind),...
                sc_specs{:},...
                'Marker','v')
            scatter(F.Q_mean(ctrl_ind&rpm_ind),F_rel.(var)(ctrl_ind&rpm_ind),...
                sc_specs{:},...
                'Marker','v');
            scatter(F.Q_mean(nom_ind &rpm_ind),zeros*F_rel.(var)(nom_ind&rpm_ind),...
                sc_specs{:},...
                'Marker','hexagram');
            
            if not(isempty(vars{i,2}))
                ylim(vars{i,2})
            end
            xlim(h_ax(j),[1,7.3])
    
            ylims = ylim;
            title(string(speeds(j))+" RPM",...
                'FontWeight','normal',...
                'Position',[mean(xlim),ylims(2)*0.92,0],...
                'HorizontalAlignment','center');
            
            if j==1
                leg_entries = {
                    'Balloon, acc'
                    'Clamp, acc'
                    'Nominal, acc'
                    'Balloon, Q_LVAD'
                    'Clamp, Q_LVAD'};
                legend(leg_entries,...
                    'Interpreter','none',...
                    'Location','northwest'...
                    );
            end
            
        end
        
        set_Q_scatter_style(h_ax);
        xlabel(h,'Q (L/min)','Interpreter','none')
        ylabel(h,['Relative change in ',var],'Interpreter','none')
    end
   
