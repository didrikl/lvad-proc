close all;
warning('off','verbose')
warning('off','backtrace')
clear Save_Table Save_Figure
if run_in_background
    current_default_figure_visible = get(0,'DefaultFigureVisible');
    set(0,'DefaultFigureVisible','off');
end