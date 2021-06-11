function save_analysis_plots(h_figs,path,vars)
    resolution = 300;
    
    if nargin<2, vars = repmat('',numel,h_figs,1); end
    
    for i=1:numel(h_figs)
        save_figure(h_figs(i),fullfile(path,vars{i}),get(h_figs(i),'Name'),...
            resolution);
    end
    
    resp = ask_list_ui({'Yes','No'},'Close saved figures?',1);
    if resp==1
        close(h_figs)
    end
    
    clear save_figure