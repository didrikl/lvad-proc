function h_fig = plot_effects_in_speed_tiles_with_errorbars(T,yVars,type,T_err_neg,T_err_pos)
    
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
    T_err_neg = T_err_neg(not(drop_inds),:);
    T_err_pos = T_err_pos(not(drop_inds),:);
    
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
            h_s = [];
            
            diams = [];
            for i=1:numel(balCats)
                
                T_i = T(T.categoryLabel==balCats(i),:);
                T_i_err_neg = T_err_neg(T_err_neg.categoryLabel==balCats(i),:);
                T_i_err_pos = T_err_pos(T_err_pos.categoryLabel==balCats(i),:);
                h_ax = gca;
                hold on
                h_ax.ColorOrderIndex=i;
                
                T_mn = T_i(T_i.pumpSpeed==speeds(s),:);
                T_mn_err_neg = T_i_err_neg(T_i_err_neg.pumpSpeed==speeds(s),:);
                T_mn_err_pos = T_i_err_pos(T_i_err_pos.pumpSpeed==speeds(s),:);
                x = double(string(T_mn.balloonDiam));
                x(isnan(x)) = 0;
                h_s(end+1) = scatter(x,T_mn.(var),'filled',...
                    'Marker',markers{i},...
                    'MarkerFaceAlpha',0.75,...
                    'LineWidth',2 ...
                    );
                h_ax.ColorOrderIndex=i;
                errorbar(x,T_mn.(var),T_mn_err_neg.(var),T_mn_err_pos.(var),...
                    'LineStyle','none')
                diams = [diams;x];
            end
            
            T_aft = T(T.categoryLabel=='Afterload increase',:);
            T_pre = T(T.categoryLabel=='Preload decrease',:);
            T_aft_err_neg = T_err_neg(T_err_neg.categoryLabel=='Afterload increase',:);
            T_pre_err_neg = T_err_neg(T_err_neg.categoryLabel=='Preload decrease',:);
            
            M = numel(ctrl_levels);
            for m=1:M
                T_aft.balloonDiam(T_aft.levelLabel==ctrl_levels(m)) = num2str(-M+m-1-0.08);
                T_pre.balloonDiam(T_pre.levelLabel==ctrl_levels(m)) = num2str(-M+m-1+0.08);
            end
            
            T_aft_n = T_aft(T_aft.pumpSpeed==speeds(s),:);
            T_aft_n_err_neg = T_aft_err_neg(T_aft_err_neg.pumpSpeed==speeds(s),:);
            x = double(string(T_aft_n.balloonDiam));
            h_s(end+1) = scatter(x,T_aft_n.(var),'filled',...
                'Marker',markers{1},...
                'MarkerFaceAlpha',0.75,...
                'LineWidth',2, ...
                'MarkerFaceColor',[0,0,0]...
                );
             errorbar(x,T_aft_n.(var),T_aft_n_err_neg.(var),...
                 'LineStyle','none',...
                 'Color',[0,0,0])
                
            T_pre_n = T_pre(T_pre.pumpSpeed==speeds(s),:);
            T_pre_n_err = T_pre_err_neg(T_pre_err_neg.pumpSpeed==speeds(s),:);
            x = double(string(T_pre_n.balloonDiam));
            h_s(end+1) = scatter(x,T_pre_n.(var),'filled',...
                'Marker',markers{1},...
                'MarkerFaceAlpha',0.75,...
                'LineWidth',2, ...
                'MarkerFaceColor',[0.5,0.5,0.5]...
                );
                
            errorbar(x,T_pre_n.(var),T_pre_n_err.(var),...
                 'LineStyle','none',...
                 'Color',[0.5,0.5,0.5])
             
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
            
            if s==4
                leg_entries = [
                'No catheter'   
                string(balCats(2))
                string(balCats(3))
                string(balCats(4))
                string(balCats(5))
                'Afterload'
                'Preload'
                ];
            h_leg = legend(h_s,leg_entries,'Location','southeastoutside','NumColumns',1);
            h_leg.Title.String = 'Catheter and clamp';
            h_leg.Box = 'off';
            end
            
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
                
        
        
        %xlabel(h_tiles, 'Common X label')
        ylabel(h_tiles, var,'Interpreter','none')
        title(h_tiles, title_str,'Interpreter','none')
    
    end
    
    
