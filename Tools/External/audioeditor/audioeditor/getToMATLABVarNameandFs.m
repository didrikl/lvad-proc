function [VarName, FsName] = getToMATLABVarNameandFs
%getToMATLABVarNameandFs Helper to export data to MATLAB workspace

%   Copyright 2008 The MathWorks, Inc.
%   Author: Navan Ruthramoorthy

    VarName = '';
    FsName = '';
    FigureHandle = figure( ...
                    'Visible','off', ...
                    'Menubar','none', ...
                    'Toolbar','none', ...
                    'Position', [360,500,320,150], ...
                    'IntegerHandle', 'off', ...
                    'Color',    get(0, 'defaultuicontrolbackgroundcolor'), ...
                    'NumberTitle', 'off', ...
                    'Name', 'Audio Editor: Export to MATLAB');
    movegui(FigureHandle, 'center');
    uicontrol('Parent', FigureHandle, 'Style', 'Text', ...
              'String', 'Choose Variable names', ...
              'Units', 'Normalized', 'Position', [0 0.8 1 0.2], ...
              'FontSize', 12);
    uicontrol('Parent', FigureHandle, 'Style', 'Text', ...
              'String', 'Audio data:', ...
              'Units', 'Normalized', 'Position', [0 0.5 0.5 0.2], ...
              'FontSize', 12);
    hy = uicontrol('Parent', FigureHandle, 'Style', 'edit', ...
              'String', 'y', ...
              'Units', 'Normalized', 'Position', [0.5 0.5 0.45 0.2], ...
              'HorizontalAlignment', 'left', ...
              'FontSize', 12, 'BackgroundColor', 'white');
    uicontrol('Parent', FigureHandle, 'Style', 'Text', ...
              'String', 'Sampling frequency:', ...
              'Units', 'Normalized', 'Position', [0 0.3 0.5 0.2], ...
              'FontSize', 12);
    hFs = uicontrol('Parent', FigureHandle, 'Style', 'edit', ...
              'String', 'Fs', ...
              'Units', 'Normalized', 'Position', [0.5 0.3 0.45 0.2], ...
              'HorizontalAlignment', 'left', ...
              'FontSize', 12, 'BackgroundColor', 'white');
    uicontrol('Parent', FigureHandle, 'Style', 'pushbutton', ...
              'String', 'Export', 'Units', 'Normalized', ...
              'Position', [0.1 0 .4 0.2], 'FontSize', 12, ...
              'Callback', @selectCallback);
    uicontrol('Parent', FigureHandle, 'Style', 'pushbutton', ...
              'String', 'Cancel', 'Units', 'Normalized', ...
              'Position', [0.5 0 .4 0.2], 'FontSize', 12, ...
              'Callback', @cancelCallback);
    set(FigureHandle', 'CloseRequestFcn', @cancelCallback);
    set(FigureHandle,'Visible','on');
    uiwait(FigureHandle);

    function selectCallback(h, evd) %#ok<INUSD,INUSD>
        VarName = get(hy, 'String');
        FsName = get(hFs, 'String');
        delete(FigureHandle);
    end
    function cancelCallback(h, evd) %#ok<INUSD,INUSD>
        delete(FigureHandle);
    end
end
