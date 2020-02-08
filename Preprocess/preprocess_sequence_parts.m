function S_parts = preprocess_sequence_parts(S,sampleRate)
        
    fprintf('\nPreprocceing parts:\n')
    
    parts = sort_nat(unique(string(S.part(not(ismissing(S.part))))));
    parts(strcmp(parts,'-')) = [];
    n_parts = max(double(parts));
    S_parts = cell(n_parts,1);
    %regularStep = 1/sampleRate;
    
    for i=1:n_parts
        
        fprintf('\n<strong>Part %s</strong> \n',parts{i})
        S_parts{i} = S(S.part==parts(i),:);
        
%         irregularSteps = seconds(diff(S_parts{i}.time))>regularStep;
%         if any(irregularSteps)
        if S_parts{i}.Properties.SampleRate~=sampleRate
            S_parts{i} = resample_signal(S_parts{i}, sampleRate);
%         else
%             S_parts{i}.Properties.SampleRate = sampleRate;
        end
        
        % Add new cols
        S_parts{i}.part_duration = S_parts{i}.time-S_parts{i}.time(1);
        S_parts{i} = calc_norm(S_parts{i}, {'accA','gyrA'});
        S_parts{i} = calc_moving(S_parts{i}, {'accA','accA_norm','gyrA','gyrA_norm'},{'Std','RMS'});
        
    end
    
    fprintf('Preprocceing parts done.\n')