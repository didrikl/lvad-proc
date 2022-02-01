function save_to_png_G1(h_fig,save_path,fig_subdir,res)
    
    if nargin<4, res = 300; end
    
    fig_name = h_fig.Name;
    fig_path = fullfile(save_path,fig_subdir);
    save_figure(h_fig, fig_path, fig_name, res)
    
    fprintf('\nSaved to disc.\n');
