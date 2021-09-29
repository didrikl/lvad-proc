function h_fig = plot_effects_in_speed_tiles(T,yVars,type)
    
    markers = {'o','pentagram','square','diamond','hexagram'};
    
    speeds = [2200,2500,2800,3100];
    
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
    
    
%     drop_inds = ...
%         contains(string(T.analysis_id),'.1 #2') | ...
%         contains(string(T.idLabel),'Lev0_Rep');
    drop_inds = contains(string(T.analysis_id),'.1 #2') | T.contingency;    
    T = T(not(drop_inds),:);
    
    for j=1:size(yVars,1)
        
        title_str = ['Group Means of ',type,' Intervention Effects in ',yVars{j}];
        h_fig(j) = figure('Name',title_str,'WindowState','maximized');
        h_tiles = tiledlayout(2,2,...
            'TileSpacing', 'compact',...
            'Padding', 'compact'...
            );
        
        
        for s=1:numel(speeds)
            nexttile
            var = yVars{j,1};
            
            diams = [];
            for i=1:numel(balCats)
                
                T_i = T(T.categoryLabel==balCats(i),:);
                h_ax = gca;
                hold on
                h_ax.ColorOrderIndex=i;
                
                T_mn = T_i(T_i.pumpSpeed==speeds(s),:);
                x = double(string(T_mn.balloonDiam));
                x(isnan(x)) = 0;
                scatter(x,T_mn.(var),'filled',...
                    'Marker',markers{i},...
                    'MarkerFaceAlpha',0.75,...
                    'LineWidth',2 ...
                    );
                diams = [diams;x];
            end
            
            T_aft = T(T.categoryLabel=='Afterload increase',:);
            T_pre = T(T.categoryLabel=='Preload decrease',:);
            M = numel(ctrl_levels);
            for m=1:M
                T_aft.balloonDiam(T_aft.levelLabel==ctrl_levels(m)) = num2str(-M+m-1-0.08);
                T_pre.balloonDiam(T_pre.levelLabel==ctrl_levels(m)) = num2str(-M+m-1+0.08);
            end
            
            T_aft_n = T_aft(T_aft.pumpSpeed==speeds(s),:);
            x = double(string(T_aft_n.balloonDiam));
            scatter(x,T_aft_n.(var),'filled',...
                'Marker',markers{1},...
                'MarkerFaceAlpha',0.75,...
                'LineWidth',2, ...
                'MarkerFaceColor',[0,0,0]...
                );
            
            T_pre_n = T_pre(T_pre.pumpSpeed==speeds(s),:);
            x = double(string(T_pre_n.balloonDiam));
            scatter(x,T_pre_n.(var),'filled',...
                'Marker',markers{1},...
                'MarkerFaceAlpha',0.75,...
                'LineWidth',2, ...
                'MarkerFaceColor',[0.5,0.5,0.5]...
                );
            
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
            h.XTickLabelRotation = 90;
            %grid 'on';
            h.YGrid = 'on';
            h.GridAlpha = 0.25;
            h.GridLineStyle = ':';
            
            xlim([-5.2,12.2])
     
            if s==1 || s==3
            %    ylabel(strrep(var,'mean_',''),'Interpreter','none');
            else
                h.YTickLabel = {};
            end
            if s==3 || s==4
                xlabel('Balloon diameter (mm)','HorizontalAlignment','left');
            else
                h.XTickLabel = {};
            end
            title(['Pump speed = ',num2str(speeds(s))])
            
            if not(isempty(yVars{j,2}))
                ylim(yVars{j,2})
            end
            
        end
                
        leg_entries = [
                'No catheter'   
                string(balCats(2))
                string(balCats(3))
                string(balCats(4))
                string(balCats(5))
                'Afterload'
                'Preload'
                ];
        h_leg = legend(leg_entries,'Location','southeastoutside','NumColumns',1);
        h_leg.Title.String = 'Catheter and clamp';
        h_leg.Box = 'off';
        
        %xlabel(h_tiles, 'Common X label')
        ylabel(h_tiles, var,'Interpreter','none')
        title(h_tiles, title_str,'Interpreter','none')
    
    end
    
    
