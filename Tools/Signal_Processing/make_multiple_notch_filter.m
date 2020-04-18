function hd = make_multiple_notch_filter(notches,fs,BW,filterOrder)
    
    if nargin<3, BW = 1; end
    if nargin<4, filterOrder = 2; end
    
    if numel(notches)==0
        hd = [];
        return
    end
    
    if isnan(fs), return; end

    for i=1:numel(notches)
        
        f{i} = fdesign.notch('N,F0,BW',filterOrder,notches(i),BW,fs);
        h{i} = design(f{i});
        
    end
    
    hd = dfilt.cascade(h{:});
