function psds = make_power_spectra(Data, seqs, vars, fs, hBands, idSpecs, isHarmBand)
    
	welcome('Make power spectra','function')
	
	if nargin<6, isHarmBand = false; end
	speeds = unique(idSpecs.pumpSpeed);
	pxx = cell(numel(seqs),1);
    for j=1:numel(seqs)
        
        welcome([seqs{j},'\n'],'iteration')
       
        S = Data.(seqs{j}).S;
		vars = check_table_var_input(S, vars);
	
		S = join_notes(S, Data.(seqs{j}).Notes);
		S = S(ismember(S.analysis_id,idSpecs.analysis_id),:);
       
		summaryBlock4Speed = cell(numel(speeds),1);
        for k=1:numel(speeds)
            
			multiWaitbar('Making spectral densities',...
				'Increment',(1/(numel(speeds))/numel(seqs)));        

            ids_speed = idSpecs.analysis_id(idSpecs.pumpSpeed==speeds(k));        
            block4Speed = S(ismember(S.analysis_id,ids_speed),:);
            if isempty(block4Speed), continue; end

			if isHarmBand, fBands = hBands*(double(speeds(k))/60); end
			summaryBlock4Speed{k} = groupsummary(block4Speed,{'analysis_id'},...
                @(x)make_pxx_metric_cell(x,fs,fBands),vars);
            
        end
        
        pxx{j} = merge_table_blocks(summaryBlock4Speed);
        pxx{j} = join(pxx{j},idSpecs(:,{'analysis_id','idLabel'}),...
			'Keys','analysis_id');  
        pxx{j}.id = seqs{j} + "_" + string(pxx{j}.idLabel);
        
    end
    
	% Make one common table with groupsummary output stored as cells
	T = merge_to_common_table(pxx);
	T = split_metric_cell_to_var(vars, T);
	T.idLabel = [];

	psds = struct;
	psds.bandMetrics = T(:,not(endsWith(T.Properties.VariableNames,...
        {'_pxx','_f','GroupCount'})));
	psds.periodogramFrequencies = T.(vars{1}+"_f"){1};
    psds.peridograms = T(:,endsWith(T.Properties.VariableNames,...
		{'id','analysis_id','_pxx'}));  
	psds.idSpecs = idSpecs;
	psds.Bands_Specifications = make_band_specs(psds, hBands);
	
function c = make_pxx_metric_cell(x,fs,freqBands)
	[pxx, f, mpf, pow] = calc_periodogram_metrics(detrend(x), fs, freqBands);
	c = [{pxx},{f},struct2cell(pow)',struct2cell(mpf)'];
	
function T = split_metric_cell_to_var(vars, T)
	% Split the cell content as made in make_psd_band_metrics_IV2 and store just
	% the band power (not the mean power frequencies).
	vars = cellstr(vars);

	% number of band are size found from a cell corresponding to  e.g. the 1st
	% varible. Minus 2 because pxx and f is also stored in the cell. Divide by 
	% two because both pow and mpf is stored for each band.
	nPow = (size(T.(vars{1}),2)-2)/2;
	
	for i=1:numel(vars)
		v = vars{i};
		bandPowVars = "_b"+[1:nPow]+"_pow";
		bandMPFVars = "_b"+[1:nPow]+"_mpf";
		newVars = v+["_pxx","_f",bandPowVars,bandMPFVars];
		T = splitvars(T,v,'NewVariableNames',newVars);
		
		% Store are numbers (whereas pxx, f and h remain as structs)
		metricVars = newVars(3:end);
		for j=1:numel(metricVars)
			T.(metricVars{j}) = cell2mat(T{:,metricVars{j}});
		end
	end

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
		T.(['b',num2str(i),'_harmonics']) = hBand;
		T.(['b',num2str(i),'_frequencies'])  = (hBand/60).*speed;
	end
