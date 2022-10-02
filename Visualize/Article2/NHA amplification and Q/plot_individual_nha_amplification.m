close all
D = sortrows(F_rel,'pumpSpeed','ascend');

levels = 2:4; 
nIsIncr = [];
nIsDecr = [];
for lev=1:numel(levels)
	for i=1:numel(sequences)
		seq_inds = ismember(D.seq,sequences{i});
		bal_inds = D.balLev_xRay_mean==lev;
		inds = seq_inds & bal_inds;
		x = D.pumpSpeed(inds);
		y = D.accA_xyz_NF_HP_b1_pow_norm(inds);
		%y = D.Q_mean(inds);
		subplot(1,numel(levels),lev);
		if strcmp(sequences{i},'Seq12')
			plot(x, y, '--o')
		else
			plot(x, y, '-o')
		end
		nIsIncr(i,lev) = sum(diff(y)>=0);
		nIsDecr(i,lev) = sum(diff(y)<0);
		hold on
	end
	%sum(nIsIncr)
	%sum(nIsDecr)
end
disp total
sum(sum(nIsIncr))
sum(sum(nIsDecr))
