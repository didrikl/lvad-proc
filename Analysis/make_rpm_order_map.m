function [map,order,rpmOut,time] = make_rpm_order_map(T, map_varName, ...
        maxFreq, rpm_varName, order_res, overlap_pst)
    % MAKE_RPM_ORDER_MAP
    %   Make RPM order map using Matlab's build-in RPM order plots.
    %   Detrending is applied, so that the DC component is attenuated
    %
    % See also DETREND, RPMORDERMAP
    
    % NOTE: Waterfall plot example is likely irrelevant, since it does not have
    % any time axis.
    
    if nargin<3, [maxFreq,T] = get_sampling_rate(T,false); end    
    if nargin<4, rpm_varName = 'pumpSpeed'; end
    if nargin<5, order_res = 0.05; end
    if nargin<6, overlap_pst = 80; end
    
    map_varName = check_var_input_from_table(T, map_varName);
    rpm_varName = check_var_input_from_table(T, rpm_varName);
    
    if isnan(maxFreq)
        [maxFreq,~] = get_sampling_rate(T(:,{map_varName,rpm_varName}));
        if isnan(maxFreq), return; end
    end
    
    % Ensure numeric pumpspeed, and remove rows for missing (NaN) rpm values
    [T, rpm_missing] = check_rpm_var(T,rpm_varName);
    T(rpm_missing,:) = [];
    
    % Remove DC component
    x = detrend(T.(map_varName));
    
    if nargout==0
        rpmordermap(x,maxFreq,T.(rpm_varName),order_res, ...
            'Amplitude','peak',...'power',...'rms',
            'OverlapPercent',overlap_pst,...
            'Scale','dB',...
            'Window',{'chebwin',80}...
            );
    else
        [map,order,rpmOut,time] = rpmordermap(x,maxFreq,T.(rpm_varName),order_res, ...
            'Amplitude','peak',...'rms',...'power',
            'OverlapPercent',overlap_pst,...
            'Scale','dB',...'linear',...
            'Window',{'chebwin',80}...
            ...'Window','flattopwin'... % not so good
            ...'Window','hamming'...
            );
    end
    
    
    function [T, missing] = check_rpm_var(T,rpm_varName)
        
        if iscategorical(T.(rpm_varName))
            T.(rpm_varName) = double(string(T.(rpm_varName)));
        end
        missing = isnan(T.(rpm_varName));
        if any(missing)
            warning(sprintf('%d rows have missing RPM',nnz(missing)));
        end