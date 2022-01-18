function save_to_png(h_fig,parts,segAnnot,orderMapVar,save_path,fig_subdir,rpms,seq_no,res)
    
    if nargin<9
        res = 300;
    end
    
    rpms = mat2str(rpms);
    parts = ['[',num2str(parts,'%2.2d '),']'];

    fig_name = sprintf('G1_Seq%d - %s - Part=%s - Variable=%s - RPM=%s',...
        seq_no,segAnnot,mat2str(parts),orderMapVar,mat2str(rpms));
    set(h_fig,'Name',fig_name);
    
    save_figure(fullfile(save_path,fig_subdir), fig_name, res)
end