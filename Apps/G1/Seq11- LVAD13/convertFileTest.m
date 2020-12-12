in_matname = 'C:\Data\IVS\Didrik\G1 - Simulated pre-pump and in situ thrombosis\Seq8 - LVAD1\Recorded\PowerLab\G1_Seq8 - F3 - pG,pLV.mat';
out_matname = 'C:\Data\IVS\Didrik\G1 - Simulated pre-pump and in situ thrombosis\Seq8 - LVAD1\Recorded\PowerLab\G1_Seq8 - F3 - pG,pLV - new.mat';
S = whos('-file', in_matname)
for K = 1 : length(S)
  thisvarname = S.name
  datastruct = load(in_matname, thisvarname);
  save(out_matname, '-v7.3', '-struct', 'datastruct', '-append');
end