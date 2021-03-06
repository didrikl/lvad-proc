function h_figs = plot_acc_baselines_against_pumpspeed(G,vars,type)

    for i=1:size(vars,1)
        var = vars{i,1};
        h_figs(i) = figure(...
            'Name',['Plot 9: Boxplot of',type, var,' under RPM changes'],...
            'Position',[50,50,50,500]);
        
        inds = G.categoryLabel=='Nomnial' & G.interventionType=='Control';
        
        h_box = boxchart(G.pumpSpeed(inds), G.(var)(inds),... F_eff_rel.accA_x_nf_bpow(inds),...
            ....'Colors',colors,...
            ...'Notch','on',...
            'MarkerStyle','+',...
            ...'GroupByColor',G.med.categoryLabel,...
            'BoxWidth',0.5...
            ...'PlotStyle','compact'...
            );
    end