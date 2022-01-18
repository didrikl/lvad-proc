function [pxx, f, mpf, pow] = calc_periodogram_metrics(x, fs, freqBands)
	
	[pxx,f] = periodogram(detrend(x),[],[],fs);

	[mpf.b1,pow.b1] = meanfreq(pxx,f);
	for i=1:size(freqBands,1)
		b = ['b',num2str(i+1)'];
		[mpf.(b),pow.(b)] = meanfreq(pxx,f,freqBands(i,1:2));
	end
