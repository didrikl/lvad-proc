function hd = make_multiple_notch_filter(notches, fs, notch_width, filterOrder)
    
    if nargin<3, notch_width = 1; end
    if nargin<4, filterOrder = 2; end    
    if numel(notches)==0
        hd = [];
        return
    end    
    if isnan(fs)
        warning('Sampling frequency can not be NaN')
        return; 
    end

     if numel(notch_width)==1 
         notch_width = repmat(notch_width,numel(notches),1);
     end
     for i=1:numel(notches)      
 		if notch_width(i)<2.6
			f{i} = fdesign.notch('N,F0,BW',filterOrder,notches(i),notch_width(i),fs);
		else
			f{i} = fdesign.notch('N,F0,BW',10,notches(i),notch_width(i),fs);
		end
		h{i} = design(f{i});       
     end
    
hd = dfilt.cascade(h{:});


