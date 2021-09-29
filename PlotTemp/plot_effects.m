function h_fig = plot_effects(T,yVars,type)
    
    figSize = [1000,600];
    markers = {'o','square','diamond','hexagram'};
    
    speeds = [2200,2500,2800,3100];
    speeds = speeds(ismember([2200,2500,2800,3100],T.pumpSpeed));
    
    balCats = {
        'Nominal'
        'PCI 1'
        'PCI 2'
        'PCI 3'
        'RHC'
        };
    
    afterload_levels = {
        'Afterload Q red., 20%'
        'Afterload Q red., 40%'
        'Afterload Q red., 60%'
        'Afterload Q red., 80%'
		};
	preload_levels = {
        'Preload Q red., 10%'
        'Preload Q red., 20%'
        'Preload Q red., 40%'
        'Preload Q red., 60%'
        'Preload Q red., 80%'
        };
    
    
    drop_inds = ...
        contains(string(T.analysis_id),'.1 #2') | ...
        contains(string(T.idLabel),'Lev0_Rep');
    T = T(not(drop_inds),:);
    
    for j=1:size(yVars,1)
        
        title_str = ['Plot 1: Group Means of ',type,' Intervention Effects in ',yVars{j}];
        
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
        M = numel(afterload_levels);
        for m=1:M
            T_aft.balloonDiam(T_aft.levelLabel==afterload_levels(m)) = -M+m-1-0.08;
        end
        M = numel(preload_levels);
        for m=1:M
            T_pre.balloonDiam(T_pre.levelLabel==preload_levels(m)) = -M+m-1+0.08;
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
        h.XTickLabel(1:5) = strrep(cellstr(string(afterload_levels)),'Preload Q red., ','');
        h.XTickLabel{6} = '0';
        %h.XTickLabelRotation = 90;
        h.YGrid = 'on';
        h.GridAlpha = 0.25;
        h.GridLineStyle = ':';
        
        xlim([-5.2,12.2])
        
        leg_entries = [
            string(speeds)'+""
            erase(string(speeds)'+", "+string(balCats(2)),'PCI')
            erase(string(speeds)'+", "+string(balCats(3)),'PCI')
            erase(string(speeds)'+", "+string(balCats(4)),'PCI')
            erase(string(speeds)'+", "+string(balCats(5)),'RHC')
            string(speeds)'+", afterload"
            string(speeds)'+", preload"
            ];
        h_leg = legend(leg_entries,'Location','northeastoutside','NumColumns',1);
        h_leg.Title.String = 'Speed (RPM), Catheter';
        
        ylabel(strrep(var,'mean_',''),'Interpreter','none');
        xlabel('Balloon diameter (mm)','HorizontalAlignment','left');
        title(title_str,'Interpreter','none')
        
        %     annotation(h_fig,'textbox',...
        %         [0.328134618916437,0.0075,0.447071992653811,0.0466],...
        %         'String','Balloon diameter',...
        %         'LineStyle','none',...
        %         'FitBoxToText','off',...
        %         'HorizontalAlignment','center');
        %
        %     annotation(h_fig,'textbox',...
        %         [0.1089072543618,0.0075,0.220385674931129,0.0466],...
        %         'String','Flow reduction',...
        %         'LineStyle','none',...
        %         'FitBoxToText','off',...
        %         'HorizontalAlignment','center');
         
        if not(isempty(yVars{j,2}))
            ylim(yVars{j,2})
        end
        
    end
    
end


