function T = make_intervention_stats(D, seqs, discrVars, meanVars, medVars, minMaxVars, idSpecs)
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

	if any(ismember(discrVars,meanVars))
		error('Variables cannot be both discrVars and meanVars')
	end
	
	% Missing sequences in data indicates a typo. 
	seqs = check_missing_sequences(seqs, D);
	
	% Aggregate uniquely tagged interventions, sequence by sequence
	T = cell(numel(seqs),1);
	for j=1:numel(seqs)
		welcome([seqs{j},'\n'],'iteration')

		Notes = D.(seqs{j}).Notes;
		S = D.(seqs{j}).S;

		% Add protocol info and all measured values (not categorical) from 
		% the notes table and extract relevant intervals/interventions
		noteVars = unique([discrVars; meanVars; medVars; minMaxVars]);
		ismember(noteVars,Notes.Properties.VariableNames);
		noteVars = noteVars(ismember(noteVars,Notes.Properties.VariableNames));
		catNoteVars = get_varname_of_specific_type(Notes(:,noteVars),'categorical');
		for i=1:numel(catNoteVars)
			Notes.(catNoteVars{i}) = double(string(Notes.(catNoteVars{i})));
		end
		S = join_notes(S, Notes, noteVars);
		S = remove_rows_with_irrelevant_analysis_id(S, idSpecs);
		
		discrVars = check_table_var_input(S, discrVars);
		meanVars = check_table_var_input(S, meanVars);
		medVars = check_table_var_input(S, medVars);
		minMaxVars = check_table_var_input(S, minMaxVars);

		idStatsMeans = groupsummary(S,{'analysis_id','bl_id'},...
			{'mean','std'},{meanVars},...
			'IncludeEmptyGroups',false);

		idStatsMedians = groupsummary(S,{'analysis_id','bl_id'},...
			{'median',@(x)prctile(x,[25,75])},{medVars},...
			'IncludeEmptyGroups',false);

		idStatsDiscr = groupsummary(S,{'analysis_id','bl_id'},...
			'mean',discrVars,...
			'IncludeEmptyGroups',false);

		idMinMax = groupsummary(S,{'analysis_id','bl_id'},...
			{'min','max'}, minMaxVars,...
			'IncludeEmptyGroups',false);

		idStatsNoteRow = groupsummary(S,{'analysis_id','bl_id'},...
			@(x)listNoteRows(x),'noteRow',...
			'IncludeEmptyGroups',false);

		% Joining the aggregats per sequence into one tables
		T{j} = join(idStatsMeans,idStatsDiscr,'Keys',{'analysis_id','bl_id'});
		T{j} = join(T{j},idStatsMedians,'Keys',{'analysis_id','bl_id'});
		T{j} = join(T{j},idMinMax,'Keys',{'analysis_id','bl_id'});
		T{j} = join(T{j},idStatsNoteRow,'Keys',{'analysis_id','bl_id'});

		% Adding unique categorical info for every intervention and sequence
		T{j} = join(T{j},idSpecs,"Keys","analysis_id");
		T{j}.id = seqs{j} + "_" + string(T{j}.idLabel);
		T{j}.seq = repmat(string(seqs{j}),height(T{j}),1);

		multiWaitbar('Making steady-state features',(j)/numel(seqs));

	end

	% Merge all sequence aggregates into one common table
	T = merge_table_blocks(T);

	T = convert_intervention_sample_counts_to_durations(T);
	T = remove_unneeded_columns(T);
	T = tidy_up_aggregate_variable_names(T);
	T = tidy_up_row_and_column_positions(T);
	T = remove_round_off_errors_in_discrete_vars(T, discrVars);
	T.Properties.Description = 'Aggregate features of ID-tagged segments';

function T = remove_rows_with_irrelevant_analysis_id(T, idSpecs)

	% Remove rows with extra ids in data not listed in id spec file
	extraIDs = not(ismember(T.analysis_id,idSpecs.analysis_id));
	T(extraIDs,:) = [];

	% Update categories (metadata) after removal
	T.analysis_id = removecats(T.analysis_id);
	T.bl_id = removecats(T.bl_id);

function T = tidy_up_aggregate_variable_names(T)
	% Tidy up names
	T.Properties.VariableNames{'fun1_noteRow'} = 'noteRow';
	q1q3_vars = startsWith(T.Properties.VariableNames,"fun1_");
	q1q3_vars = T.Properties.VariableNames(q1q3_vars);
	for i=1:numel(q1q3_vars)
		T = splitvars(T,q1q3_vars{i},'NewVariableNames',...
			{[q1q3_vars{i}(6:end),'_25prct'],[q1q3_vars{i}(6:end),'_75prct']});
	end
	T = change_variablename_prefix_to_suffix(T,...
		{'mean','std','median','q1','q2','min','max'},...
		{'mean','stdev','median','_25prct','_75prct','min','max'},'_');

function T = remove_unneeded_columns(T)
	remCols = contains(T.Properties.VariableNames,{'GroupCount'});
	T(:,remCols) = [];

function T = tidy_up_row_and_column_positions(T)
	% Tidy up row and column positions
	catCols = ismember(T.Properties.VariableNames,...
		{'id','analysis_id','bl_id','seq','noteRow','idLabel',...
		'categoryLabel','levelLabel','interventionType','contingency','duration',...
		'pumpSpeed','catheter','balLev_xRay', 'balDiam_xRay', 'balLev','balDiam','balVol','QRedTarget_pst'});
	T = movevars(T,catCols,'Before',1);
	T = sortrows(T,'id','ascend');

function T = convert_intervention_sample_counts_to_durations(T)
	aggGroupCountsMade = T.Properties.VariableNames(ismember(...
		T.Properties.VariableNames,{'GroupCount_idStatsMeans',...
		'GroupCount_idStatsMedians','GroupCount_idStatsDiscr'}));
	T.duration = string(seconds(T.(aggGroupCountsMade{1})/750),'hh:mm:ss');
	T(:,[aggGroupCountsMade,'analysisDuration']) = [];

function T = remove_round_off_errors_in_discrete_vars(T, discrVars)
	% Important to avoid round off errors when testing median effects
	T{:,discrVars+"_mean"} = round(T{:,discrVars+"_mean"},2);

function noteRowList = listNoteRows(noteRow)
	noteRowList = {unique(noteRow)'};
