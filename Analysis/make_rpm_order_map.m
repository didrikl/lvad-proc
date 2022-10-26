function [map, order, rpmOut, time] = make_rpm_order_map(T, mapVarName, ...
        maxFreq, rpmVarName, orderRes, overlapPst)
    % MAKE_RPM_ORDER_MAP
    %   Make RPM order map using Matlab's build-in RPM order plots.
    %   Detrending is applied, so that the DC component is attenuated
    %
    % See also DETREND, RPMORDERMAP
    
    if nargin<3, maxFreq=NaN; end
    if nargin<4, rpmVarName = 'pumpSpeed'; end
    if nargin<5, orderRes = 0.02; end
    if nargin<6, overlapPst = 80; end
    
	map = [];
	order = [];
	rpmOut = [];
	time = [];
	
    n_rows = check_table_height(T);
    [maxFreq,T] = check_sampling_rate(maxFreq,T);
    if isnan(maxFreq) || n_rows==0
        fprintf('\nRPM order map not made\n')
        return; 
    end
    
    [rpmVarName, mapVarName] = check_table_cols(T, rpmVarName, mapVarName);
    T = check_missing_rpm_values(T, rpmVarName);
    T = check_rpm_as_zero_values(T, rpmVarName, mapVarName);
    T = check_map_values(T, mapVarName);
    
    % Remove DC component
    x = detrend(T.(mapVarName));
    %x = T.(map_varName);
    
    if nargout==0
        is_neg_rpm = T.(rpmVarName)<0;
        T.(rpmVarName)(is_neg_rpm) =  1000;
        T.(mapVarName)(is_neg_rpm) =  NaN;
        
        rpmordermap(x, maxFreq, T.(rpmVarName), orderRes, ...
            'Amplitude','power',...'peak',...'rms',
            'OverlapPercent',overlapPst,...
            'Scale','dB',...
            'Window',{'chebwin',80}...
            );
    else
        [map, order, rpmOut, time] = rpmordermap(x, maxFreq,T.(rpmVarName), orderRes, ...
            'Amplitude','power',...'peak',...'rms',
            'OverlapPercent',overlapPst,...
            'Scale','dB',...'linear',...
            'Window',{'chebwin',80}...
            ...'Window',{'kaiser',2}...
            ...'Window','flattopwin'... % not so good
            ...'Window','hamming'...
            ...'Window','hann'...
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
    
function [maxFreq, T] = check_sampling_rate(maxFreq, T)
    % if maxFreq is not explicitly given, try getting it from table without any
    % user interaction
    if isnan(maxFreq)
        [maxFreq, T] = get_sampling_rate(T, false);
    end
    
    % If still not determined, then try getting it by user interaction followed
    % by resampling.
    if isnan(maxFreq)
        [maxFreq,~] = get_sampling_rate(T(:,{map_varName,rpm_varName}));
    end
    
function [rpmVarName, mapVarName] = check_table_cols(T, rpmVarName, mapVarName)
    
    % Check existence of variables to use
    rpmVarName = check_table_var_input(T, rpmVarName);
    mapVarName = check_table_var_input(T, mapVarName);
    
function T = check_missing_rpm_values(T, rpmVarName)
    
    if iscategorical(T.(rpmVarName))
        T.(rpmVarName) = double(string(T.(rpmVarName)));
    end
    
    missing = isnan(T.(rpmVarName));
    if any(missing)
		fprintf('\n')
        warning(sprintf(['\n\tThere are %d missing/NaN values in RPM variable %s',...
            '\n\tThese rows are removed.'],nnz(missing),rpmVarName));
        T(missing,:) = [];
    elseif all(missing)
        error(['All values is NaN in RPM variable ',rpmVarName])
    end
    
    if height(T)==0
        warning('All rows were removed.')
    end

function T = check_rpm_as_zero_values(T, rpmVarName, map_varName)
    zeroSpeed = T.(rpmVarName)==0;
    if any(zeroSpeed)
		fprintf('\n')
        warning(sprintf(['%d rows have RPM=0 in RPM variable %s:',...
            '\n\tCorresponding map values are set to zero.',...
            '\n\tRPM=2400 is made as dummy substitute values.'],...
            nnz(zeroSpeed),rpmVarName));
        T.(rpmVarName)(zeroSpeed) = 2400;
        %T.(map_varName)(zeroSpeed) = 0;
    end
    
function [T, mapVarName] = check_map_values(T, mapVarName)
    
    missing = isnan(T.(mapVarName));
    if any(missing)
        warning(sprintf(['\n\tThere are %d NaN values in map variable %s',...
            '\n\tThese rows are removed.'],nnz(missing),mapVarName));
        T(missing,:) = [];
    elseif all(missing)
        error(['All values is NaN in map variable ',mapVarName])
    end
    