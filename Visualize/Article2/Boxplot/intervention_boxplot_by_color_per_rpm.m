function h = intervention_boxplot_by_color_per_rpm(...
		F, levs, vars, accAsdB, saveFig, Config)
	
	group = make_intervention_groups(F, levs);
	sPath = fullfile(Config.fig_path,'Boxplot');
	for i=1:size(vars,1)
		h = plot_intervention_boxes_per_rpm(...
			accAsdB, F, vars{i,1}, group, vars{i,2}, vars{i,3});
		if saveFig
			levStr = make_level_sting_for_save_name(levs);
			fileName = ['Boxplot per RPM - ',vars{i,2},' - ',levStr];
			save_figure(h, sPath, fileName, 300);
		end
	end
	
function hFig = plot_intervention_boxes_per_rpm(accAsdB, F, var, group, varLab, ylims)
	
	specs = get_plot_specs;
	Colors_IV2

	% Used for converting accelerometer band powers into dB
	y = convert_bandpower_to_decibel(accAsdB, var, F);

	% Add more RPM categories just to make more space between the sets of boxes
	%speed = categorical(F.pumpSpeed,[2400 2500 2200 2300 2600],'Ordinal',true);
	speed = categorical(F.pumpSpeed,[2400 2200 2600],'Ordinal',true);

	hFig = figure('Position',[380.5,222,1500,800]);
	axes('Position',[0.07,0.11,0.701923,0.815]);
	boxchart(speed, y, 'GroupByColor',group, ...
		'Notch','off',...
		'BoxWidth',0.75,...
		'BoxFaceAlpha',0.575,...
		'LineWidth',1.5 ...
		);
	h_ax = gca;
	set(h_ax,specs.ax{:},...
		'Color',[.97 .97 .97],...
		'GridColor',[.97 .97 .97],...
		'Color',[1 1 1],...
		'ColorOrder',Colors.Fig.Cats.Intervention5, ...
		'GridColor',[1 1 1]...
		)
	h_ax.XAxis.TickDirection = 'both';
	h_leg = legend('Position',[0.792,0.125,0.1907,0.117], specs.leg{:},...
		'FontSize',13);
	title(varLab, specs.supTit{:})
	
	%  	xt = xticks;
	%  	xticks(xt(xt~='2300' & xt~='2500'));

	hXLab = xlabel('Pump speed (RPM)',specs.supXLab{:});
	hXLab.Position(2) = hXLab.Position(2)-10;
	hYLab = ylabel(varLab,specs.supXLab{:});
	hYLab.Position(1) = hYLab.Position(1)-15;

	% 	xline([1.5,2.5],...
	% 		'HandleVisibility','off',...
	% 		'Color',[.8 .8 .8],...
	% 		...'Color',[0 0 0],...
	% 		'LineWidth',1.5,...
	% 		'LineStyle','-')
	
	if not(isempty(ylims)), ylim(ylims); end
