function h_figs = plot_boxchart_grouped_by_afterload_flow_reduction(F,vars,type)
    
    sc_specs = {
        12,...
        'filled',...
        'MarkerFaceAlpha',0.15,...
        'MarkerEdgeColor','flat',...
        'MarkerEdgeAlpha',0.7,...
        'LineWidth',0.4
        };
    
    speeds = {'2200','2500','2800','3100'};
    
    if strcmpi(type,'relative')
        F{F.categoryLabel=='Nominal',vars(:,1)} = 0;
    end

    for i=1:size(vars,1)
        var = vars{i,1};
        h_figs(i) = figure(...
            'Name',['Plot 8: Absolute ',var,' and Q_LVAD against flow reduction'],...
            'Position',[50,50,1000,1000]);
        
        ctrl_ind = F.interventionType=='Control';% & not(nom_ind);
        
        boxchart(F.QRedTarget_pst(ctrl_ind),F.(var)(ctrl_ind),'GroupByColor',F.pumpSpeed(ctrl_ind))
       
        %         set_Q_scatter_style(h_ax);
        %         xlabel(h,'Q (L/min)','Interpreter','none')
        %         ylabel(h,['Relative change in ',var],'Interpreter','none')
        
        if not(isempty(vars{i,2}))
            ylim(vars{i,2})
        end
    end
    
