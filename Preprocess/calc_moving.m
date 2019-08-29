function signal = calc_moving(signal, input_varnames, statistic_types)
    % CALC_MOVING
    %   
    %
    % See also dsp
    %

    if nargin < 3
        statistic_types = {'RMS','Var','Std'};
    end
    
    win_length_fs_factor = 1;
    
    if not(iscell(input_varnames))
        input_varnames = {input_varnames};
    end

    fprintf('\nCalculating moving statistics:\n\n\tTable: %s',inputname(1))
    
    [fs,signal] = check_sampling_frequency(signal);
    if isnan(fs), return; end
    
    win_length = win_length_fs_factor*signal.Properties.SampleRate;
    fprintf('\n\tWindow length in samples: %d',win_length)
    fprintf('\n\tWindow length in duration: %d (sec)\n',win_length_fs_factor)
    
    for i=1:numel(input_varnames)

        for j=1:numel(statistic_types)
            
            suffix = ['_mov',statistic_types{j}];
            [input_varname,output_varname] = ...
                check_calc_io(signal,input_varnames{i},suffix);
            if isempty(output_varname), continue; end

            signal_vec = signal.(input_varname);
        
            switch lower(statistic_types{j})
                
                case 'rms'
                    MovRMSObj = dsp.MovingRMS(win_length);
                    signal.(output_varname) = MovRMSObj(signal_vec);
                    signal.Properties.VariableDescriptions(output_varname) = {sprintf(...
                        'Moving root mean sqaure (RMS)\n\tWindow length: %s',win_length)};
            
                case 'var'
                    MovVarObj = dsp.MovingVariance(win_length);
                    signal.(output_varname) = MovVarObj(signal_vec);
                    signal.Properties.VariableDescriptions(output_varname) = {sprintf(...
                        'Moving variance\n\tWindow length: %s',win_length)};
        
                case 'std'
                    
                    MovSTDObj = dsp.MovingStandardDeviation(win_length);
                    signal.(output_varname) = MovSTDObj(signal_vec);
                    signal.Properties.VariableDescriptions(output_varname) = {sprintf(...
                        'Moving standard deviation\n\tWindow length: %s',win_length)};
        
            end
             
            % Moving statistic samples before full window make less sence/can
            % cause confusion, hence setting these sample values as nan
            signal.(output_varname)(1:win_length,:) = nan;
            
            signal.Properties.VariableContinuity(output_varname) = 'continuous';
        
        end
        
    end