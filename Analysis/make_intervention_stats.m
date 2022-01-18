function stats = make_intervention_stats(...
		D, discrVars, meanVars, medVars, idSpecs)
    % In groups of tagged interventions from column analysis_id in D, 
	% calculate aggregates. 
	%
	% discrVars are variable treated as discrete values, noted manuelly once or
	% a few times per intervention. Aggregates of discrVars is the mean (in case 
	% of multiple notes per intervention), but rounded off to avoid introduced
	% decrete values simply due to round-off errors (important for statistical
    % analysis involving the median).
	%
	% meanVars and medVars are treated as continous measurments. 
	% - Aggregates of meanVars are means and standard deviation
	% - Aggregates of medVars are median, togehter with 1st and 3rd quartiles
	%
	% idSpecs are categorical info for each analysis_id.
	
	welcome('Calculate stats','function')
    
	% Find which sequences (experiments) to be aggregated per intervention
    seqs = D.Sequences;
    stats = cell(numel(seqs),1);
	
	% Code if parallellization by parfor loop instead of for loop below:
	%{
        data = cell(numel(seqs),1);
        for j=1:numel(seqs)
            data{j} = S_analysis.(seqs{j});
        end
    %}
	
	% Aggregate uniquely tagged interventions, sequence by sequence
    for j=1:numel(seqs)
        welcome([seqs{j},'\n'],'iteration')
        
        % Extract relevant intervals/interventions tagged with analysis_id
        S = remove_rows_with_irrelevant_analysis_id(...
			D.(seqs{j}).S,idSpecs);
		
		idStatsMeans = groupsummary(S,{'analysis_id','bl_id'},...
            {'mean','std'},{meanVars},...
            'IncludeEmptyGroups',false);

		idStatsMedians = groupsummary(S,{'analysis_id','bl_id'},...
            {'median',@(x)prctile(x,[25,75])},{medVars},...
            'IncludeEmptyGroups',false);

        idStatsDiscr = groupsummary(S,{'analysis_id','bl_id'},...
            'mean',discrVars,...
            'IncludeEmptyGroups',false);
        
		% Code example (for idStats_meas only) to include missing-rows:
		%{
        S_analysis.(seq).group_id = categorical(...
            string(S_analysis.(seq).analysis_id)+" - "+...
            string(S_analysis.(seq).bl_id));
        stats_meas = groupsummary(S_analysis.(seq),group_id,...
            {'mean','std','median',@(x)prctile(x,[25,75])},{meas_vars},...
            'IncludeEmptyGroups',true);
        group_id = split(string(idStats_meas.group_id)," - ");
        idStats_meas.analysis_id = cateogrical(group_id(:,1));
        idStats_meas.bl_id = categorical(group_id(:,2));
        idStats_meas.group_id = []; 
		%}
		
		% Joining the aggregats per sequence into one tables
        stats{j} = join(idStatsMeans,idStatsDiscr,'Keys',{'analysis_id','bl_id'});    
        stats{j} = join(stats{j},idStatsMedians,'Keys',{'analysis_id','bl_id'});    
        
		% Adding unique categorical info for every intervention and sequence 
		stats{j} = join(stats{j},D.idSpecs_analysis,"Keys","analysis_id");
        stats{j}.id = seqs{j} + "_" + string(stats{j}.idLabel);
        stats{j}.seq = repmat(string(seqs{j}),height(stats{j}),1);
        
        multiWaitbar('Making steady-state features',(j)/numel(seqs));

    end
   
	% Merge all sequence aggregates into one common table
    stats = merge_table_blocks(stats);
   
	stats = convert_intervention_sample_counts_to_durations(stats);
	stats = tidy_up_aggregate_variable_names(stats);
	stats = tidy_up_row_and_column_positions(stats);
	stats = remove_round_off_errors_in_discrete_vars(stats, discrVars);

function S = remove_rows_with_irrelevant_analysis_id(S,idSpecs)
	
	% Remove rows with extra ids in data not listed in id spec file
    extraIDs = not(ismember(S.analysis_id,idSpecs.analysis_id));
	S(extraIDs,:) = [];
	S.analysis_id = removecats(S.analysis_id);
	S.bl_id = removecats(S.bl_id);


function stats = tidy_up_aggregate_variable_names(stats)
	% Tidy up names 
	q1q3_vars = startsWith(stats.Properties.VariableNames,"fun1_");  
	q1q3_vars = stats.Properties.VariableNames(q1q3_vars);
	for i=1:numel(q1q3_vars)
		stats = splitvars(stats,q1q3_vars{i},'NewVariableNames',...
			{[q1q3_vars{i}(6:end),'_25prct'],[q1q3_vars{i}(6:end),'_75prct']});
	end
	stats = change_variablename_prefix_to_suffix(stats,...
		{'mean','std','median','q1','q2'},...
		{'mean','stdev','median','_25prct','_75prct'},'_');

function stats = tidy_up_row_and_column_positions(stats)
	% Tidy up row and column positions
	stats = movevars(stats,{'id','analysis_id','bl_id','seq','idLabel',...
		'categoryLabel','levelLabel','interventionType','contingency','duration',...
		'pumpSpeed','catheter','balLev','balDiam','balloonVolume','QRedTarget_pst'},...
		'Before',1);
	stats = sortrows(stats,'id','ascend');

function stats = convert_intervention_sample_counts_to_durations(stats)
	aggGroupCountsMade = stats.Properties.VariableNames(ismember(...
		stats.Properties.VariableNames,{'GroupCount_idStatsMeans',...
		'GroupCount_idStatsMedians','GroupCount_idStatsDiscr'}));
	stats.duration = string(seconds(stats.(aggGroupCountsMade{1})/750),'hh:mm:ss');   
	stats(:,[aggGroupCountsMade,'analysisDuration']) = [];
	
function stats = remove_round_off_errors_in_discrete_vars(stats, discrVars)
	% Important to avoid round off errors when testing median effects 
	stats{:,discrVars+"_mean"} = round(stats{:,discrVars+"_mean"},2);
	
