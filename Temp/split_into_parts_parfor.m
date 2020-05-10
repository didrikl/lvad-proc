function S_parts = split_into_parts_parfor(S)
        
    % Sample rate for re-sampling down to highest signal content frequency 
    maxSignalFreq = 700;

    welcome('Splitting into resampled parts')
    h_wait = waitbar(0,'','Name','Preprocessing parts...');
    
    parts = sort_nat(unique(string(S.part(not(ismissing(S.part))))));
    parts(strcmp(parts,'-')) = [];
    n_parts = max(double(parts));
    
    h_wait = waitbar(0.25,h_wait,sprintf('Parts 1-x'));
    fprintf('\n<strong>Parts 1-%d</strong> \n',21)
        
    S_parts = cell(n_parts,1); 
    parfor i=1:floor(n_parts/2)
        
        
        S_parts{i} = S(S.part==string(i),:);
        if height(S_parts{i})==0
            warning('No data');
            continue; 
        end
        
        if isnan(S_parts{i}.Properties.SampleRate) || ...
                S_parts{i}.Properties.SampleRate~=maxSignalFreq
            S_parts{i} = resample_signal(S_parts{i}, maxSignalFreq);
        end
        
        % Remove possible first/last row(s) with undefined part after re-sampling
        S_parts{i}(isundefined(S_parts{i}.part),:) = [];
        if isnan(S_parts{i}.Properties.SampleRate)
            [fs,S_parts{i}] = get_sampling_rate(S_parts{i});
        end
        
        fprintf('\n');
    
    end
    
    h_wait = waitbar(0.75,h_wait,sprintf('Parts 1-x'));
        
    parfor i=floor(n_parts/2)+1:n_parts
        
        S_parts{i} = S(S.part==string(i),:);
        if height(S_parts{i})==0
            warning('No data');
            continue; 
        end
        
        if isnan(S_parts{i}.Properties.SampleRate) || ...
                S_parts{i}.Properties.SampleRate~=maxSignalFreq
            S_parts{i} = resample_signal(S_parts{i}, maxSignalFreq);
        end
        
        % Remove possible first/last row(s) with undefined part after re-sampling
        S_parts{i}(isundefined(S_parts{i}.part),:) = [];
        if isnan(S_parts{i}.Properties.SampleRate)
            [fs,S_parts{i}] = get_sampling_rate(S_parts{i});
        end
      
    end
    
    
    close(h_wait)