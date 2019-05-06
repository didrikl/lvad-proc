% TODO: Sync to start of pumpthombosis and make equal time windows

iv_note_inds = find(notes.event=='Thrombus injection');
iv_ranges = notes.event_range(iv_note_inds);






close all
h_ax(1) = subplot(4,1,1);
hold on
for i=1:3
    data_part = parts.(['part',num2str(i)]);
    yyaxis left
    plot(data_part.timestamp, data_part.movrms_sum)
    yyaxis right
    plot(data_part.timestamp, data_part.movstd_sum)
    h_ax(1).ColorOrderIndex = 1;
end
data_part = parts.pause;
yyaxis left
h_p1 = plot(data_part.timestamp, data_part.movrms_sum,'.');
yyaxis right
h_p2 = plot(data_part.timestamp, data_part.movstd_sum,'.');
hold off

h_ax(2) = subplot(4,1,2);
yyaxis left
plot(data_clip.timestamp, data_clip.pumpSpeed,'clipping','on')
yyaxis right
plot(data_clip.timestamp, data_clip.thrombusVolume,'clipping','on')
% 
% h_ax(3) = subplot(4,1,3);
% scatter(notes.timestamp, notes.efferentPressure, 'filled')
% hold on 
% scatter(notes.timestamp, notes.afferentPressure, 'filled')
% hold off
% h_ax(3).YLim = [min(h_ax(3).YLim(1),-5),h_ax(3).YLim(2)*1.15];
% legend({'Afferent','Efferent','Flow'})
% 
% h_ax(4) = subplot(4,1,4);
% yyaxis left
% plot(parts.timestamp, parts.event_intervention,'.','MarkerSize',15)
% yyaxis right
% plot(parts.timestamp, parts.experimentSubpart,'.','MarkerSize',15)
% h_ax(2) = subplot(4,1,2);
% 
% linkaxes(h_ax,'x')
% h_ax(1).XLim = [parts.timestamp(1),parts.timestamp(end)];
% 

