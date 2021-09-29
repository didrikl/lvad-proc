function h_fig = plot_effects_in_tile_by_speed(T,yVars,type)
    
    figSize = [1000,600];
    markers = {'o','square','diamond','hexagram'};
    
    speeds = [2200,2500,2800,3100];
    speeds = speeds(ismember([2200,2500,2800,3100],T.pumpSpeed));
    
    balCats = {
        'Nominal'
        '4.5mm PCI'
        '6mm PCI'
        '8mm PCI'
        '11mm RHC'
        };
    
    ctrl_levels = {
        'Q reduced, 80%'
        'Q reduced, 60%'
        'Q reduced, 40%'
        'Q reduced, 20%'
        'Q reduced, 10%'
        };
    
    
    drop_inds = ...
        contains(string(T.analysis_id),'.1 #2') | ...
        contains(string(T.idLabel),'Lev0_Rep');
    T = T(not(drop_inds),:);
    
    for j=1:size(yVars,1)
        
        title_str = ['Group Means of ',type,' Intervention Effects in ',yVars{j}];
        
        h_fig(j) = figure('Name',title_str,'Position',[20,200/2,figSize]);
        var = yVars{j,1};
        
        diams = [];
        for i=1:numel(balCats)
            
            T_i = T(T.categoryLabel==balCats(i),:);
            for n=1:numel(speeds)
                h_ax = gca;
                hold on
                h_ax.ColorOrderIndex=i;
                
                T_mn = T_i(T_i.pumpSpeed==speeds(n),:);
                x = double(string(T_mn.balloonDiam));
                x(isnan(x)) = 0;
                scatter(x,T_mn.(var),'filled',...
                    'Marker',markers{n},...
                    'MarkerFaceAlpha',0.75,...
                    'LineWidth',2 ...
                    );
            end
            diams = [diams;x];
        end
        
        T_aft = T(T.categoryLabel=='Afterload increase',:);
        T_pre = T(T.categoryLabel=='Preload decrease',:);
        M = numel(ctrl_levels);
        for m=1:M
            T_aft.balloonDiam(T_aft.levelLabel==ctrl_levels(m)) = num2str(-M+m-1-0.08);
            T_pre.balloonDiam(T_pre.levelLabel==ctrl_levels(m)) = num2str(-M+m-1+0.08);
        end
        
        for n=1:numel(speeds)
            
            T_aft_n = T_aft(T_aft.pumpSpeed==speeds(n),:);
            x = double(string(T_aft_n.balloonDiam));
            scatter(x,T_aft_n.(var),'filled',...
                'Marker',markers{n},...
                'MarkerFaceAlpha',0.75,...
                'LineWidth',2, ...
                'MarkerFaceColor',[0,0,0]...
                );
        end
        
        for n=1:numel(speeds)
            
            T_pre_n = T_pre(T_pre.pumpSpeed==speeds(n),:);
            x = double(string(T_pre_n.balloonDiam));
            scatter(x,T_pre_n.(var),'filled',...
                'Marker',markers{n},...
                'MarkerFaceAlpha',0.75,...
                'LineWidth',2, ...
                'MarkerFaceColor',[0.5,0.5,0.5]...
                );
        end
        
        xline(0.5,...
            'LineWidth',0.5,...
            'LineStyle','--',...
            'Label',{'\bf{Control}                  ',...
            '\rm{Clamp and speed changes}  '},...
            'LabelHorizontalAlignment','left',...
            'LabelOrientation','horizontal',...
            'LabelVerticalAlignment','middle');
        xline(0.5,...
            'LineWidth',0.5,...
            'LineStyle','--',...
            'Alpha',0,...
            'Label',{'                   \bf{Effect}',...
            '         \rm{Inflated balloons}'},...
            'LabelHorizontalAlignment','right',...
            'LabelOrientation','horizontal',...
            'LabelVerticalAlignment','middle');
        
        h = gca;
        h.XTick = [-5:1:-1,sort(diams)'];
        h.XTickLabel(1:5) = strrep(cellstr(string(ctrl_levels)),'Q reduced, ','');
        h.XTickLabel{6} = '0';
        %h.XTickLabelRotation = 90;
        h.YGrid = 'on';
        h.GridAlpha = 0.25;
        h.GridLineStyle = ':';
        
        xlim([-5.2,12.2])
        
        leg_entries = [
            string(speeds)'+""
            erase(string(speeds)'+", "+string(balCats(1)),{'PCI, ','RHC, '})
            erase(string(speeds)'+", "+string(balCats(2)),{'PCI, ','RHC, '})
            erase(string(speeds)'+", "+string(balCats(3)),{'PCI, ','RHC, '})
            erase(string(speeds)'+", "+string(balCats(4)),{'PCI, ','RHC, '})
            string(speeds)'+", afterload"
            string(speeds)'+", preload"
            ];
        h_leg = legend(leg_entries,'Location','northeastoutside','NumColumns',1);
        h_leg.Title.String = 'Speed (RPM), Catheter';
        
        ylabel(strrep(var,'mean_',''),'Interpreter','none');
        xlabel('Balloon diameter (mm)','HorizontalAlignment','left');
        title(title_str,'Interpreter','none')
                 
        if not(isempty(yVars{j,2}))
            ylim(yVars{j,2})
        end
        
    end
    
end


