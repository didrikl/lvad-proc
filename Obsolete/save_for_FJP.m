function save_for_FJP(proc_path,S,notes,sequence)
    
    S.Properties.SampleRate = 4000;
    %S_FJP = add_spatial_norms(S,2,{'accA_x','accA_y','accA_z'},'accA_norm');
    S = remove_variables(S,{'accB_x','accB_y','accB_z'});
    %S_FJP = add_highpass_RPM_filter_variables(S_FJP,'accA_norm','accA_norm_HP',1,1);
    %S_FJP = add_moving_statistics(S_FJP,{'accA_norm',},{'std'});
    %S_FJP = add_moving_statistics(S_FJP,{'accA_norm_HP',},{'std'});
    
    %S_FJP = add_moving_statistics(S_FJP,{'i1','i2','i3','v1','v2','v3'},{'std'});
    
    % S_FJP = add_spatial_norms(S_FJP,2,{'i1','i2','i3'},'i_norm');
    % S_FJP = add_spatial_norms(S_FJP,2,{'v1','v2','v3'},'v_norm');
    % S_FJP = add_moving_statistics(S_FJP,{'i_norm','v_norm'},{'std'}); %#ok<NASGU>
    
    seqNo = strsplit(sequence,' - ');
    seqNo = seqNo{1};
    
    saveTime = datetime(now,...
        'ConvertFrom','datenum',...
        'Format','uuuu-MM-dd HHmm');
    
    S_fileName = sprintf('G1_%s - Signal timetable for FJP - %s.mat',seqNo,saveTime);
    save(fullfile(proc_path,S_fileName),'S')
    
    Config.notes_fileName = sprintf('G1_%s - Notes for FJP - %s.mat',seqNo,saveTime);
    save(fullfile(proc_path,Config.notes_fileName),'notes')
    

    