function S_analysis = load_processed_sequences(seqNames,seqFilePaths)
    multiWaitbar('Loading processed .mat files',0,'CanCancel','off');
    nSeqs = numel(seqNames);
    S_analysis = struct;
    seqNames = cellstr(seqNames);
    seqFilePaths = cellstr(seqFilePaths);
    for i=1:nSeqs

        seq = seqNames{i};
        seqFilePath = seqFilePaths{i};
        display_filename(seqFilePath,'','\nLoading processed sequence data');
        try
            load(seqFilePath)
            S_analysis.([seq(1:7),sprintf('%.2d',str2double(seq(8:end)))]) = S;
        catch err
            warning('Processe sequence file not loaded')
            disp(err)
            continue
        end
        multiWaitbar('Loading processed .mat files',i/nSeqs);  

    end

    multiWaitbar('Loading processed .mat files','Close');
