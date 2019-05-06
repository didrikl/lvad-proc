function make_rpm_order_map(data)
    % make_rpm_order_map
    %   Make RPM order map using Matlab's build-in RPM order plots.
    %   Detrending is applied, so that the DC component is attenuated
    %
    % Usage:
    %   make_rpm_order_map(data)
    %
    % See also DETREND, RPMORDERMAP
    
    order_res = 0.1;
    
    rpm = str2double(string(data.pumpSpeed));
    x = detrend(data.acc_length);
    fs = data.Properties.SampleRate;
    
    rpmordermap(x,fs,rpm,order_res, ...
        'Amplitude','peak',...
        'OverlapPercent',80,...
        ...'Window',{'chebwin',80}
        'Window','flattopwin'...
        );

    
    [map,fr,rp] = rpmfreqmap(x,fs,rpm,order_res, ...
        'Amplitude','peak',...
        'Window','flattopwin');
    
    % Draw the frequency-RPM map as a waterfall plot.
    [FR,RP] = meshgrid(fr,rp);
    waterfall(FR,RP,map')
    view(-6,60)
    xlabel('Frequency (Hz)')
    ylabel('RPM')
    zlabel('Amplitude')