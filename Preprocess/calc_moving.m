function T = calc_moving(T, varNames, statisticTypes, nSamples)
    % CALC_MOVING Calculate moving stastistic in a timetable
    %   
    % See also dsp
    %

    statisticTypes = cellstr(statisticTypes);
    varNames = cellstr(varNames);
    
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
                    MovObj = dsp.MovingRMS(nSamples);
                    descr = 'root-mean-square';
                case 'var'
                    MovObj = dsp.MovingVariance(nSamples);
                    descr = 'variance';
                case 'std'
                    MovObj = dsp.MovingStandardDeviation(nSamples);
                    descr = 'standard deviation';
                case 'min'
                    MovObj = dsp.MovingMinimum(nSamples);
                    descr = 'moving minimum';
                case 'max'
                    MovObj = dsp.MovingMaximum(nSamples);
                    descr = 'moving maximum';
                case 'avg'
                    MovObj = dsp.MovingAverage(nSamples);
                    descr = 'moving average';
                    
                otherwise                  
                    error(['Statistic type ',statisticTypes{j},'not supported.'])
                     
            end
            
            T.(movVarName) = MovObj(vec);
            
            % Moving statistic samples before full window make less sence/can
            % cause confusion, hence setting these sample values as nan
            T.(movVarName)(1:nSamples,:) = nan;
           
            T.Properties.VariableContinuity(movVarName) = 'continuous';
            T.Properties.VariableDescriptions(movVarName) = {sprintf(...
                'Moving %s\n\t%s\n\tWindow lengths (samples)',...
                descr,nSamples)};
            
            
        end
        
    end