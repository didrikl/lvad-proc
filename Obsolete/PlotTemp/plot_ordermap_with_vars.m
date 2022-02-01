function [h_fig,map,order] = plot_ordermap_with_vars(...
        T,orderMapVar,plotVars,barVars,sampleRate,figName,BL)
    
    fprintf('\nMaking RPM order map with stacked variable plots\n')
    colScale = [-95,-30];
    colScale = [-85,-45]; % best for 6mm x 8mm catheter, x,y and z
    colScale = [-80,-40]; % best for 6mm x 8mm catheter, x and z, filtered
    ymax = 6;
 
    [T,orderMapVar,plotVars] = check_input_data(T,orderMapVar,plotVars);
    
    h_fig = figure('WindowState','maximized','Name',figName);
    h_sub(1) = subplot(2,1,1,...
        'Position',[0.10 0.4589 0.8 0.5411]);
    
    [map,order,~,time] = make_rpm_order_map(T,orderMapVar,sampleRate); %
     imagesc(time,order,map);
     caxis(colScale);
     
    
    
    
%     order_spec = orderspectrum(map,order,'Amplitude','peak');
%      [bl_map,bl_order] = make_rpm_order_map(BL,orderMapVar,sampleRate); %
%      bl_orderspec = orderspectrum(bl_map,bl_order,'Amplitude','peak');
%      try
%          corr_map = map+bl_orderspec;
%      catch
%          disp hei
%      end
%      imagesc(time,bl_order,corr_map);
%      caxis([-3,11]);
        
    
    
    

    
    
    
    
    h_mapAx = gca;
    set(h_mapAx,'ydir','normal');
    ylabel('Harmonics');
    h_mapAx.YLim(2) = ymax;
    
    % Adding bars at top of order map with categoric values
    T.dur = linspace(0,time(end),height(T))';
    blocks = add_cats_bar(h_sub(1),T,barVars);
    
    for i=1:numel(blocks.end_inds)-1
        line_pos = T.dur(blocks.end_inds(i));
        xline(T.dur(blocks.end_inds(i)),':','Color',[255, 18, 18]/256,'LineWidth',1.5);
        
        % Make a thick white stripe between each part (indicating a possible
        % break)
        %xline(T.dur(blocks.end_inds(i)),'-','Color',[1, 1, 1],'LineWidth',2);
    end
    
    subplot(2,1,2,'Position',[0.10,0.04430,0.8,0.4069]);
    add_stacked_plot(T,plotVars);
    xlabel('Time (sec)')
    
function s = add_stacked_plot(T,plotVars)
    
    %T.accA = T.accA - mean(T.accA,'omitnan');
    
    T.dur_sec = seconds(T.dur);
    T = timetable2table(T);
    
    s = stackedplot(T,plotVars,'XVariable','dur_sec',...
        'GridVisible','on',...
        'LineWidth',0.5...
        );
    
    s.DisplayLabels = cellstr(repmat(' ',numel(s.DisplayLabels),1));
    s.LineWidth = 1;
    s.GridVisible = 'off';
    
    
function blocks = add_cats_bar(h_ax,T,bars)
    
    font_size = 8;
    font_weight = 'normal';
    alpha=1;
    
    hold on
    
    bar_no=0;
    annot_str = {};
    vars = bars(:,1);
    Cmaps = bars(:,2);
    [blocks,vars] = find_cat_blocks(T,vars);
    
    h_ax.YLim(1) = h_ax.YLim(1)-0.005;
    h_ax.XAxis.Visible = 'off';
    for i=1:numel(vars)
        
        % Fixed list of categories (useful for keeping category color order)
        cats = get_cats(T,vars{i});
        
        % If there is only one categoric value: use text box instead.
        if numel(unique(string(T.(vars{i}))))<2
            annot_str{i-bar_no+1} = vars{i}+" = "+string(T.(vars{i})(1));
            continue
        end
        
        % use 4 percent of height of subfigure for each bar
        h_ax.Units = 'points';
        barWidth = 0.074*h_ax.Position(4);
        h_ax.Units = 'normalized';
        
        bar_no=bar_no+1;
        h_ax.YLim(1) = h_ax.YLim(1)-0.21;
        yPos = h_ax.YLim(1)+0.13;
        
        h_ax.ColorOrder = Cmaps{i};
        h_ax.ColorOrderIndex=1;
        
        for j=1:numel(cats)
            
            barTime = T.dur(T.(vars{i})==cats(j));
            if numel(barTime)==0, continue; end
            n_blocks = numel([blocks.start_durSec{i,j,:}]);
            barVal = repmat(yPos,1,numel(barTime));
            h_bar = plot(h_ax,barTime,barVal,'LineWidth',barWidth);
            h_bar.Color = [h_bar.Color,alpha];
            
            barText = cats{j};
            if barText=="-"
                barText = "NA";
                h_bar.Color = [.85, .85, .85, alpha];
            end
            
            for k=1:n_blocks
                xPos = (blocks.start_durSec{i,j,k}+blocks.end_durSec{i,j,k})/2;
                text(xPos,yPos,""+barText,...
                    'HorizontalAlignment','center',...
                    'FontSize',font_size,...
                    'FontWeight',font_weight);
            end
            
        end
        
        % Add bar annotation outside the plot
        text(0,yPos,vars{i}+" ",...
            'HorizontalAlignment','right',...
            'FontSize',font_size)
        
    end
    
    if numel(annot_str)>0
        text(1.013,0.95,annot_str,...
            'Units','normalized',...
            'EdgeColor',[0 0 0],...
            'FontSize',font_size,...
            'FontWeight',font_weight)
    end
    
    h_ax.YTick(h_ax.YTick<0) = [];
    

        
function [T,orderMapVar,plotVars] = check_input_data(T,orderMapVar,plotVars)
    
    % Check of input variable names
    orderMapVar = check_table_var_input(T, orderMapVar);

    % Check of input variable values
    nanRows = isnan(T.(orderMapVar));
    if height(T)==0
        warning('No rows in data table');
    elseif all(nanRows)
        error('All values for RPM order map is NaN');
    elseif any(nanRows)
        warning ('There are %d rows with NaN values removed',nnz(nanRows))
        T(nanRows,:) = [];
    end
    
    for i=1:numel(plotVars)
        plotVars{i} = check_table_var_input(T, plotVars{i});
    end
    