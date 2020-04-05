function S_parts = split_into_parts(S)
        
    % Sample rate for re-sampling down to highest signal content frequency 
    maxSignalFreq = 700;

    welcome('Splitting into parts')
    h_wait = waitbar(0,'','Name','Preprocessing parts...');
    
    parts = sort_nat(unique(string(S.part(not(ismissing(S.part))))));
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
        
        %if any(seconds(diff(S_parts{i}.time))>1/sampleRate)
        if S_parts{i}.Properties.SampleRate~=maxSignalFreq
            S_parts{i} = resample_signal(S_parts{i}, maxSignalFreq);
        end
        %else
            %S_parts{i}.Properties.SampleRate = sampleRate;
        %end
    
    end
    
    close(h_wait)