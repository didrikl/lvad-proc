function scientificColormaps = load_scientific_colormaps(path)
	if nargin==0 || not(exist(path,'dir'))
		path = uigetdir;
	end 
		
	files = ls(path);
	files = strip(string(files));
	files = files(endsWith(files,'.mat'));
	if numel(files)==0
		warning('No colormap files found')
		scientificColormaps = load_scientific_colormaps();
		return
	end
	
	scientificColormaps = struct;
	for i=1:numel(files)
		f = files(i);
		map = load(fullfile(path,f));
		mapName = fieldnames(map);
		for j=1:numel(mapName)
			scientificColormaps.(mapName{j}) = map.(mapName{j});
		end
	end
	
	fprintf('\n%d colormaps loaded into ScientificColormap\n',numel(files))