T = filter_notches(T,varName,notches,BW)

if nargin<4, notchWidth = 1; end

[fs,signal] = get_sampling_rate(signal);
if isnan(fs), return; end


for i=1:numel(notches)

   notchWidth =1;
% f0 = fdesign.notch('N,F0,BW',2,harm0,10,Fs);
% h0 = design(f0);
f1 = fdesign.notch('N,F0,BW',2,harm1,10,Fs);
h1 = design(f1);
% f2 = fdesign.notch('N,F0,BW',2,harm2,10,Fs);
% h2 = design(f2);
% hd = dfilt.cascade(h0, h1, h2);
% hfvt= fvtool(hd,'Color','white');

B.y = filter(h1,B.accA_norm);
make_rpm_order_map(B,'y')
pause
%make_rpm_order_map(B,'accA_norm')

[a,b,B.y2] = make_notch_filter(B.
accA_norm, Fs, harm1, BW);
make_rpm_order_map(B,'y2')
