function [h_fig,map,order] = plot_ordermap_with_vars(P,orderMapVar,plotVars)
        
    if height(P)==0
        warning('No rows for part(s)');
        return
    end
        
    sampleRate  = 540;
%     sampleRate = P.Properties.CustomProperties.SensorSampleRate(orderMapVar);
%     if isnan(sampleRate), sampleRate = get_sampling_rate(P); end

    h_fig = figure('WindowState','maximized');

    h_sub(1) = subplot(2,1,1,'Position',[0.13 0.4589 0.775 0.5411]);
     
    [map,order,~,time] = make_rpm_order_map(P,orderMapVar,sampleRate); %
    %make_rpm_order_map(P,orderMapVar,sampleRate); %
    %orderspectrum(map,order,'Amplitude','rms');
    imagesc(time,order,map);
    %caxis([-65,-30]);
    set(gca,'ydir','normal');
    ylabel('Harmonics');
    P.dur = linspace(0,time(end),height(P))';
    P.dur_sec = seconds(P.dur);
    
    P.pumpSpeed = categorical(P.pumpSpeed);
    add_cats_bar(h_sub(1),P,order,{'pumpSpeed','balloonLevel','flowReduction'});
    
    subplot(2,1,2,'Position',[0.13,0.04430,0.775,0.4069]);
    %plotVarFunc()
    add_stacked_plot(P,plotVars)
    xlabel('Time (sec)')
    
    
    
function add_stacked_plot(P2,plotVars)
    
    P2 = mergevars(P2,{'affP','effP'},'NewVariableName','P');
    P2 = mergevars(P2,{'affQ','effQ','Q_noted'},'NewVariableName','Q');
    P2 = mergevars(P2,{'accA_x','accA_y','accA_y'},'NewVariableName','accA');
    
    %P2.accA_movRMS = P2.accA_movRMS - mean(P2.accA_movRMS,'omitnan');
    P2.accA = P2.accA - mean(P2.accA,'omitnan');
     
    T = timetable2table(P2(:,plotVars));
    T = T(:,plotVars);
    T.dur_sec = P2.dur_sec;
    s = stackedplot(T,'XVariable','dur_sec',...
        'GridVisible','on',...
        'LineWidth',1.25...
        );
    
    
function add_cats_bar(h_ax,P2,order,barVars)
    
    barWidth=17;
    hold on
    
    Cmap = brewermap(10,'Accent'); % Select colormap length, select any colorscheme.
    h_ax.ColorOrder = Cmap;
    h_ax.ColorOrderIndex = 2;

    ii=1;
    annot_str = {};
    for i=1:numel(barVars)
        
        % If there is only one categoric value: use text box instead.
        if numel(unique(string(P2.(barVars{i}))))<2
            annot_str{i-ii+1} = barVars{i}+"="+string(P2.(barVars{i})(1));
            continue
        end
            
        % fixed list of categories (useful for keep the same plot color for each
        % category)
        varCats = categories(P2.(barVars{i}));
        
        barYPos = max(order)-0.18+(ii-1)*0.4;
        ii=ii+1;
        for j=1:numel(varCats)
            
            barTime = P2.dur(P2.(barVars{i})==varCats(j));
            if numel(barTime)==0, continue; end
            
            barVal = repmat(barYPos,1,numel(barTime));
            h_plot = plot(h_ax,barTime,barVal,'LineWidth',barWidth);
            
            h_plot.Color = [h_plot.Color,1];
            if string(varCats(j))=="-"
                text(barTime(1)+1,barYPos,"Baseline",...
                    'HorizontalAlignment','left');
            else
                text(barTime(1)+1,barYPos,"Balloon level "+string(varCats(j)),...
                    'HorizontalAlignment','left');
            end
        end
    end
    if numel(annot_str)>1
        annotation('textbox',[0.15 0.7 0.2 0.2],'String',annot_str,'FitBoxToText','on');
    end   
    