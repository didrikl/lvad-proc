function Data = save_in_memory_struct(varargin)
	
    Data = varargin{1};
	Config = varargin{2};

	Config.seqID = get_seq_id(Config.seq);

	nVarIn = numel(varargin);
	for i=3:nVarIn 
		name = inputname(i);
		Data.(Config.experimentID).(Config.seqID).(name) = varargin{i};
	end
