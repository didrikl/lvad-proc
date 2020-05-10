function [map,order,rpmOut,time] = make_rpm_order_map(T, map_varName, ...
        maxFreq, rpm_varName, order_res, overlap_pst)
    % MAKE_RPM_ORDER_MAP
    %   Make RPM order map using Matlab's build-in RPM order plots.
    %   Detrending is applied, so that the DC component is attenuated
    %
    % See also DETREND, RPMORDERMAP
    
    if nargin<3, [maxFreq,T] = get_sampling_rate(T,false); end
    if nargin<4, rpm_varName = 'pumpSpeed'; end
    if nargin<5, order_res = 0.02; end
    if nargin<6, overlap_pst = 80; end
    
    [rpm_varName,map_varName] = check_table(T,rpm_varName,map_varName);
    [T, rpm_varName] = check_rpm_values(T,rpm_varName);
    [T,map_varName] = check_map_values(T,map_varName);

    if isnan(maxFreq)
        [maxFreq,~] = get_sampling_rate(T(:,{map_varName,rpm_varName}));
        if isnan(maxFreq), return; end
    end

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
  
function [rpm_varName,map_varName] = check_table(T,rpm_varName,map_varName)
    
    % Check existence of variables to use
    rpm_varName = check_var_input_from_table(T, rpm_varName);
    map_varName = check_var_input_from_table(T, map_varName);
    if height(T)==0
        error('No rows in table for RPM order map')
    end
    
function [T, rpm_varName] = check_rpm_values(T,rpm_varName)
    
    if iscategorical(T.(rpm_varName))
        T.(rpm_varName) = double(string(T.(rpm_varName)));
    end
    
    missing = isnan(T.(rpm_varName));
    if any(missing)
        warning(sprintf(['\n\tThere are %d missing/NaN values in RPM variable %s',...
            '\n\tThese rows are removed.'],nnz(missing),rpm_varName));
        T(missing,:) = [];
    elseif all(missing)
        error(['All values is NaN in RPM variable ',rpm_varName])
    end
         
function [T,map_varName] = check_map_values(T,map_varName)
    
    missing = isnan(T.(map_varName));
    if any(missing)
        warning(sprintf(['\n\tThere are %d NaN values in map variable %s',...
            '\n\tThese rows are removed.'],nnz(missing),map_varName));
        T(missing,:) = [];
    elseif all(missing)
        error(['All values is NaN in map variable ',map_varName])
    end
    