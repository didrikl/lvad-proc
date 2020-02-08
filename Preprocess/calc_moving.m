function T = calc_moving(T, input_varNames, statisticTypes, winDur_sec)
    % CALC_MOVING
    %   
    %
    % See also dsp
    %

    if nargin < 3
        statisticTypes = {'RMS','Std'};
    end
    
    if nargin<4
        winDur_sec = 1;
    end
    
    statisticTypes = cellstr(statisticTypes);
    input_varNames = cellstr(input_varNames);
    
    fprintf('\nCalculating moving statistics:\n\tTable: %s',inputname(1))
    
    [fs,T] = get_sampling_rate(T);
    if isnan(fs), return; end
    
    win_length = winDur_sec*fs;
    fprintf('\n\tWindow length in samples: %d',win_length)
    fprintf('\n\tWindow length in duration: %d (sec)\n',winDur_sec)
    
    for i=1:numel(input_varNames)
        
        fprintf('\n\tInput variable: %s\n',input_varNames{i})
        for j=1:numel(statisticTypes)
            
            suffix = ['_',num2str(win_length),'mov',statisticTypes{j}];
            [input_varname,output_varname] = ...
                check_calc_io(T,input_varNames{i},suffix);
            if isempty(output_varname), continue; end
            fprintf('\tOutput_varname variable: %s\n',output_varname)
            
            signal_vec = T.(input_varname);
            
            switch lower(statisticTypes{j})
                
                case 'rms'
                    MovRMSObj = dsp.MovingRMS(win_length);
                    T.(output_varname) = MovRMSObj(signal_vec);
                    T.Properties.VariableDescriptions(output_varname) = {sprintf(...
                        'Moving root mean sqaure (RMS)\n\tWindow length: %s',win_length)};
            
                case 'var'
                    MovVarObj = dsp.MovingVariance(win_length);
                    T.(output_varname) = MovVarObj(signal_vec);
                    T.Properties.VariableDescriptions(output_varname) = {sprintf(...
                        'Moving variance\n\tWindow length: %s',win_length)};
        
                case 'std'
                    
                    MovSTDObj = dsp.MovingStandardDeviation(win_length);
                    T.(output_varname) = MovSTDObj(signal_vec);
                    T.Properties.VariableDescriptions(output_varname) = {sprintf(...
                        'Moving standard deviation\n\tWindow length: %s',win_length)};
        
            end
             
            % Moving statistic samples before full window make less sence/can
            % cause confusion, hence setting these sample values as nan
            T.(output_varname)(1:win_length,:) = nan;
            
            T.Properties.VariableContinuity(output_varname) = 'continuous';
        
        end
        
    end