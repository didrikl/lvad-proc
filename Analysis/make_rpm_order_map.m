function make_rpm_order_map(data)
    % Make RPM order map using Matlab's build-in RPM order plots.
    %
    % Detrending is applied, so that the DC component is attenuated
    %
    % See also DETREND, RPMORDERMAP
    
    order_res = 0.1;
    
    rpm = str2double(string(data.pumpSpeed));
    rpmordermap(detrend(data.acc_length),data.Properties.SampleRate,rpm,order_res, ...
        'Amplitude','peak','OverlapPercent',80,'Window',{'chebwin',80});
