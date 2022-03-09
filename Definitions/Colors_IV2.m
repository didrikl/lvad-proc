% TODO: Make Colors subclass of a IV2 parent class

% Print-friendly from Colorbrewer: 5-class Set1
Colors.Fig.Cats.Speeds4 = [
	%228,26,28 % red
	55,126,184 % blue
	77,175,74  % green
	152,78,163 % purple
	255,127,0  % orange
	]/256;


% Colorblind safe from Colorbrewer: 5-class YlGnBu (yellow-ish to blue)
Colors.Fig.Seqs.ROC4 = [
	%5,255,204 % yellow-ish
	161,218,180  % light green-yellow-ish
	65,182,196   % turquise
	44,127,184   % light blue
	37,52,148    % dark blue
	]/256;          
Colors.Fig.Cats.ROC_Diagonal = [228,26,28]/256; % red

% Colorblind safe from www.fabiocrameri.ch/: Samples from Batlow10
Colors.Fig.Seqs.Speeds4 = [
	0.0052    0.0982    0.3498
	%0.0631    0.2471    0.3750
	%0.1097    0.3531    0.3842
	0.2371    0.4283    0.3356
	%0.4095    0.4824    0.2413
	%0.6160    0.5372    0.1698
	0.8255    0.5777    0.2642
	%0.9708    0.6324    0.4833
	0.9923    0.7162    0.7371
	%0.9814    0.8004    0.9813
	];

Colors.Fig.Cats.Components4 = [
	% 37,52,148  % dark blue 
	55,126,184 % blue for y 
	%44,127,184 % medium blue for y
	77,175,74  % green for x
	152,78,163 % purple for z
	255,127,0  % orange for norm
	]/256;

Colors.Fig.Cats.Intervention5 = [
	 0.0052    0.0982    0.3498
    0.1097    0.3531    0.3842
    0.6445    0.0586    0.0820 %0.4095    0.4824    0.2413
    0.8255    0.5777    0.2642
	0.4095    0.4824    0.2413
    0.9923    0.7162    0.7371
	];

Colors.Fig.Cats.Intervention5 = [
	0.8255    0.5777    0.2642 %0.0052    0.0982    0.3498
    0.0052    0.0982    0.3498 %.6 .6 .6                     %0.8255    0.5777    0.2642%0.4095    0.4824    0.2413%.5 .5 .5
    0.6445    0.0586    0.0820  %0.4095    0.4824    0.2413
    .6 .6 .6 %0.8255    0.5777    0.2642   %.65 .65 .65 %0.8255    0.5777    0.2642
	.8 .8 .8
	0.4095    0.4824    0.2413
   ];

Colors.Fig.Cats.Intervention5 = [
	 0.0052    0.0982    0.3498 
    0.1097    0.3531    0.3842 
   0.8255    0.5777    0.2642
   .75 .75 .75
	.88 .88 .88
	0.4095    0.4824    0.2413
   ];

% TODO: Read all colormaps into
%Colors.Fig.Maps.Spectrogram = 


Colors.Proc.Done_Green = [49,163,84]/256;
Colors.Proc.Undone_Red = [228,26,28]/256;
Colors.Proc.Wait_Orange = [255,127,0]/256;

load('ScientificColormaps')
Colors.Fig.RPM_Order_Map = scientificColormaps.batlow;