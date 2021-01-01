function T = calc_moving(T, varNames, newVarNames, statisticTypes, winLength)
    % CALC_MOVING Calculate moving stastistic in a timetable
    %   
    % See also dsp
    %

    [~,varNames] = get_cell(varNames);
    [~,statisticTypes] = get_cell(statisticTypes);
    [fs,T] = get_sampling_rate(T);
    nSamples = fs*winLength;
        
    % TODO: Develop get_cell to handle this:
    %[~,nSamples] = get_cell(nSamples);
    
    if numel(nSamples)==1 
        nSamples = repmat(nSamples,numel(statisticTypes),1);
    elseif numel(nSamples)~=numel(statisticTypes)
        error(['Number of values in nSamples must be one or equal to number',... 
            'the number of statistic types in statisticTypes'])
    end

%     if numel(newVarNames)~=numel(statisticTypes)
%         error(['Number of output variable names in newVarNames must equal',...
%             'the number of statistic types in statisticTypes'])
%     end

    unsupported = not(ismember(statisticTypes,...
        {'rms','var','std','min','max','avg'}));
    if any(unsupported)
        warning(sprintf('Unsupported stastitics types given:\n\t%s',...
            strjoin(statisticTypes(unsupported),', ')))
    end
        
    for i=1:numel(varNames)
        
        for j=1:numel(statisticTypes)
            
            %movVarName = [varNames{i},'_','mov',statisticTypes{j}];
            vec = T.(varNames{i});
            
            switch lower(statisticTypes{j})
                
                case 'rms'
                    MovObj = dsp.MovingRMS(nSamples(i));
                    descr = 'root-mean-square';
                case 'var'
                    MovObj = dsp.MovingVariance(nSamples(i));
                    descr = 'variance';
                case 'std'
                    MovObj = dsp.MovingStandardDeviation(nSamples(i));
                    descr = 'standard deviation';
                case 'min'
                    MovObj = dsp.MovingMinimum(nSamples(i));
                    descr = 'moving minimum';
                case 'max'
                    MovObj = dsp.MovingMaximum(nSamples(i));
                    descr = 'moving maximum';
                case 'avg'
                    MovObj = dsp.MovingAverage(nSamples(i));
                    descr = 'moving average';
                    
                otherwise                  
                    error(['Statistic type ',statisticTypes{j},'not supported.'])
                     
            end
            
            T.(newVarNames{j}) = MovObj(vec);
            
            % Moving statistic samples before full window make less sence/can
            % cause confusion, hence setting these sample values as nan
            T.(movVarName)(1:nSamples,:) = nan;
           
            T.Properties.VariableContinuity(movVarName) = 'continuous';
            T.Properties.VariableDescriptions(movVarName) = {sprintf(...
                'Moving %s\n\t%s\n\tWindow lengths (samples)',...
                descr,nSamples)};
            
            
        end
        
    end