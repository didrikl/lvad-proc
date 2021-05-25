function [psds,f,pows] = make_psds(S_analysis,vars,id_specs)
    
    welcome('Calculate peridograms','function')
    
    speeds = unique(id_specs.pumpSpeed);
    seqs = fieldnames(S_analysis);
    fs = 750;
    %band_harm_lims = [2.5,6.9];%(fs/2)/(3100/60)-0.5];
    band_harm_lims = [1.25,2.75];%(fs/2)/(3100/60)-0.5];
    
    psds = cell(numel(seqs),1);
    for j=1:numel(seqs)
        
        seq = seqs{j};
        S = S_analysis.(seqs{j});
        seq
        psds_speed = cell(numel(speeds),1);
        for k=1:numel(speeds)
            
            ids_speed = id_specs.analysis_id(id_specs.pumpSpeed==speeds(k));           
            S_speed = S(ismember(S.analysis_id,ids_speed),:);
            if isempty(S_speed), continue; end
            
            band = band_harm_lims*(double(speeds(k))/60);
            psds_speed{k} = groupsummary(S_speed,{'analysis_id','bl_id'},...
                @(x)make_psd(x,fs,band),vars);
            
        end
        
        psds{j} = merge_table_blocks(psds_speed);
        psds{j} = join(psds{j},id_specs(:,{'analysis_id','idLabel'}),...
            'Keys','analysis_id');  
        psds{j}.id = seq + "_" + string(psds{j}.idLabel);
        
    end
        
    T = merge_table_blocks(psds);
%     T = psds;
    
    T.Properties.VariableNames = strrep(T.Properties.VariableNames,'fun1_','');
    T = movevars(T,{'id','idLabel','bl_id','idLabel',},'Before',1);    
    
    for i=1:numel(vars)
        v = vars{i};
        T = splitvars(T,v,...
            'NewVariableNames',v+["_pxx","_f","_mpf","_pow","_bmpf","_bpow"]);
        T.(v+"_mpf") = cell2mat(T{:,v+"_mpf"});
        T.(v+"_pow") = cell2mat(T{:,v+"_pow"});
        T.(v+"_bmpf") = cell2mat(T{:,v+"_bmpf"});
        T.(v+"_bpow") = cell2mat(T{:,v+"_bpow"});
    end
     
    f = T.(vars{1}+"_f"){1};
    psds = T(:,endsWith(T.Properties.VariableNames,...
        {'id','analysis_id','bl_id','idLabel','_pxx'}));
    pows = T(:,not(endsWith(T.Properties.VariableNames,{'_pxx','_f'})));
   
function c = make_psd(x,fs,band)
    [pxx,f] = periodogram(detrend(x),[],[],fs);
    [mpf,pow] = meanfreq(pxx,f);
    [bmpf,bpow] = meanfreq(pxx,f,band);
    c = {pxx,f,mpf,pow,bmpf,bpow};