function S_parts = split_into_parts(S)
        
    % Sample rate for re-sampling down to highest signal content frequency 
    maxSignalFreq = 700;

    welcome('Splitting into resampled parts')
    h_wait = waitbar(0,'','Name','Preprocessing parts...');
    
    parts = string(sort_nat(cellstr(unique(string(S.part(not(ismissing(S.part))))))));
    parts(strcmp(parts,'-')) = [];
    n_parts = max(double(parts));
    
    S_parts = cell(n_parts,1); 
    for i=1:n_parts
        
        h_wait = waitbar(i/n_parts,h_wait,sprintf('Part %d/%d',i,n_parts));
        fprintf('\n<strong>Part %d</strong> \n',i)
        
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
    
    close(h_wait)