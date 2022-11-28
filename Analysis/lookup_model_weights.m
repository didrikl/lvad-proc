function weight = lookup_model_weights(sequences, Data)

	weight = nan(numel(sequences),1);
	for i=1:numel(sequences)
		weight(i) = str2double(Data.(sequences{i}). ...
			Notes.Properties.UserData.Experiment_Info.PigWeight0x28kg0x29);
	end
