function F_diff = make_feats_diff(feats,fnc,nominalAsBaseline)
	% Calculate difference from baseline values (tagged in bl_id column) using the
	% specfic fnc function handle input
	
	if nargin<3, nominalAsBaseline=true; end
	
	seqs = unique(feats.seq);
    F_diff = cell(numel(seqs),1);
    cols = get_varname_of_specific_type(feats,'numeric');
	    
	% Separate each sequence of feats to look for baseline reference values
    for i=1:numel(seqs)
        feats_i = feats(feats.seq==seqs{i},:);
        feats_i_diff = feats_i;
        feats_i_diff{:,cols} = nan*feats_i_diff{:,cols};
        
		for j=1:height(feats_i)
            bl_row = find(feats_i.analysis_id==feats_i.bl_id(j));
            
            if isempty(bl_row)
				
				% Missing baseline shall result in NaN-values
                warning(sprintf(['Baseline row not found',...
                    '\n\tRow where Analysis_id = bl_id = %s',...
                    '\n\tSequence: %s'],...
                    string(feats.bl_id(j)),string(seqs{i})));
                feats_i_diff{j,cols} = (feats_i{j,cols}-NaN);
            
             elseif contains(string(feats_i.categoryLabel(j)),'Nominal') && ...
					 nominalAsBaseline
                 
				 % Consider all nominal as baselines (i.e. with no difference)
				 feats_i_diff{j,cols} = 0;%(feats_i{j,cols}-NaN);
            
			else
				
				% Calculate with function handle given
				feats_i_diff{j,cols} = fnc(feats_i{j,cols},feats_i{bl_row,cols});
                
            end
            
        end
        F_diff{i} = feats_i_diff;
    end
    
    F_diff = merge_table_blocks(F_diff);
    F_diff = sortrows(F_diff,'id','ascend');