function fig_name = make_fig_name_IV2(h_fig,h_ax,parts,segAnnot,orderMapVar,rpms,seq_no)

% TODO: Store this info with OO or with axes userdata, instead of function input
rpms = mat2str(rpms);

yyaxis(h_ax(2),'left')
clims = mat2str(h_ax(2).CLim);

% Make zero-padded list of parts (for natural sorting)
% TODO: Store this info with OO or with axes userdata, instead of function input
parts = ['[',num2str(parts,'%2.2d '),']'];

fig_name = sprintf('IV2_Seq%d - %s - RPM=%s - %s %s - Part=%s',...
    seq_no,segAnnot,strrep(mat2str(rpms),'''',''),orderMapVar,clims,parts);

set(h_fig,'Name',fig_name);