function loop_gradual_colormaps(scientificColormaps)

	if nargin==0
		scientificColormaps = load_scientific_colormaps;
	end

	colorMaps = fieldnames(scientificColormaps);
	colorMaps = colorMaps(not(contains(colorMaps,{'10','25','50','O','S'})));
	for i=1:numel(colorMaps)
		colormap(scientificColormaps.(colorMaps{i}));
		colorMaps{i};
		pause
	end
end