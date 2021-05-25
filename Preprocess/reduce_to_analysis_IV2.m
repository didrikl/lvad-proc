function S = reduce_to_analysis_IV2(S, Notes, id_specs)
    
    welcome('Reduce to analysis','function')
    
    % Keep only intervals that will go into quatitative analysis, as def. in Notes
    S.analysis_id = standardizeMissing(S.analysis_id,'-');
    S = S(not(ismissing(S.analysis_id)),:);
    
    % Remove irrelevant columns
    S(:,{'event','intervType','part'}) = [];
    
    ids = categories(id_specs.analysis_id);
    
    for i=1:numel(ids)
        
        id = ids(i);
        welcome(sprintf('ID: %s\n',string(id)),'iteration')
        
        id_spec = id_specs(id_specs.analysis_id==id,:);
        s_id_tab = S(S.analysis_id==id,:);
        
        s_id_tab = duration_handling(s_id_tab,id_spec);
       
        % NOTE: Should move to plot QC functionality:
        % - For visual impression on signal
        % - To make this function "more generic"
        check_emboli(s_id_tab)
        
        check_id_parameter_consistency_IV2(s_id_tab,id_spec);
       
        multiWaitbar('Reducing to analysis segments',i/numel(ids));
        
    end
    
    S = S(ismember(S.analysis_id,id_specs.analysis_id),:);
    S.Properties.UserData.Notes = Notes;
    
    % Remove irrelevant categoric columns
    S(:,ismember(S.Properties.VariableNames,{'balloonLev','pumpSpeed','affEmboliVol'})) = [];
    
    %S.noteRow = categorical(S.noteRow)
    S = movevars(S, 'noteRow', 'Before', 1);
    S = movevars(S, 'bl_id', 'Before', 1);
    S = movevars(S, 'analysis_id', 'Before', 1);
    
function check_emboli(s_id_tab)
    vol = sum(s_id_tab.affEmboliVol);
    if vol>1000
        warning(['Accumulated emboli volume >1000 muL detected: ',num2str(vol)])
    end
    
function s_id_tab = duration_handling(s_id_tab,id_spec)
    % Warn if recording interval duration is less than specifices in ID
    % specification file. Also, if duration exceeds with 2 or more seconds, then
    % cut 1 seconds of the recording at the start and end of the interval. The
    % cut is done as a mitigation measure against inaccuracies in timestames
    % (round off errors, human note response, clock drift corrections and clock
    % offsets).
    
    % NOTE: Which solution is best?
        % - Strip 1 secs at each side of the id-interval?
        % - Strip down to exact duration according to the protocol evenly 
        %   distributed at each side of the id intererval?
        
    if height(s_id_tab)==0
        if not(id_spec.contingency)
            warning('Missing data');
        end
    else
        totDur = s_id_tab.time(end)-s_id_tab.time(1);
        fprintf('%s duration\n',string(totDur))
        if totDur<id_spec.analysisDuration
            warning(sprintf('Duration is less than in protocol (%s)',...
                string(id_spec.analysisDuration)));
        elseif totDur>id_spec.analysisDuration+seconds(2)
            dur = s_id_tab.time - s_id_tab.time(1);
            cut_inds = dur<seconds(1) | dur>totDur-seconds(1);
            s_id_tab(cut_inds,:) = [];
            totDur = s_id_tab.time(end)-s_id_tab.time(1);
            fprintf('%s duration (after trim)\n',string(totDur))
        end
        
    end