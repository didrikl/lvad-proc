function T = filter_notches(T,varName,notches,BW)

if nargin<4, BW = 1; end

filterOrder = 2;

[fs,T] = get_sampling_rate(T);
if isnan(fs), return; end


for i=1:numel(notches)

    f{i} = fdesign.notch('N,F0,BW',filterOrder,notches(i),BW,fs);
    h{i} = design(f{i});
    
end

hd = dfilt.cascade(h{:});
hfvt= fvtool(hd,'Color','white');
T.([varName,'_hFilt']) = filter(hd,T.(varName));
