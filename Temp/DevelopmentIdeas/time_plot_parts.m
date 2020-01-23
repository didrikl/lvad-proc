figure;

s = signal_parts.part3;
t = s.time(:);
varname = 'acc_length';
var = s.(varname)(:);

plot(t,var)
legend({'x','y','z','length'})

h_subax(1) = subplot(2,1,1);
plot(t,var)
h_ax = gca;
h_ax.YLim = [0.4, 0.8];
h_ax.Position(2) = 0.9*h_ax.Position(2);
h_ax.Position(4) = 1.25*h_ax.Position(4);
yyaxis right
plot(t,s.movStd)
legend({'Moving RMS','Moving Std.'})
h_ax = gca;
h_ax.YLim = [0.005, 0.045];
grid on
title('Part 3','FontSize',18)

h_subax(2) = subplot(2,1,2);
plot(t,s.thrombusVol,'LineWidth',2)%t,signal.pumpSpeed);
h = gca;
h.YLim = h.YLim*1.1;
yyaxis right
%plot(t,str2double(string(signal.pumpSpeed)),'LineWidth',2)%t,signal.pumpSpeed);
plot(t,s.pumpSpeed,'LineWidth',2)%t,signal.pumpSpeed);
%plot(t,signal.event)
grid on
legend({'Thrombus Vol.','RPM'})

linkaxes(h_subax,'x')
