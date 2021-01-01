function T = calc_moving(T, varNames, newVarNames, statisticTypes, winLength)
    % CALC_MOVING Calculate moving stastistic in a timetable
    %   
    % See also dsp
    %

    supported_types = {'rms','var','std','min','max','avg'};
    
    [~,varNames] = get_cell(varNames);
    [~,statisticTypes] = get_cell(statisticTypes);
    [fs,T] = get_sampling_rate(T);
        
    % TODO: Develop get_cell to handle this:
    %[~,nSamples] = get_cell(nSamples);
    
    if numel(winLength)==1 
        winLength = repmat(winLength,numel(statisticTypes),1);
    elseif numel(winLength)~=numel(statisticTypes)
        error(['Number of values in nSamples must be one or equal to number',... 
            'the number of statistic types in statisticTypes'])
    end

     if numel(newVarNames)~=numel(statisticTypes)*numel(varNames)
         error(['Number of newVarNames must equal to',...
             'the number of statisticTypes times number of varNames'])
     end

    unsupported = not(ismember(statisticTypes,supported_types));
    if any(unsupported)
        warning(sprintf('Unsupported stastitics types given:\n\t%s',...
            strjoin(statisticTypes(unsupported),', ')))
    end
        
    newVarNames = reshape(newVarNames,numel(statisticTypes),numel(varNames));
    
    for j=1:numel(varNames)
        
        for i=1:numel(statisticTypes)
            
            % To be skipped, if empty output var name (e.g. in case existing
            % varabible in timetable shall not be overwritten)
            if isempty(newVarNames{i,j}), continue; end
            
            nSamples = fs*winLength(i); 
            switch lower(statisticTypes{i})
                
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
                    error(['Statistic type ',statisticTypes{i},'not supported.'])
                     
            end
            
            T.(newVarNames{i,j}) = MovObj(T.(varNames{j}));
            
            % Moving statistic samples before full window make less sence/can
            % cause confusion, hence setting these sample values as nan
            T.(newVarNames{i,j})(1:nSamples,:) = nan;
           
            T.Properties.VariableContinuity(newVarNames{i,j}) = 'continuous';
            T.Properties.VariableDescriptions(newVarNames{i,j}) = {sprintf(...
                'Moving %s\n\t%s\n\tWindow lengths (samples)',...
                descr,nSamples)};
                  
        end
        
    end