function h_fig = plot_effects_in_speed_tiles_with_errorbars_symmetric(...
        T,yVars,type,T_err_neg,T_err_pos)
    
    if nargin<5, T_err_pos = T_err_neg; end
    
    markers = {'o','pentagram','square','diamond','hexagram'};
    err_bar_specs = {
        'LineWidth',2,...
        'LineStyle','none',...
        'MarkerSize',4,...
        'Clipping','on',...
        'MarkerFaceColor','auto',...
        'CapSize',8
        };
                 
    speeds = [2200,2500,2800,3100];
    
    balCats = {
        'Nominal'
        'PCI 1'
        'PCI 2'
        'PCI 3'
        'RHC'
        };
    
    ctrl_levels = {
        'Q reduced, 80%'
        'Q reduced, 60%'
        'Q reduced, 40%'
        'Q reduced, 20%'
        'Q reduced, 10%'
        };
    
    drop_inds = contains(string(T.analysis_id),'.1 #2') | T.contingency;
    T = T(not(drop_inds),:);
    T_err_neg = T_err_neg(not(drop_inds),:);
    T_err_pos = T_err_pos(not(drop_inds),:);
    if strcmpi(type{2},'medians')
        T_err_neg{:,yVars(:,1)} = T_err_neg{:,yVars(:,1)} - T{:,yVars(:,1)};
        T_err_pos{:,yVars(:,1)} = T_err_pos{:,yVars(:,1)} - T{:,yVars(:,1)};
    end
    
    for j=1:size(yVars,1)
        
        title_str = ['Plot 4_Group ',type{2},' of ',type{1},' Changes in ',yVars{j}];
        h_fig(j) = figure(...
            'Name',title_str,...
            'Position',[1.8,32.2,760.6,1038.4]);
        h_tiles = tiledlayout(4,1,...
            'TileSpacing', 'tight',...
            'Padding', 'tight'...
            );
        
        for s=1:numel(speeds)
            nexttile
            var = yVars{j,1};
            h_s = [];
            h_err = [];
            h = gca;
            
            diams = [];
            for i=1:numel(balCats)
                
                inds_i = T.categoryLabel==balCats(i) & T.pumpSpeed==speeds(s);
                T_i = T(inds_i,:);
                T_err_neg_i = T_err_neg(inds_i,:);
                T_err_pos_i = T_err_pos(inds_i,:);
                
                if strcmp(balCats{i},'Nominal') && strcmpi(type{1},'relative')
                    T_i.(var) = zeros(height(T_i),1);
                    T_err_neg_i.(var) = zeros(height(T_i),1);
                    T_err_pos_i.(var) = zeros(height(T_i),1);
                end
                                          
                hold on
                h.ColorOrderIndex=i;
                
                x = double(string(T_i.balloonDiam));
                x(isnan(x)) = 0;
                h_err(end+1) = errorbar(x,T_i.(var),T_err_neg_i.(var),T_err_pos_i.(var),...
                    err_bar_specs{:},...
                    'Marker',markers{i}...
                    );
                diams = [diams;x];
            end
            
            T_aft = T(T.categoryLabel=='Afterload increase',:);
            T_pre = T(T.categoryLabel=='Preload decrease',:);
            T_aft_err_neg = T_err_neg(T_err_neg.categoryLabel=='Afterload increase',:);
            T_pre_err_neg = T_err_neg(T_err_neg.categoryLabel=='Preload decrease',:);
            T_aft_err_pos = T_err_pos(T_err_pos.categoryLabel=='Afterload increase',:);
            T_pre_err_pos = T_err_pos(T_err_pos.categoryLabel=='Preload decrease',:);
            
            M = numel(ctrl_levels);
            for m=1:M
                T_aft.balloonDiam(T_aft.levelLabel==ctrl_levels(m)) = num2str(-M+m-1-0.08);
                T_pre.balloonDiam(T_pre.levelLabel==ctrl_levels(m)) = num2str(-M+m-1+0.08);
            end
            
            T_aft_n = T_aft(T_aft.pumpSpeed==speeds(s),:);
            T_aft_n_err_neg = T_aft_err_neg(T_aft_err_neg.pumpSpeed==speeds(s),:);
            T_aft_n_err_pos = T_aft_err_pos(T_aft_err_pos.pumpSpeed==speeds(s),:);
            x = double(string(T_aft_n.balloonDiam));
            h_err(end+1) = errorbar(x,T_aft_n.(var),T_aft_n_err_neg.(var),T_aft_n_err_pos.(var),...
                err_bar_specs{:},...
                'Marker',markers{1},...
                'Color',[0,0,0]);
                
            T_pre_n = T_pre(T_pre.pumpSpeed==speeds(s),:);
            T_pre_n_err_neg = T_pre_err_neg(T_pre_err_neg.pumpSpeed==speeds(s),:);
            T_pre_n_err_pos = T_pre_err_pos(T_pre_err_pos.pumpSpeed==speeds(s),:);
            x = double(string(T_pre_n.balloonDiam));
                
            h_err(end+1) = errorbar(x,T_pre_n.(var),T_pre_n_err_neg.(var),T_pre_n_err_pos.(var),...
                err_bar_specs{:},...
                 'Marker',markers{1},...
                 'Color',[0.5,0.5,0.5]);
             
            xline([0.5,2.83],...
                'LineWidth',0.75,...
                'LineStyle','--'...
                );
            
                
            xlim([-5.2,12.2])
            if not(isempty(yVars{j,2}))
                ylim(yVars{j,2})
            end
            
            
            if s==1
                xlims = xlim;
                ylims = ylim;
                text(-0.5*abs(xlims(1)),ylims(2)*0.95,{'\bf{Control}','\rm{Clamps and nominal}'},...
                    'FontSize',11,...
                    'HorizontalAlignment','center',...
                    'VerticalAlignment','top'...
                    );

                text(xlims(2)*0.5,ylims(2)*0.95,{'\bf{Effect}','\rm{Inflated balloons}'},...
                    'FontSize',11,...
                    'HorizontalAlignment','center',...
                    'VerticalAlignment','top'...
                    );
            end
            
            text(xlims(2)+1,ylims(2)*0.95,{[num2str(speeds(s)),' RPM']},...
                    'FontSize',12,...
                    'VerticalAlignment','top',...
                    'Color',[.2 .2 .2]...
                    ...'Rotation',-90 ...
                    );
                
            h = gca;
            h.XTick = [-5:1:-1,sort(diams)'];
            
            h.XTickLabel(1:5) = strrep(cellstr(string(ctrl_levels)),'Q reduced, ','');
            h.XTickLabelRotation = 90;
            h.YGrid = 'on';
            h.GridAlpha = 0.4;
            h.GridLineStyle = ':';
%            h.XTickLabel(ismember(h.XTickLabel,'0')) = '-';
            h.XTick(ismember(h.XTickLabel,'1.67')) = 1.59;
            h.XTick(ismember(h.XTickLabel,'1.73')) = 1.66;
            h.XTick(ismember(h.XTickLabel,'2.33')) = 2.35;
            h.XTickLabel{ismember(h.XTickLabel,'1.73')} = "\newline1.73";
            %h.YTickLabel = cellstr(string(100*str2double(h.YTickLabel))+"%");
            h.YTick(end) = [];
            
            if not(s==4)
                h.XTickLabel = {};
                %h.TickLength = [0,0];
            end
            h.TickLength = [0,0];
            h.FontSize = 10;
            
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
        h_leg = legend(h_err,leg_entries,...
            'Location','southeastoutside',...
            'Box','off',...
            'FontSize',11 ...
            );
        h_leg.Box = 'off';
        
        ylabel(h_tiles, {[type{1},' changes, '],var,''},'Interpreter','none')
        
    end
    
    
