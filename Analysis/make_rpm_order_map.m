function [map,order,rpmOut,time] = make_rpm_order_map(T, varName, maxFreq)
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
    
    if nargin<3
        maxFreq = nan;
    end
    
    order_res = 0.05;
    order_res = 0.1;
    overlap_pst = 80; %80; % greater percent is perhaps slightly better...?
    
    T = T(:,{varName,'pumpSpeed'});
    
    
    [fs,T] = get_sampling_rate(T,false);
    if isnan(maxFreq) && isnan(fs)
        [fs,T] = get_sampling_rate(T);
        if isnan(fs), return; end
    elseif not(maxFreq~=fs)
       T = resample_signal(T,maxFreq);
    end
    
    missingRPM = isnan(T.pumpSpeed);
    if any(missingRPM)
        warning(sprintf('%d rows have missing RPM',nnz(missingRPM)));
    end
    T(missingRPM,:) = [];
    x = detrend(T.(varName));

    if nargout==0
        rpmordermap(x,maxFreq,T.pumpSpeed,order_res, ...
            'Amplitude','peak',...'power',...'rms',...'peak',...
            'OverlapPercent',overlap_pst,...
            'Scale','dB',...
            'Window',{'chebwin',80}... % flattopwin perhaps slightly better...?
            ...'Window','flattopwin'...
            );
    else    
        [map,order,rpmOut,time] = rpmordermap(x,maxFreq,T.pumpSpeed,order_res, ...
            'Amplitude','peak',...'rms',...'power',...'rms',...'peak',...
            'OverlapPercent',overlap_pst,...
            'Scale','dB',...'linear',...
            'Window',{'chebwin',80}... % flattopwin perhaps slightly better...?
            ...'Window','flattopwin'... % not so good
            );
    end
  