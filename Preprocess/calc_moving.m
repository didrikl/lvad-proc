function T = calc_moving(T, varNames, newVarNames, statisticTypes, winLength)
    % CALC_MOVING Calculate moving stastistic in a timetable
    %   
    % See also dsp
    %

    supported_types = {'rms','var','std','min','max','avg','med'};
    
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
                    descr = 'Moving root-mean-square';
                case 'var'
                    MovObj = dsp.MovingVariance(nSamples);
                    descr = 'Moving variance';
                case 'std'
                    MovObj = dsp.MovingStandardDeviation(nSamples);
                    descr = 'Moving standard deviation';
                case 'min'
                    MovObj = dsp.MovingMinimum(nSamples);
                    descr = 'Moving minimum';
                case 'max'
                    MovObj = dsp.MovingMaximum(nSamples);
                    descr = 'Moving maximum';
                case 'avg'
                    MovObj = dsp.MovingAverage(nSamples);
                    descr = 'Moving average';
                case 'med'
                    MovObj = dsp.MovingMedian(nSamples);
                    descr = 'Moving median';
                otherwise                  
                    error(['Statistic type ',statisticTypes{i},'not supported.'])
                     
            end
            
            T.(newVarNames{i,j}) = MovObj(T.(varNames{j}));
            
            % Moving statistic samples before full window make less sence/can
            % cause confusion, hence setting these sample values as nan
            T.(newVarNames{i,j})(1:nSamples,:) = nan;
           
            T.Properties.VariableContinuity(newVarNames{i,j}) = 'continuous';
            T.Properties.VariableDescriptions(newVarNames{i,j}) = {sprintf(...
                '%s\n\tWindow size (samples): %d\n\tWindow size (sec): %d',...
                descr,nSamples,winLength(i))};
            if not(isprop(T.Properties.CustomProperties,'MovingWindowSamples'))
                T = addprop(T,'MovingWindowSamples','variable');
            end
            if not(isprop(T.Properties.CustomProperties,'MovingWindowSeconds'))
                T = addprop(T,'MovingWindowSeconds','variable');
            end
            T.Properties.CustomProperties.MovingWindowSamples(newVarNames{i,j}) = nSamples;
            T.Properties.CustomProperties.MovingWindowSeconds(newVarNames{i,j}) = winLength(i);
        end
        
    end