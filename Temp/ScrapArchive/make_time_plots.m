%function make_time_plots(signal,varname)

figure;

t = signal.timestamp(:);
varname = 'acc_length';
s = signal.(varname)(:);

%s = s-movmean(s,1000); --> no good solution
%s = detrend(s);
%close all

subplot(3,1,1)
hold on
plot(t,signal.acc(:,1));
plot(t,signal.acc(:,2),'Color',[0.62,0.76,0.85]);
plot(t,signal.acc(:,3),'Color',[0.00,0.23,0.37]);
h = gca;
h.YLim = h.YLim - 0.5;
yyaxis 'right'
plot(t,s)
legend({'x','y','z','length'})

subplot(3,1,2)
plot(t,signal.movRMS)
yyaxis right
plot(t,signal.movStd)
legend({'Moving RMS','Moving Std.'})
subplot(3,1,3)
plot(t,signal.thrombusVolume,'LineWidth',2)%t,signal.pumpSpeed);
h = gca;
h.YLim = h.YLim*1.1;
yyaxis right
%plot(t,str2double(string(signal.pumpSpeed)),'LineWidth',2)%t,signal.pumpSpeed);
plot(t,signal.pumpSpeed,'LineWidth',2)%t,signal.pumpSpeed);
%plot(t,signal.event)
legend({'Thrombus Vol.','RPM'})
