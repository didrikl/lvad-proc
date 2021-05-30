function h_fig = plot_effects(T,yVars,yLims,type)


figSize = [1000,600];
markers = {'o','square','diamond','hexagram'};
speeds = [2200,2500,2800,3100];
levels = {'-','1','2','3','4','5'};
diams = categories(T.balloonDiam);
catheters = {
    '-'
    'PCI, 4.5mm x 20mm'
    'PCI, 8mm x 30mm'
    'PCI, 6mm x 20mm'
    'RHC, 11mm'
    };
    
for k=1:numel(yVars)
    
    title_str = ['Group Means of ',type,' Balloon Intervention Effects in ',yVars{k}];
    
    h_fig(k) = figure('Name',title_str,'Position',[20,200/2,figSize]);
    var = "mean_"+yVars{k};
    

    for j=1:numel(diams)
        for i=1:numel(speeds)
            h_ax = gca;
            hold on
            
            G_eff_ij = T(T.pumpSpeed==speeds(i) & T.balloonDiam==diams(j),:);
            colIndex = find(catheters==unique(G_eff_ij.catheter));
            if isnan(colIndex), colIndex=0; end
            h_ax.ColorOrderIndex=colIndex;
            
            h_s(i) = scatter(double(string(G_eff_ij.balloonDiam)),G_eff_ij.(var),'filled',...
                'Marker',markers{i},...
                'MarkerFaceAlpha',0.75,...
                'LineWidth',2 ...
                );
            
        end
    end
    
    leg_entries = [
        erase(string(speeds)'+"RPM, "+string(catheters(1)),{'PCI, ','RHC, '})
        erase(string(speeds)'+"RPM, "+string(catheters(2)),{'PCI, ','RHC, '})
        erase(string(speeds)'+"RPM, "+string(catheters(3)),{'PCI, ','RHC, '})
        erase(string(speeds)'+"RPM, "+string(catheters(4)),{'PCI, ','RHC, '})
        ]; 
    h_leg = legend(leg_entries,'Location','northeastoutside','NumColumns',1);
    ylabel(strrep(var,'mean_',''),'Interpreter','none');
    xlabel('Balloon diameter (mm)');
    title(title_str,'Interpreter','none')
    
    ylim(yLims)
    
    
    
end


