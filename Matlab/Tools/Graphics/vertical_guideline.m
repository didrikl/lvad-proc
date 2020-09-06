function hCur = vertical_guideline(h_axes)
    
    pt = [NaN, NaN];
    
    h_pan = pan(gcf);
    if strcmp(h_pan.Enable,'on') 
        return; 
    end
    
    datacursormode off
    h_fig = gcf;
    h_fig.WindowButtonDownFcn
    set(gcf, ...
        'WindowButtonDownFcn', @clickFcn, ...
        'WindowButtonUpFcn', @unclickFcn);
    
    % Set up cursor text
    ax = gca;
    axes(h_axes(2));
    text(1,-.28, '','units','normalized','HorizontalAlignment','right','FontSize', 8, 'Color',[0.1, 0.1, 0.1]);
    axes(ax);
    
    hCur = nan(1, length(h_axes));
    for id = 1:length(h_axes)
        hCur(id) = line([NaN NaN], ylim(h_axes(id)), 'Parent', h_axes(id),...
            'Color', [.8 .1 .9],...
            'LineWidth',1.25,...
            'Tag','vertical_guideline'...
            );
    end
    
    function clickFcn(varargin)
        % Initiate cursor if clicked anywhere but the figure
        if strcmpi(get(gco, 'type'), 'figure')
            try set(hCur, 'XData', [NaN NaN]); end                % <-- EDIT
        else
            set(gcf, 'WindowButtonMotionFcn', @dragFcn)
            dragFcn()
        end
    end
    function dragFcn(varargin)
        % Get mouse location
        pt = get(gca, 'CurrentPoint');
        % Update cursor line position
        try set(hCur, 'XData', [pt(1), pt(1)]); end
    end
    function unclickFcn(varargin)
        set(gcf, 'WindowButtonMotionFcn', '');
        pt = get(gca, 'CurrentPoint');
        %t_str = datetime(pt(1),'ConvertFrom','datenum');
        %set(h_t ,'String',sprintf('Marker: %s',t_str),'Position',[1,-.35],'units','normalized','HorizontalAlignment','right')
    end
    
%     handles.UserData.h_Vertical_Guideline = hCur;
%     handles.UserData.h_Vertical_Guideline_txt = h_t;
%     handles.UserData.Vertical_Guideline_pt = pt;
end