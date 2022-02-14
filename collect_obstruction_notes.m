pc = get_processing_config_defaults_G1;

inputs = {
	'Seq3' % (pilot)
  	'Seq6'
  	'Seq7'
  	'Seq8'
  	'Seq11'
  	'Seq12'
  	'Seq13'
  	'Seq14'
	};
xLab = 'balloon diameter (mm)\newlineareal obstruction';

levLims = pc.levLims;

close all
seqList = {};
balLev = [];
balDiam = [];
arealObstr_pst = [];
nha = [];
speeds = [2400,2200,2600];
speeds = pc.speeds;

for i=1:numel(inputs)
	for j=1:numel(pc.speeds)
	
		F2 = F(F.pumpSpeed==speeds(j) & F.balLev~='-' & F.seq==inputs{i},:);
		F2 = add_revised_balloon_levels(F2, levLims);

		seqID = [inputs{i}(1:3),sprintf('%02d',str2double(inputs{i}(4:end)))];
		ID = [seqID,' ',num2str(speeds(j))];
		seqList = [seqList;cellstr(repmat(ID,height(F2),1))];
		balLev = [balLev;F2.balLev_xRay];
		balDiam = [balDiam;F2.balDiam_xRay_mean];
		arealObstr_pst = [arealObstr_pst;F2.arealObstr_pst];
		nha = [nha;F2.accA_x_NF_HP_b2_pow];
	end
end

seqList = strrep(seqList,' ',', ');
seqList = strrep(seqList,'Seq','E ');
seqList = categorical(seqList);

for i=1:numel(levLims)
	inds = balLev==i;
	%scatter(balDiam(inds),seqList(inds),80,'filled','square');
	scatter(balDiam(inds),seqList(inds),35,'filled','o');
	hold on
end

xlim([7.3,12.7])
xticks(levLims)
xline(levLims(2:end),'LineStyle',':','Alpha',0.45,'LineWidth',1)
yline(0.5:3:27,'LineStyle',':','Alpha',0.4,'LineWidth',1)

xlabel(xLab)

h_ax = gca;
obstr_diam = string(compose('%2.1f',string(h_ax.XTick)))';
obstr_pst = "\newline"+string(num2str(100*(h_ax.XTick'.^2)/(pc.inletInnerDiamLVAD^2),2.0))+"%";
if h_ax.XTick(end) == pc.inletInnerDiamLVAD
	obstr_pst(end) = '\newline100%';
end
h_ax.XTickLabel = obstr_diam+obstr_pst;
text(17,1.7,'air in balloon')

createtextarrow(gcf);

function createtextarrow(figure1)
	% Create textarrow
	annotation(figure1,'textarrow',[0.928583144383317 0.903209038983175],...
		[0.661306532663318 0.661306532663318],'String','Air in balloon','LineWidth',2,...
		'HeadWidth',12,...
		'HeadStyle','plain',...
		'HeadLength',12,...
		'FontSize',16,...
		'FontName','Arial Narrow');
end




