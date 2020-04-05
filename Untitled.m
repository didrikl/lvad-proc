t = 0:0.001:2;
x = chirp(t,100,1,200,'quadratic');
[s,f,t,p] = spectrogram(x,128,120,128,1e3);
figure(1)
sh = surf(p);
view(0, 90)
axis tight
yt = get(gca, 'YTick')
set(gca, 'YTick',yt, 'YTickLabel',yt*1E+4)