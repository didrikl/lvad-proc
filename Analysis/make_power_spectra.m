function [F,psds] = make_power_spectra(S_analysis,F,vars,id_specs)
    
    welcome('Calculate power spectra','function')

    psds = struct;
    speeds = unique(id_specs.pumpSpeed);
    seqs = fieldnames(S_analysis);
    fs = 750;
    %band_harm_lims = [2.5,6.9];%(fs/2)/(3100/60)-0.5];
    band_harm_lims = [1.10,2.9];%(fs/2)/(3100/60)-0.5];
    
    pxx = cell(numel(seqs),1);
    for j=1:numel(seqs)
        
        welcome([seqs{j},'\n'],'iteration')
        
        S = S_analysis.(seqs{j});
        psds_speed = cell(numel(speeds),1);
        for k=1:numel(speeds)
            multiWaitbar('Making spectral densities','Increment',(1/(numel(speeds))/numel(seqs)));        

            ids_speed = id_specs.analysis_id(id_specs.pumpSpeed==speeds(k));           
            S_speed = S(ismember(S.analysis_id,ids_speed),:);
            if isempty(S_speed), continue; end
            
            band = band_harm_lims*(double(speeds(k))/60);
            psds_speed{k} = groupsummary(S_speed,{'analysis_id'},...
                @(x)make_psd(x,fs,band),vars);
            
        end
        
        pxx{j} = merge_table_blocks(psds_speed);
        pxx{j} = join(pxx{j},id_specs(:,{'analysis_id','idLabel'}),'Keys','analysis_id');  
        pxx{j}.id = seqs{j} + "_" + string(pxx{j}.idLabel);
        
    end
    
    T = merge_table_blocks(pxx);
    
    T.Properties.VariableNames = strrep(T.Properties.VariableNames,'fun1_','');
    T = movevars(T,{'id','analysis_id','idLabel'},'Before',1);    
%    
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
    pxx = T(:,endsWith(T.Properties.VariableNames,...
        {'id','analysis_id','_pxx'}));
    pxx.Properties.UserData.f = f;
    pows = T(:,not(endsWith(T.Properties.VariableNames,...
        {'_pxx','_f','GroupCount','idLabel'})));
   
    psds.pxx = pxx;
    psds.f = f;
    psds.pow = pows;
    
    F = join(F,psds.pows,'Keys',{'id','analysis_id'});
    
function c = make_psd(x,fs,band)
     [pxx,f] = periodogram(detrend(x),[],[],fs);
     [mpf,pow] = meanfreq(pxx,f);
     [bmpf,bpow] = meanfreq(pxx,f,band);
     c = {pxx,f,mpf,pow,bmpf,bpow};