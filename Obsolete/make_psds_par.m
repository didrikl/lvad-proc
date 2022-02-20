function psds = make_psds_par(S_analysis,vars)
    
    welcome('Calculate peridograms','function')
    
    ids_specs = init_id_specifications('ID_Definitions_IV2');
    ids_specs = ids_specs(:,{'analysis_id','LabelID'});
    seqs = fieldnames(S_analysis);
    
    psds = cell(numel(seqs),1);
    data = cell(numel(seqs),1);
    for j=1:numel(seqs)
        data{j} = S_analysis.(seqs{j});
    end
    
    parfor j=1:numel(seqs)
        Config.seq = seqs{j}; 
        
        fs = 750;
        psds{j} = groupsummary(data{j},{'analysis_id','bl_id'},@(x)make_psd(x,fs),vars);   
        
        psds{j} = join(psds{j},ids_specs,'LeftKeys','analysis_id','RightKeys','analysis_id');  
        psds{j}.id = seq + "_" + string(psds{j}.LabelID);
        psds{j}.LabelID = [];
        
    end
    
    
%     tic
%     pb = cell(numel(seqs),1);
%     for j=1:numel(seqs)
%         Config.seq = seqs{j}; 
%         
%         
%         pb{j} = join(ids_specs,S_analysis.(seq),'LeftKeys','analysis_id','RightKeys','analysis_id');  
%         freqRange = [1,5]*double(string(pb{j}.pumpSpeed))/60;
%         
%         fs = S_analysis.(seq).Properties.SampleRate;
%         pb{j} = groupsummary(S_analysis.(seq),"analysis_id",@(x)bandpower,vars);   
%         
%         
%         pb{j}.id = seq + "_" + string(pb{j}.LabelID);
%         pb{j}.LabelID = [];
%         
%     end
%     
%     toc
    
    psds = merge_table_blocks(psds);
    psds = movevars(psds,'id','Before',1);
    
    psds = splitvars(psds,'fun1_accA_norm');
    
%                     if isfinite(freqRange)
%                         x = S.(var)(not(isnan(S.(var))));
%                         jj
%                         [mpf,bp] = meanfreq(x,fs,freqRange);
%                         bp_col(jj) = bp;
%                         mpf_col(jj) = mpf;
%                     end

function pxx = make_psd(x,fs)
    [pxx,f] = periodogram(detrend(x),[],[],fs);
    [mpf,pow] = meanfreq(pxx,f);
    pxx = {pxx,f,mpf,pow};