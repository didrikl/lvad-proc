function spec = make_average_order_spectrum(data,varargin)
    % MAKE_AVERAGE_ORDER_SPECTRUM
    %   Calculate to average values of each frequency order within a time-window
    %   using Matlab's build-in orderspectrum function. Detrending is applied, 
    %   so that the DC component is attenuated
    %
    % Usage:
    %   make_average_order_spectrum(data)
    %
    % See also ORDERSPECTRUM, DETREND, RPMORDERMAP
    
    % TODO: Implement custom made STFT and visualization instead:
    % * To control more subplot info
    % * Avoid speed change transition artifacts
    % * To be able to calculate difference values and to do plotting for pre 
    % and post baselines (control interventions). Difference plots requires
    % either a cut-off, time axis stretch/aggregation so that RPM speed 
    % durations are equal. 
    
    % NOTE: Waterfall plot example is likely irrelevant, since it does not have
    % any time axis.
    
    var = 'accNorm';
    order_res = 0.1;
    
    rpm = str2double(string(data.pumpSpeed));
    x = detrend(data.(var));
    fs = data.Properties.SampleRate;
    
    [map,order] = rpmordermap(x,fs,rpm,order_res);
     
    spec = orderspectrum(map,order);
    
    focus_inds = order>0.5 & order<4.5;
    
    %plot(order(focus_inds), pow2db(spec(focus_inds)),varargin{:})
    %ylabel('Order Power Amplitude (dB)')

    plot(order(focus_inds), spec(focus_inds),varargin{:})
    ylabel('Order RMS Amplitude')
    %set(gca, 'YScale', 'log')
     
     xlabel('Order Number')
     grid on
     
     datestr(data.timestamp(1))
     
end
