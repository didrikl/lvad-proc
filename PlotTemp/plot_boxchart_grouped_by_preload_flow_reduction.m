function h_figs = plot_boxchart_grouped_by_preload_flow_reduction(F,vars,type)
    
    if strcmpi(type,'relative')
        F{F.categoryLabel=='Nominal',vars(:,1)} = 0;
    end

    for i=1:size(vars,1)
        var = vars{i,1};
        h_figs(i) = figure(...
            'Name',['Plot 8: Boxplot of',type,' changes in preload flow reduction'],...
            'Position',[50,50,1000,1000]);
        
        ctrl_inds = F.interventionType=='Control';% & not(nom_ind);
        aft_inds = contains(lower(string(F.categoryLabel)),'preload');
        inds = aft_inds;% & ctrl_inds;
        boxchart(F.QRedTarget_pst(inds),F.(var)(inds),'GroupByColor',F.pumpSpeed(inds))
       
        %         set_Q_scatter_style(h_ax);
        %         xlabel(h,'Q (L/min)','Interpreter','none')
        %         ylabel(h,['Relative change in ',var],'Interpreter','none')
        
        if not(isempty(vars{i,2}))
            ylim(vars{i,2})
        end
    end
    
