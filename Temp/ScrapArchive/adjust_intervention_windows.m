% TODO: Sync to start of pumpthombosis and make equal time windows

iv_note_inds = find(notes.event=='Thrombus injection');
iv_ranges = notes.event_range(iv_note_inds);






close all
h_ax(1) = subplot(4,1,1);
hold on
for i=1:3
    data_part = parts.(['part',num2str(i)]);
    yyaxis left
    plot(data_part.time, data_part.movRMS_sum)
    yyaxis right
    plot(data_part.time, data_part.movStd_sum)
    h_ax(1).ColorOrderIndex = 1;
end
data_part = parts.pause;
yyaxis left
h_p1 = plot(data_part.time, data_part.movRMS_sum,'.');
yyaxis right
h_p2 = plot(data_part.time, data_part.movStd_sum,'.');
hold off

h_ax(2) = subplot(4,1,2);
yyaxis left
plot(data_clip.time, data_clip.pumpSpeed,'clipping','on')
yyaxis right
plot(data_clip.time, data_clip.thrombusVol,'clipping','on')
% 
% h_ax(3) = subplot(4,1,3);
% scatter(notes.time, notes.efferentP, 'filled')
% hold on 
% scatter(notes.time, notes.afferentP, 'filled')
% hold off
% h_ax(3).YLim = [min(h_ax(3).YLim(1),-5),h_ax(3).YLim(2)*1.15];
% legend({'Afferent','Efferent','Flow'})
% 
% h_ax(4) = subplot(4,1,4);
% yyaxis left
% plot(parts.time, parts.event_intervention,'.','MarkerSize',15)
% yyaxis right
% plot(parts.time, parts.intervType,'.','MarkerSize',15)
% h_ax(2) = subplot(4,1,2);
% 
% linkaxes(h_ax,'x')
% h_ax(1).XLim = [parts.time(1),parts.time(end)];
% 



%%
figure
hold on
%signal.t.Format = 'SS';
for i=1:numel(iv_injection_ranges)
    plot_data = signal(iv_injection_ranges{i},:);
    plot_time = plot_data.t - plot_data.t(2);
    h_plt = plot(plot_time,sum(plot_data.movRMS,2));
    %h_plt.Color(4) = 0.2;
end

h_ax = gca;
h_ax.YLim(1) = 0;

hold off
h_leg = legend(string(notes.thrombusVol(notes.event=='Thrombus injection')));
get(h_leg)





