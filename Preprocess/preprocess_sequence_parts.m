function S_parts = preprocess_sequence_parts(S,sampleRate)
        
    fprintf('\nPreprocceing parts:\n')
    
    parts = sort_nat(unique(string(S.part(not(ismissing(S.part))))));
    parts(strcmp(parts,'-')) = [];
    
    % TODO: Fix bug for when missing parts (as with frequency check)
    n_parts = max(double(parts))
    S_parts = cell(n_parts,1)
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
        
        % NOTE: Maybe exclude the following:
        S_parts{i}.accA_xz = S_parts{i}.accA(:,[1 3]);
        S_parts{i} = calc_norm(S_parts{i}, {'accA','accA_xz'});
        
    end
    
    fprintf('Preprocceing parts done.\n')