function [F,psds] = make_power_spectra(Data,F,vars,idSpecs,fs,hBands,calcType)
    % TODO: Split function into spectral desities pxx calculation function and
	% another function for bandpower and mean-power-frequency based on pxx.
    welcome('Make power spectra','function')
    
    speeds = unique(idSpecs.pumpSpeed);
    seqs = fieldnames(Data);
    
	% NOTE: This is proably better as object oriented
	switch calcType
		case 'IV2'
			% focused harmonic bands definition
			bandMetricsCalcFnc = @make_psd_data_IV2;
			convertMetricsToColumsFnc = @split_cell_to_vars_IV2;
		case 'G1'
			bandMetricsCalcFnc = @make_psd_metrics_G1;
			convertMetricsToColumsFnc = @split_cell_to_vars_G1;
	end

    pxx = cell(numel(seqs),1);
    for j=1:numel(seqs)
        
        welcome([seqs{j},'\n'],'iteration')
        
        S = Data.(seqs{j}).S;
        blockForSpeed = cell(numel(speeds),1);
        for k=1:numel(speeds)
            multiWaitbar('Making spectral densities',...
				'Increment',(1/(numel(speeds))/numel(seqs)));        

            ids_speed = idSpecs.analysis_id(idSpecs.pumpSpeed==speeds(k));           
            S_speed = S(ismember(S.analysis_id,ids_speed),:);
            if isempty(S_speed), continue; end

            fBands = hBands*(double(speeds(k))/60);
            blockForSpeed{k} = groupsummary(S_speed,{'analysis_id'},...
                @(x)bandMetricsCalcFnc(x,fs,fBands),vars);
            
        end
        
        pxx{j} = merge_table_blocks(blockForSpeed);
        pxx{j} = join(pxx{j},idSpecs(:,{'analysis_id','idLabel'}),...
			'Keys','analysis_id');  
        pxx{j}.id = seqs{j} + "_" + string(pxx{j}.idLabel);
        
    end
    
	% Make one common table with groupsummary output stored as cells
	T = merge_to_common_table(pxx);
	
	% Make struct with tables of periodograms, band metrices, etc.
    T = convertMetricsToColumsFnc(vars, T);
	
	psds = struct;
	psds.bandMetrics = T(:,not(endsWith(T.Properties.VariableNames,...
        {'_pxx','_f','GroupCount'})));
	psds.periodogramFrequencies = T.(vars{1}+"_f"){1};
    psds.peridograms = T(:,endsWith(T.Properties.VariableNames,...
		{'id','analysis_id','_pxx'}));  
	psds.idSpecs = idSpecs;
	psds.frequencyBands = make_band_specs(psds, hBands);
	
	% Add bandpowers to F table
	F = join(F,psds.bandMetrics,'Keys',{'id','analysis_id'});
  
function c = make_psd_data_IV2(x,fs,freqBands)
	if size(freqBands,1)>1 
		error('No. of focued bands cannot be more than 1'); 
	end
	
	[pxx,f] = periodogram(detrend(x),[],[],fs);
	
	[mpf,pow] = meanfreq(pxx,f);
	[~,bpow] = meanfreq(pxx,f,freqBands);
	c = {pxx,f,mpf,pow,bpow};

function T = split_cell_to_vars_IV2(vars, T)
	% Split the cell content as made in make_psd_band_metrics_IV2
	vars = cellstr(vars);
	for i=1:numel(vars)
		v = vars{i};
		T = splitvars(T,v,'NewVariableNames',v+["_pxx","_f","_mpf","_pow","_bpow"]);
		
		% Store are numbers (whereas pxx, f and h remain as structs)
		T.(v+"_mpf") = cell2mat(T{:,v+"_mpf"});
		T.(v+"_pow") = cell2mat(T{:,v+"_pow"});
		T.(v+"_bpow") = cell2mat(T{:,v+"_bpow"});
	end

% function c = make_psd_data_G1(x,fs,focusedFreqBands)
% 	% TODO: Implement struct saving of metrics
% 	[pxx,f] = periodogram(detrend(x),[],[],fs);
% 	c.pxx = pxx;
% 	c.f = f;
% 	c.h = f*60/speed;
% 	
% 	[c.mpf,c.pow] = meanfreq(pxx,f);
% 	
% 	for i=1:size(focusedFreqBands,1)
% 		[c.band1.mpf,bpow] = meanfreq(pxx,f,focusedFreqBands);
% 	end

function T = merge_to_common_table(pxx)
	T = merge_table_blocks(pxx);    
	T.Properties.VariableNames = strrep(T.Properties.VariableNames,'fun1_','');
	T = movevars(T,{'id','analysis_id'},'Before',1);        

function T = make_band_specs(psds, hBands)
	idSpecs = psds.idSpecs;
	speed = double(idSpecs.pumpSpeed);
	
	f = psds.periodogramFrequencies;
	T = table;
		
	for i=1:size(hBands,1)+1
		if i==1
			hBand = [f(1),f(end)]*60./speed;
		else
			hBand = repmat(hBands(i-1,:),height(idSpecs),1);
		end
		T.analysis_id = idSpecs.analysis_id;
		T.pumpSpeeds = speed;
		T.(['band',num2str(i),'_harmonics']) = hBand;
		T.(['band',num2str(i),'_frequencies'])  = (hBand/60).*speed;
	end
