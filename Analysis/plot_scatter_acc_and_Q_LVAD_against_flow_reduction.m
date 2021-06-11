function h_figs = plot_scatter_acc_and_Q_LVAD_against_flow_reduction(F,vars)
    
    sc_specs = {
        12,...
        'filled',...
        'MarkerFaceAlpha',0.15,...
        'MarkerEdgeColor','flat',...
        'MarkerEdgeAlpha',0.7,...
        'LineWidth',0.4
        };
    
    speeds = {'2200','2500','2800','3100'};
    
    for i=1:size(vars,1)
        var = vars{i,1};
        h_figs(i) = figure(...
            'Name',['Plot 8: Absolute ',var,' and Q_LVAD against flow reduction'],...
            'Position',[50,50,1000,1000]);
        
        
        nom_ind = F.categoryLabel=='Nominal';
        ctrl_ind = F.interventionType=='Control';% & not(nom_ind);
        
        h = tiledlayout(2,2,'Padding','tight','TileSpacing','tight');
        for j=1:numel(speeds)
            h_ax(j) = nexttile;
            
            rpm_ind = F.pumpSpeed==speeds(j);
            hold on
            scatter(F.QRedTarget_pst(ctrl_ind&rpm_ind),F.(var)(ctrl_ind&rpm_ind),...
                sc_specs{:},...
                'Marker','o')
%             scatter(F.Q_mean(eff_ind&rpm_ind),F.QRedTarget_pst(eff_ind&rpm_ind),...
%                 sc_specs{:},...
%                 'Marker','o')
%             h_ax(j).ColorOrderIndex = 1;
%             scatter(F.Q_mean(eff_ind&rpm_ind),F.(var)(eff_ind&rpm_ind),...
%                 sc_specs{:},...
%                 'Marker','v')
%             scatter(F.Q_mean(ctrl_ind&rpm_ind),F.(var)(ctrl_ind&rpm_ind),...
%                 sc_specs{:},...
%                 'Marker','v');
%             scatter(F.Q_mean(nom_ind &rpm_ind),zeros*F.(var)(nom_ind&rpm_ind),...
%                 sc_specs{:},...
%                 'Marker','hexagram');
            
            if not(isempty(vars{i,2}))
                ylim(vars{i,2})
            end
            %xlim(h_ax(j),[1,7.3])
    
            ylims = ylim;
            h_tit = title(speeds{j}+" RPM",...
                'FontWeight','normal',...
                'HorizontalAlignment','center');
            h_tit.Position(2) = ylims(2)*0.92;
            
            if j==1
%                 leg_entries = {
%                     'Balloon, acc'
%                     'Clamp, acc'
%                     'Nominal, acc'
%                     'Balloon, Q_LVAD'
%                     'Clamp, Q_LVAD'};
%                 legend(leg_entries,...
%                     'Interpreter','none',...
%                     'Location','northwest'...
%                     );
            end
            
        end
        
        set_Q_scatter_style(h_ax);
        xlabel(h,'Q (L/min)','Interpreter','none')
        ylabel(h,['Relative change in ',var],'Interpreter','none')
    end
   
