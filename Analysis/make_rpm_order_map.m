function make_rpm_order_map(data)
    % MAKE_RPM_ORDER_MAP
    %   Make RPM order map using Matlab's build-in RPM order plots.
    %   Detrending is applied, so that the DC component is attenuated
    %
    % Usage:
    %   make_rpm_order_map(data)
    %
    % See also DETREND, RPMORDERMAP
    
    %
    % TODO: Implement custom made STFT and visualization instead:
    % * To control more subplot info
    % * Avoid speed change transition artifacts
    % * To be able to calculate difference values and to do plotting for pre 
    % and post baselines (control interventions). Difference plots requires
    % either a cut-off, time axis stretch/aggregation so that RPM speed 
    % durations are equal. 
    %
    % NOTE: Waterfall plot example is likely irrelevant, since it does not have
    % any time axis.
    % 
    %
    
    var = 'accNorm';
    order_res = 0.1;
    overlap_pst = 80; % 70 percent perhaps slightly better...?
    
    rpm = str2double(string(data.pumpSpeed));
    x = detrend(data.(var));
    fs = data.Properties.SampleRate;
    
%     rpmordermap(x,fs,rpm,order_res, ...
%         'Amplitude','peak',...'power',...'rms',...'peak',...
%         'OverlapPercent',overlap_pst,...
%         'Scale','dB',...
%         ...'Window',{'chebwin',80}... % flattopwin perhaps slightly better...?
%         'Window','flattopwin'... 
%         );

    orderspectrum(x,fs,rpm)
