function T2 = lookup_plot_data(T1, levLims, sequences)
	
	if nargin<3, sequences = sort_nat(unique(T1.seq)); end
	speeds = unique(T1.pumpSpeed(T1.categoryLabel=='Balloon'));
	
	T2 = table;
	seqList = {};
	for j=1:numel(speeds)
		for i=1:numel(sequences)
			
			F2 = T1(T1.pumpSpeed==speeds(j) & T1.balLev~='-' & T1.seq==sequences{i},:);
			F2 = add_revised_balloon_levels(F2, levLims);
			if isempty(F2) 
				% Make a empty dummy row
				F2{end+1,20} = missing;
			end
			T2 = merge_table_blocks(T2,F2);
			
			inputs_i = split(sequences{i},'_');
			seqID = [inputs_i{1}(1:3),sprintf('%02d',str2double(inputs_i{1}(4:end)))];
			ID = [seqID,' ',num2str(speeds(j))];
			seqList = [seqList;cellstr(repmat(ID,height(F2),1))];
			
		end
	end
	change_seq_list_to_ylabel(seqList)
	T2.seqList = change_seq_list_to_ylabel(seqList);
	
end

function seqList = change_seq_list_to_ylabel(seqList)
	seqList = strrep(seqList,'Seq12 2400','Seq12 2400*');
	seqList = strrep(seqList,'Seq06 2200','Seq06 2200**');
	seqList = strrep(seqList,' ','    ');
	seqList = strrep(seqList,'Seq','# ');
	seqList = categorical(seqList);
end
