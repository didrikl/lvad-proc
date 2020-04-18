function T = calc_moving(T, varNames, statisticTypes, nSamples)
    % CALC_MOVING Calculate moving stastistic in a timetable
    %   
    % See also dsp
    %

    statisticTypes = cellstr(statisticTypes);
    varNames = cellstr(varNames);
    
    [fs,T] = get_sampling_rate(T);
    if isnan(fs), return; end
    
    for i=1:numel(varNames)
        
        for j=1:numel(statisticTypes)
            
            % NOTE: Could implement later a more robust check, but is dropped
            % for now, since it is  much interaction and complications with it
%             suffix = ['_','mov',statisticTypes{j}];                        
%             [varName,movVarName] = check_calc_io(T,varNames{i},suffix);
%             if isempty(movVarName), continue; end

            movVarName = [varNames{i},'_','mov',statisticTypes{j}];
            vec = T.(varNames{i});
            
            switch lower(statisticTypes{j})
                
                case 'rms'
                    MovRMSObj = dsp.MovingRMS(nSamples);
                    T.(movVarName) = MovRMSObj(vec);
                    descr = 'root-mean-square';
                case 'var'
                    MovVarObj = dsp.MovingVariance(nSamples);
                    T.(movVarName) = MovVarObj(vec);
                    descr = 'variance';
                case 'std'
                    MovSTDObj = dsp.MovingStandardDeviation(nSamples);
                    T.(movVarName) = MovSTDObj(vec);
                    descr = 'standard deviation';
                otherwise                  
                    error(['Statistic type ',statisticTypes{j},'not supported.'])
                    
            end
             
            % Moving statistic samples before full window make less sence/can
            % cause confusion, hence setting these sample values as nan
            T.(movVarName)(1:nSamples,:) = nan;
           
            T.Properties.VariableContinuity(movVarName) = 'continuous';
            T.Properties.VariableDescriptions(movVarName) = {sprintf(...
                'Moving %s\n\t%s\n\tSample rate: %d\n\tWindow lengths (samples)',...
                descr,fs,nSamples)};
            
            
        end
        
    end