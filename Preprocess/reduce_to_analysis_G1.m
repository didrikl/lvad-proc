function S = reduce_to_analysis_G1(S, Notes, idSpecs, remEchoRows)
	
	welcome('Reduce data to analysis ID segments','function')
	
	% Keep only intervals that will go into quatitative analysis, as def. in Notes
	S.analysis_id = standardizeMissing(S.analysis_id,'-');
	S = S(not(ismissing(S.analysis_id)),:);
	
	% Remove data for echo measurements
	if remEchoRows
		S = S(not(contains(string(S.analysis_id),'E')),:);
	end

	ids = categories(idSpecs.analysis_id);
	
	for i=1:numel(ids)
		
		id = ids(i);
		welcome(sprintf('ID: %s\n',string(id)),'iteration')
		
		idSpec = idSpecs(idSpecs.analysis_id==id,:);
		S_id = S(S.analysis_id==id,:);
		S_id = duration_handling(S_id, idSpec);
		
		% Display info about each segment
		check_emboli(S_id,'graftEmboliVol',300)
		check_id_parameter_consistency_G1(S_id, idSpec);
		multiWaitbar('Reducing to analysis ID segments',i/numel(ids));
		
	end
	
	S = S(ismember(S.analysis_id,idSpecs.analysis_id),:);
	S.Properties.UserData.Notes = Notes;
	
	% Remove irrelevant columns
	% S will retain noted values for statistical mean calculations
	colsToRem = {
		'analysis_id'
		'bl_id'
	    'event'
		'intervType'
		'part'
		'balLev'
		'pumpSpeed'
		'balDiamEst'
		'injEff'
		'CO'
		'accA_x_NF'
		'accA_y_NF'
		'accA_z_NF'
		'accA_norm'
		'accA_xynorm'
		'accA_yznorm'
		'accA_norm_NF'
		'accA_xynorm_NF'
		'accA_yznorm_NF'
		'graftEmboliCount'
		};
	S(:,ismember(S.Properties.VariableNames,colsToRem)) = [];

	%S = move_key_columns_first(S);
	S = movevars(S,{'noteRow'},"Before",1);
	S.Properties.Description = 'Fused data - Analysis ID segments';
	