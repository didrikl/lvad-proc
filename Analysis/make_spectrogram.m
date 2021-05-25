function [s,f,t] = make_spectrogram(T,varname) 
    % MAKE_SPECTROGRAM
    % ...
    %
    % Usage
    %   make_spectrogram(signal,varname)
    %
    % See also spectrogram, detrend

%    [fs,T] = get_sampling_rate(T);
%    if isnan(fs), return; end

    overlap_pst = 80;
    
    % Relate window length to the no. of recorded samples to "no. of 4th 
    % harmonic rotations"-ratio, and multiply by the number of statistics 
    % (i.e. 4th harmonic event we want to capture)
    fs = 750;
    win_len = 1*fs;
    %min_speed = min(T.pumpSpeed)/60;
    %min_4th_harmonic = min_speed*4;
    %win_len = 100*fs/min_4th_harmonic;
    
    n_overlap_samp = min(ceil(overlap_pst/100*win_len),win_len-1); %n_overlap_samp = 80;%round(win_len/3);
    
    % FFT resolution: Use the nearest number that can be written 2-exponential,
    % which is optimal in the numerical FFT algorithm 
    n_fft = 2^nextpow2(60*fs); 

    %Remove a linear trend from a vector
    vec = detrend(double(T.(varname)));
    
    if nargout==3
        [s,f,t] = spectrogram(vec,win_len,n_overlap_samp,n_fft,fs);
    elseif nargout==2
        [s,f] = spectrogram(vec,win_len,n_overlap_samp,n_fft,fs);
    elseif nargout==1
        s = spectrogram(vec,win_len,n_overlap_samp,n_fft,fs);
    else
        spectrogram(vec,win_len,n_overlap_samp,n_fft,fs,'yaxis');
        
        %view(-77,72)
        %shading interp
        %colorbar off
    end
    
    
    
   