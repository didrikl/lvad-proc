function S = reduce_to_analysis_IV2(S, Notes, idSpecs)
	
	% NOTE: Can be more generic, say by all categorical
	colsToRem = {
		'balLev'
		'balDiam'
		'catheter'
		'pumpSpeed'
		'QRedTarget_pst'
		'affEmboliVol'
		'event'
		'intervType'
		'part'};
	
	welcome('Reduce data to analysis ID segments','function')
	
	% Keep only intervals that will go into quatitative analysis, as def. in Notes
	S.analysis_id = standardizeMissing(S.analysis_id,'-');
	S = S(not(ismissing(S.analysis_id)),:);
	
	ids = categories(idSpecs.analysis_id);
	
	for i=1:numel(ids)
		
		id = ids(i);
		welcome(sprintf('ID: %s\n',string(id)),'iteration')
		
		idSpec = idSpecs(idSpecs.analysis_id==id,:);
		S_id = S(S.analysis_id==id,:);
		
		% Display info about each segment
		S_id = duration_handling(S_id, idSpec);
		check_emboli(S_id,'affEmboliVol',1000)		
		check_id_parameter_consistency_IV2(S_id, idSpec);
		
		multiWaitbar('Reducing to analysis ID segments',i/numel(ids));
		
	end
	
	S = S(ismember(S.analysis_id,idSpecs.analysis_id),:);
	S.Properties.UserData.Notes = Notes;
	
	% Remove irrelevant columns after checks
	S(:,ismember(S.Properties.VariableNames,colsToRem)) = [];
	
	S = move_key_columns_first(S);
	S.Properties.Description = 'Fused data - Analysis ID segments';
	