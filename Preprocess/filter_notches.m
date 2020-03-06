function T = filter_notches(T,varName,notches,BW,new_varName)
    
    if nargin<5, new_varName = ''; end
    if nargin<4, BW = 1; end
    
    if numel(notches)==0
        return
    end
    
    filterOrder = 2;
    
    [fs,T] = get_sampling_rate(T);
    if isnan(fs), return; end
    
    
    for i=1:numel(notches)
        
        f{i} = fdesign.notch('N,F0,BW',filterOrder,notches(i),BW,fs);
        h{i} = design(f{i});
        
    end
    
    hd = dfilt.cascade(h{:});
    
    % To look at the filter response
    %hfvt= fvtool(hd,'Color','white');
    
    if new_varName
        T.(new_varName) = filter(hd,T.(varName));
    else
        T.(varName) = filter(hd,T.(varName));
    end