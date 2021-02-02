function [map,order,rpmOut,time] = make_rpm_order_map(T, map_varName, ...
        maxFreq, rpm_varName, order_res, overlap_pst)
    % MAKE_RPM_ORDER_MAP
    %   Make RPM order map using Matlab's build-in RPM order plots.
    %   Detrending is applied, so that the DC component is attenuated
    %
    % See also DETREND, RPMORDERMAP
    
    if nargin<3, maxFreq=NaN; end
    if nargin<4, rpm_varName = 'pumpSpeed'; end
    if nargin<5, order_res = 0.02; end
    if nargin<6, overlap_pst = 80; end
    
    n_rows = check_table_height(T);
    [maxFreq,T] = check_sampling_rate(maxFreq,T);
    if isnan(maxFreq) || n_rows==0
        fprintf('\nRPM order map not made\n')
        return; 
    end
    
    [rpm_varName,map_varName] = check_table_cols(T,rpm_varName,map_varName);
    T = check_missing_rpm_values(T,rpm_varName);
    T = check_rpm_as_zero_values(T,rpm_varName,map_varName);
    T = check_map_values(T,map_varName);
    
    % Remove DC component
    x = detrend(T.(map_varName));
    %x = T.(map_varName);
    
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
            ...'Window',{'kaiser',2}...
            ...'Window','flattopwin'... % not so good
            ...'Window','hamming'...
            );
    end

function n_rows = check_table_height(T)
    n_rows = height(T);
    if n_rows==0
        warning('No data rows to make RPM order map');
    end
    if n_rows<100
        warning('There are too few rows to make RPM order map');
    end
    
function [maxFreq,T] = check_sampling_rate(maxFreq,T)
    % if maxFreq is not explicitly given, try getting it from table without any
    % user interaction
    if isnan(maxFreq)
        [maxFreq,T] = get_sampling_rate(T,false);
    end
    
    % If still not determined, then try getting it by user interaction followed
    % by resampling.
    if isnan(maxFreq)
        [maxFreq,~] = get_sampling_rate(T(:,{map_varName,rpm_varName}));
    end
    
function [rpm_varName,map_varName] = check_table_cols(T,rpm_varName,map_varName)
    
    % Check existence of variables to use
    rpm_varName = check_table_var_input(T, rpm_varName);
    map_varName = check_table_var_input(T, map_varName);
    
function T = check_missing_rpm_values(T,rpm_varName)
    
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
    
    if height(T)==0
        warning('All rows were removed.')
    end

function T = check_rpm_as_zero_values(T,rpm_varName,map_varName)
    zeroSpeed = T.(rpm_varName)==0;
    if any(zeroSpeed)
        warning(sprintf(['%d rows have RPM=0 in RPM variable %s:',...
            '\n\tCorresponding map values are set to zero.',...
            '\n\tRPM=1000 is made as dummy substitute values.'],...
            nnz(zeroSpeed),rpm_varName));
        T.(rpm_varName)(zeroSpeed) = 2400;
        T.(map_varName)(zeroSpeed) = 0;
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
    