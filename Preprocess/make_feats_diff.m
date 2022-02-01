function F_diff = make_feats_diff(F, fnc, nominalAsBaseline)
	% Calculate difference from baseline values (tagged in bl_id column) using the
	% specfic fnc function handle input
	
	if nargin<3, nominalAsBaseline=true; end
	
	seqs = unique(F.seq);
    F_diff = cell(numel(seqs),1);
	
	cols = get_varname_of_specific_type(F,'numeric');
	ctrlVars = F.Properties.VariableNames(F.Properties.CustomProperties.Controlled);
	constCols = contains(cols, [ctrlVars,{'GroupCount'}], 'IgnoreCase',true);
	cols = cols(not(constCols));
	    
	% Separate each sequence of feats to look for baseline reference values
    for i=1:numel(seqs)
        feats_i = F(F.seq==seqs{i},:);
        feats_i_diff = feats_i;
        feats_i_diff{:,cols} = nan*feats_i_diff{:,cols};
        
		for j=1:height(feats_i)
			bl_row = find(feats_i.analysis_id==feats_i.bl_id(j));
            
            if isempty(bl_row)
				
				% Missing baseline shall result in NaN-values
				%feats_i.analysis_id
				%feats_i.bl_id(j)
                warning(sprintf(['Baseline row not found',...
                    '\n\tRow where Analysis_id = bl_id = %s',...
                    '\n\tSequence: %s'],...
                    string(feats_i.bl_id(j)),string(seqs{i})));
                feats_i_diff{j,cols} = (feats_i{j,cols}-NaN);
            
             elseif contains(string(feats_i.categoryLabel(j)),'Nominal') && ...
					 nominalAsBaseline
                 
				 % Consider all nominal as baselines (i.e. with no difference)
				 feats_i_diff{j,cols} = 0;%(feats_i{j,cols}-NaN);
            
			else
				
				% Calculate with function handle given
				if numel(bl_row)>1
					warning('Multiple baseline rows for ID in %s, id=%s',...
						seqs{i}, feats_i.bl_id(j))
				else
					feats_i_diff{j,cols} = fnc(feats_i{j,cols},feats_i{bl_row,cols});
				end

            end
            
        end
        F_diff{i} = feats_i_diff;
    end
    
    F_diff = merge_table_blocks(F_diff);
	F_diff = sortrows(F_diff,'id','ascend');