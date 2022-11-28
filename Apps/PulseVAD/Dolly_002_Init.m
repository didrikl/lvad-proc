%% Initialze the processing environment and input file structure
% Use package...
init_matlab

welcome('Initializing user-input','module')

% Which experiment
basePath = 'D:\Data\IVS\Einar';
Config.seq_subdir = 'Dolly-002';
save_path = 'C:\Users\Didrik\Desktop\Dolly';
%save_path = 'D:\Data\IVS\Einar\Dolly-002';
%save_path = 'E:\';

% Which files to input from input directory
% NOTE: Could be implemented to be selected interactively using uigetfiles
Config.labChart_fileNames{1} = {
    'SingleChannels\Ch1\LeuvenDolly1.2PumpTest2020_day1.mat'
    'SingleChannels\Ch2\LeuvenDolly1.2PumpTest2020_day1.mat'
    'SingleChannels\Ch4\LeuvenDolly1.2PumpTest2020_day1.mat'
    'SingleChannels\Ch5\LeuvenDolly1.2PumpTest2020_day1.mat'
    'SingleChannels\Ch6\LeuvenDolly1.2PumpTest2020_day1.mat'
    'SingleChannels\Ch7\LeuvenDolly1.2PumpTest2020_day1.mat'
    'SingleChannels\Ch8\LeuvenDolly1.2PumpTest2020_day1.mat'
    'SingleChannels\Ch9\LeuvenDolly1.2PumpTest2020_day1.mat'
    'SingleChannels\Ch10\LeuvenDolly1.2PumpTest2020_day1.mat'
    'SingleChannels\Ch11\LeuvenDolly1.2PumpTest2020_day1.mat'
    'SingleChannels\Ch12\LeuvenDolly1.2PumpTest2020_day1.mat'
    'SingleChannels\Ch13\LeuvenDolly1.2PumpTest2020_day1.mat'
    'SingleChannels\Ch14\LeuvenDolly1.2PumpTest2020_day1.mat'
    'SingleChannels\Ch15\LeuvenDolly1.2PumpTest2020_day1.mat'
    'SingleChannels\Ch16\LeuvenDolly1.2PumpTest2020_day1.mat'
    };
Config.labChart_fileNames{2} = {
%     'SingleChannels\Ch1\LeuvenDolly1.2PumpTest2020_day2.mat'
%     'SingleChannels\Ch2\LeuvenDolly1.2PumpTest2020_day2.mat'
%     'SingleChannels\Ch4\LeuvenDolly1.2PumpTest2020_day2.mat'
%     'SingleChannels\Ch5\LeuvenDolly1.2PumpTest2020_day2.mat'
    'SingleChannels\Ch6\LeuvenDolly1.2PumpTest2020_day2.mat'
    'SingleChannels\Ch7\LeuvenDolly1.2PumpTest2020_day2.mat'
    'SingleChannels\Ch8\LeuvenDolly1.2PumpTest2020_day2.mat'
    'SingleChannels\Ch9\LeuvenDolly1.2PumpTest2020_day2.mat'
    'SingleChannels\Ch10\LeuvenDolly1.2PumpTest2020_day2.mat'
    'SingleChannels\Ch11\LeuvenDolly1.2PumpTest2020_day2.mat'
    'SingleChannels\Ch12\LeuvenDolly1.2PumpTest2020_day2.mat'
    'SingleChannels\Ch13\LeuvenDolly1.2PumpTest2020_day2.mat'
    'SingleChannels\Ch14\LeuvenDolly1.2PumpTest2020_day2.mat'
    'SingleChannels\Ch15\LeuvenDolly1.2PumpTest2020_day2.mat'
    'SingleChannels\Ch16\LeuvenDolly1.2PumpTest2020_day2.mat'
    };
Config.labChart_fileNames{3} = {
    'SingleChannels\Ch6\LeuvenDolly1.2PumpTest2020_day3.mat'
    'SingleChannels\Ch7\LeuvenDolly1.2PumpTest2020_day3.mat'
    'SingleChannels\Ch8\LeuvenDolly1.2PumpTest2020_day3.mat'
    'SingleChannels\Ch9\LeuvenDolly1.2PumpTest2020_day3.mat'
    'SingleChannels\Ch10\LeuvenDolly1.2PumpTest2020_day3.mat'
    'SingleChannels\Ch11\LeuvenDolly1.2PumpTest2020_day3.mat'
    'SingleChannels\Ch12\LeuvenDolly1.2PumpTest2020_day3.mat'
    'SingleChannels\Ch13\LeuvenDolly1.2PumpTest2020_day3.mat'
    'SingleChannels\Ch14\LeuvenDolly1.2PumpTest2020_day3.mat'
    'SingleChannels\Ch15\LeuvenDolly1.2PumpTest2020_day3.mat'
    'SingleChannels\Ch16\LeuvenDolly1.2PumpTest2020_day3.mat'
    };
Config.labChart_fileNames{4} = {
    'SingleChannels\Ch6\LeuvenDolly1.2PumpTest2020_day4.mat'
    'SingleChannels\Ch7\LeuvenDolly1.2PumpTest2020_day4.mat'
    'SingleChannels\Ch8\LeuvenDolly1.2PumpTest2020_day4.mat'
    'SingleChannels\Ch9\LeuvenDolly1.2PumpTest2020_day4.mat'
    'SingleChannels\Ch10\LeuvenDolly1.2PumpTest2020_day4.mat'
    'SingleChannels\Ch11\LeuvenDolly1.2PumpTest2020_day4.mat'
    'SingleChannels\Ch12\LeuvenDolly1.2PumpTest2020_day4.mat'
    'SingleChannels\Ch13\LeuvenDolly1.2PumpTest2020_day4.mat'
    'SingleChannels\Ch14\LeuvenDolly1.2PumpTest2020_day4.mat'
    'SingleChannels\Ch15\LeuvenDolly1.2PumpTest2020_day4.mat'
    'SingleChannels\Ch16\LeuvenDolly1.2PumpTest2020_day4.mat'
    };
Config.labChart_fileNames{5} = {
    'SingleChannels\Ch6\LeuvenDolly1.2PumpTest2020_day5.mat'
    'SingleChannels\Ch7\LeuvenDolly1.2PumpTest2020_day5.mat'
    'SingleChannels\Ch8\LeuvenDolly1.2PumpTest2020_day5.mat'
    'SingleChannels\Ch9\LeuvenDolly1.2PumpTest2020_day5.mat'
    'SingleChannels\Ch10\LeuvenDolly1.2PumpTest2020_day5.mat'
    'SingleChannels\Ch11\LeuvenDolly1.2PumpTest2020_day5.mat'
    'SingleChannels\Ch12\LeuvenDolly1.2PumpTest2020_day5.mat'
    'SingleChannels\Ch13\LeuvenDolly1.2PumpTest2020_day5.mat'
    'SingleChannels\Ch14\LeuvenDolly1.2PumpTest2020_day5.mat'
    'SingleChannels\Ch15\LeuvenDolly1.2PumpTest2020_day5.mat'
    'SingleChannels\Ch16\LeuvenDolly1.2PumpTest2020_day5.mat'
    };
Config.labChart_fileNames{6} = {
    'SingleChannels\Ch6\LeuvenDolly1.2PumpTest2020_day6.mat'
    'SingleChannels\Ch7\LeuvenDolly1.2PumpTest2020_day6.mat'
    'SingleChannels\Ch8\LeuvenDolly1.2PumpTest2020_day6.mat'
    'SingleChannels\Ch9\LeuvenDolly1.2PumpTest2020_day6.mat'
    'SingleChannels\Ch10\LeuvenDolly1.2PumpTest2020_day6.mat'
    'SingleChannels\Ch11\LeuvenDolly1.2PumpTest2020_day6.mat'
    'SingleChannels\Ch12\LeuvenDolly1.2PumpTest2020_day6.mat'
    'SingleChannels\Ch13\LeuvenDolly1.2PumpTest2020_day6.mat'
    'SingleChannels\Ch14\LeuvenDolly1.2PumpTest2020_day6.mat'
    'SingleChannels\Ch15\LeuvenDolly1.2PumpTest2020_day6.mat'
    'SingleChannels\Ch16\LeuvenDolly1.2PumpTest2020_day6.mat'
    };
Config.labChart_fileNames{7} = {
    'SingleChannels\Ch6\LeuvenDolly1.2PumpTest2020_day7.mat'
    'SingleChannels\Ch7\LeuvenDolly1.2PumpTest2020_day7.mat'
    'SingleChannels\Ch8\LeuvenDolly1.2PumpTest2020_day7.mat'
    'SingleChannels\Ch9\LeuvenDolly1.2PumpTest2020_day7.mat'
    'SingleChannels\Ch10\LeuvenDolly1.2PumpTest2020_day7.mat'
    'SingleChannels\Ch11\LeuvenDolly1.2PumpTest2020_day7.mat'
    'SingleChannels\Ch12\LeuvenDolly1.2PumpTest2020_day7.mat'
    'SingleChannels\Ch13\LeuvenDolly1.2PumpTest2020_day7.mat'
    'SingleChannels\Ch14\LeuvenDolly1.2PumpTest2020_day7.mat'
    'SingleChannels\Ch15\LeuvenDolly1.2PumpTest2020_day7.mat'
    'SingleChannels\Ch16\LeuvenDolly1.2PumpTest2020_day7.mat'
    };
Config.labChart_fileNames{8} = {
    'SingleChannels\Ch6\LeuvenDolly1.2PumpTest2020_day8.mat'
    'SingleChannels\Ch7\LeuvenDolly1.2PumpTest2020_day8.mat'
    'SingleChannels\Ch8\LeuvenDolly1.2PumpTest2020_day8.mat'
    'SingleChannels\Ch9\LeuvenDolly1.2PumpTest2020_day8.mat'
    'SingleChannels\Ch10\LeuvenDolly1.2PumpTest2020_day8.mat'
    'SingleChannels\Ch11\LeuvenDolly1.2PumpTest2020_day8.mat'
    'SingleChannels\Ch12\LeuvenDolly1.2PumpTest2020_day8.mat'
    'SingleChannels\Ch13\LeuvenDolly1.2PumpTest2020_day8.mat'
    'SingleChannels\Ch14\LeuvenDolly1.2PumpTest2020_day8.mat'
    'SingleChannels\Ch15\LeuvenDolly1.2PumpTest2020_day8.mat'
    'SingleChannels\Ch16\LeuvenDolly1.2PumpTest2020_day8.mat'
    };
Config.labChart_fileNames{9} = {
    'SingleChannels\Ch6\LeuvenDolly1.2PumpTest2020_day9.mat'
    'SingleChannels\Ch7\LeuvenDolly1.2PumpTest2020_day9.mat'
    'SingleChannels\Ch8\LeuvenDolly1.2PumpTest2020_day9.mat'
    'SingleChannels\Ch9\LeuvenDolly1.2PumpTest2020_day9.mat'
    'SingleChannels\Ch10\LeuvenDolly1.2PumpTest2020_day9.mat'
    'SingleChannels\Ch11\LeuvenDolly1.2PumpTest2020_day9.mat'
    'SingleChannels\Ch12\LeuvenDolly1.2PumpTest2020_day9.mat'
    'SingleChannels\Ch13\LeuvenDolly1.2PumpTest2020_day9.mat'
    'SingleChannels\Ch14\LeuvenDolly1.2PumpTest2020_day9.mat'
    'SingleChannels\Ch15\LeuvenDolly1.2PumpTest2020_day9.mat'
    'SingleChannels\Ch16\LeuvenDolly1.2PumpTest2020_day9.mat'
    };
Config.labChart_fileNames{10} = {
    'SingleChannels\Ch6\LeuvenDolly1.2PumpTest2020_day10.mat'
    'SingleChannels\Ch7\LeuvenDolly1.2PumpTest2020_day10.mat'
    'SingleChannels\Ch8\LeuvenDolly1.2PumpTest2020_day10.mat'
    'SingleChannels\Ch9\LeuvenDolly1.2PumpTest2020_day10.mat'
    'SingleChannels\Ch10\LeuvenDolly1.2PumpTest2020_day10.mat'
    'SingleChannels\Ch11\LeuvenDolly1.2PumpTest2020_day10.mat'
    'SingleChannels\Ch12\LeuvenDolly1.2PumpTest2020_day10.mat'
    'SingleChannels\Ch13\LeuvenDolly1.2PumpTest2020_day10.mat'
    'SingleChannels\Ch14\LeuvenDolly1.2PumpTest2020_day10.mat'
    'SingleChannels\Ch15\LeuvenDolly1.2PumpTest2020_day10.mat'
    'SingleChannels\Ch16\LeuvenDolly1.2PumpTest2020_day10.mat'
    };
Config.labChart_fileNames{11} = {
    'SingleChannels\Ch6\LeuvenDolly1.2PumpTest2020_day11.mat'
    'SingleChannels\Ch7\LeuvenDolly1.2PumpTest2020_day11.mat'
    'SingleChannels\Ch8\LeuvenDolly1.2PumpTest2020_day11.mat'
    'SingleChannels\Ch9\LeuvenDolly1.2PumpTest2020_day11.mat'
    'SingleChannels\Ch10\LeuvenDolly1.2PumpTest2020_day11.mat'
    'SingleChannels\Ch11\LeuvenDolly1.2PumpTest2020_day11.mat'
    'SingleChannels\Ch12\LeuvenDolly1.2PumpTest2020_day11.mat'
    'SingleChannels\Ch13\LeuvenDolly1.2PumpTest2020_day11.mat'
    'SingleChannels\Ch14\LeuvenDolly1.2PumpTest2020_day11.mat'
    'SingleChannels\Ch15\LeuvenDolly1.2PumpTest2020_day11.mat'
    'SingleChannels\Ch16\LeuvenDolly1.2PumpTest2020_day11.mat'
    };

proc_path = fullfile(basePath,Config.seq_subdir,'Processed');

powerlab_variable_map = {
    % LabChart name  SingleChannels name   Type        Continuity
    'Art'            'art'         'single'    'continuous'
    'CVP'            'cvp'         'single'    'continuous'
    %'LAPLVP'         'laplvp'      'single'    'continuous'
    'AortaFLow'      'aorta_flow'  'single'    'continuous'
    'PumpFLow'       'pump_flow'   'single'    'continuous'
    'ECG'            'ecg'         'single'    'continuous'
    'SYNC'           'sync'        'single'    'continuous'
    'PmpAccX'        'pump_acc_x'  'single'    'continuous'
    'PmpAccY'        'pump_acc_y'  'single'    'continuous'
    'PmpAccZ'        'pump_acc_z'  'single'    'continuous'
    'pumpSpeed'      'pump_speed'  'single'    'continuous'
    'PumpCurrent'    'pump_curr'   'single'    'continuous'
    'PumpVoltage'    'pump_volt'   'single'    'continuous'
    'EACCX'          'e_acc_x'     'single'    'continuous'
    'EACCY'          'e_acc_y'     'single'    'continuous'
    'EACCZ'          'e_acc_z'     'single'    'continuous'
    };


%% Read data as exported from LabChart

welcome('Initializing individual channel data','module')

for i=1:11
    powerlab_filePaths = fullfile(basePath,Config.seq_subdir,Config.labChart_fileNames{i});
    PL = init_labchart_mat_files(powerlab_filePaths,'',powerlab_variable_map);
    T = merge_table_blocks(PL);
    T = resample_signal(T, 500);
    T.time.Format = 'dd-MMM HH:mm:ss.SSS';
%     save_data(['Day',num2str(i)], save_path, T, 'text');
    save_data(['Day',num2str(i)], save_path, T, 'matlab');
end


%% Read data from merged Matlab files and pre-process

welcome('Initialize and preprocess data','module')

days = [1:11];
T_mean = cell(numel(days),1);
T_std = cell(numel(days),1);
T_med = cell(numel(days),1);
T_25qrt = cell(numel(days),1);
T_75qrt = cell(numel(days),1);
T_1Hz = cell(numel(days),1);
for i=days
    welcome(sprintf(['Day ',num2str(i),'\n']),'iteration')
    
    load(['C:\Users\Didrik\Desktop\Dolly\Day',num2str(i),'.mat']);
    
    % Temporary fix for table name in storage
    if i~=2, T = t; clear t; end   
    T.time.Format = 'dd-MMM HH:mm:ss.SSS';
    %T = resample_signal(T, 1000);
    
    T = add_spatial_norms(T,2,{'pump_acc_x','pump_acc_y','pump_acc_z'},'pump_acc_norm');
    T = add_spatial_norms(T,2,{'e_acc_x','e_acc_y','e_acc_z'},'e_acc_norm');
    T = remove_variables(T,{'pump_acc_x','pump_acc_y','pump_acc_z'});
    T = remove_variables(T,{'e_acc_x','e_acc_y','e_acc_z'});
    T = remove_variables(T,{'sync'});
    
    stat_interv_len = hours(1);
    T_mean{i} = retime(T,'regular','mean','TimeStep',stat_interv_len);
    T_std{i} = retime(T,'regular',@std,'TimeStep',stat_interv_len);
    T_med{i} = retime(T,'regular',@median,'TimeStep',stat_interv_len);
    T_25qrt{i} = retime(T,'regular',@(x)prctile(x,25),'TimeStep',stat_interv_len);
    T_75qrt{i} = retime(T,'regular',@(x)prctile(x,75),'TimeStep',stat_interv_len);
    T_mean{i}.time = T_mean{i}.time + 0.5*stat_interv_len;
    T_std{i}.time = T_std{i}.time + 0.5*stat_interv_len;
    T_med{i}.time = T_med{i}.time + 0.5*stat_interv_len;
    T_25qrt{i}.time = T_25qrt{i}.time + 0.5*stat_interv_len;
    T_75qrt{i}.time = T_75qrt{i}.time + 0.5*stat_interv_len;
    T_mean{i}.Properties.VariableNames = T_mean{i}.Properties.VariableNames + "_avg";
    T_std{i}.Properties.VariableNames = T_std{i}.Properties.VariableNames + "_std";
    T_med{i}.Properties.VariableNames = T_med{i}.Properties.VariableNames + "_med";
    T_25qrt{i}.Properties.VariableNames = T_25qrt{i}.Properties.VariableNames + "_25qrt";
    T_75qrt{i}.Properties.VariableNames = T_75qrt{i}.Properties.VariableNames + "_75qrt";
    
    %     T = add_moving_statistics(T,...
    %         {'pump_speed','pump_curr','pump_volt'},{'avg'});
    %T = remove_variables(T,{'pump_speed','pump_curr','pump_volt'});
    %     T = add_moving_statistics(T,...
    %         {'e_acc_norm','pump_acc_norm'},{'rms'});
    %T = remove_variables(T,{'e_acc_norm','pump_acc_norm'});
    
    %T_1Hz{i} = resample_signal(T, 1);
    %T_10hz{i} = resample_signal(T, 10);
    
end

%T_1Hz = merge_table_blocks(T_1Hz);
%T_10Hz = merge_table_blocks(T_10Hz);
T_stats = [merge_table_blocks(T_mean),merge_table_blocks(T_std),...
    merge_table_blocks(T_med),...
    merge_table_blocks(T_25qrt),merge_table_blocks(T_75qrt)];
T_stats.time.Format = 'HH:mm:ss';
T_stats.date = T_stats.time; 
T_stats = movevars(T_stats,'date','Before',1);
T_stats.date.Format = 'dd-MMM';

%% Save 

save_data('Day1-11 - 10Hz', save_path, T_10Hz, 'matlab');

T_10Hz_for_text_save = T_10Hz;
T_10Hz_for_text_save.t = single(seconds(T_10Hz_for_text_save.time-T_10Hz_for_text_save.time(1)));
T_10Hz_for_text_save = timetable2table(T_10Hz_for_text_save);
T_10Hz_for_text_save.time = [];
T_10Hz_for_text_save = movevars(T_10Hz_for_text_save, 't', 'Before', 'ecg');
save_data(['Day1-11 - 10Hz'], save_path, T_10Hz_for_text_save, 'text');
clear T_10Hz_for_text_save

save_data('Day1-11 - Statistics - 1 hour intervals', save_path, T_stats, 'csv');


%% Moving avg + st.dev. and avg for regular intervals

figure
x = T_10Hz.time;
y = T_10Hz.pump_curr_movAvg;
y_avg = T_stats.pump_curr_avg;
y_std = T_stats.pump_curr_std;
y_med = T_stats.pump_curr_med;
y_25qrt = T_stats.pump_curr_25qrt;
y_75qrt = T_stats.pump_curr_75qrt;

plot(x,y,...
     'Linewidth',0.75,...
     'Color',[1.00,0.41,0.16,0.4])
hold on

% plot(T_stats.time,...
%     [y_avg+y_std...
%      y_avg-y_std],'.',...
%     'MarkerSize',8,...
%     'Marker','_',...
%     'LineWidth',2,...
%     'Color',[0.64,0.08,0.18])
% plot(T_stats.time,y_avg,'.',...
%     'MarkerSize',6,...
%     'Marker','o',...
%     'LineWidth',2,...
%     'Color',[0.64,0.08,0.18])

plot(T_stats.time,...
    [y_25qrt...
     y_75qrt],'.',...
    'MarkerSize',8,...
    'Marker','_',...
    'LineWidth',2,...
    'Color',[0.00,0.45,0.74])
plot(T_stats.time,y_med,'.',...
    'MarkerSize',6,...
    'Marker','o',...
    'LineWidth',2,...
    'Color',[0.00,0.45,0.74])

ylim([0,5500]);

xlines = T_stats.time - 0.5*stat_interv_len;
for i=1:numel(xlines)
    h_xl = xline(xlines(i));
    h_xl.Alpha = 0.25;
    h_xl.LineStyle = ':';
    h_xl.LineWidth = 0.5;
end

title('Pump speed')
legend({...
    'Moving average',...
    'Medians',...
    'Upper quartiles',...
    'Lower quartiles'...
    });


%% Moving avg + quatile range and median for regular intervals

figure
x = T_10Hz.time;

plot(x,T_10Hz.pump_speed_movAvg,...
     'Linewidth',0.75,...
     'Color',[0.00,0.45,0.74,0.5])
hold on
plot(T_stats.time,...
    [T_stats.pump_speed_25qrt...
     T_stats.pump_speed_75qrt],'.',...
    'MarkerSize',8,...
    'Marker','_',...
    'LineWidth',2,...
    'Color',[0.00,0.45,0.74])
plot(T_stats.time,...
    T_stats.pump_speed_med,'.',...
    'MarkerSize',6,...
    'Marker','o',...
    'LineWidth',2,...
    'Color',[0.00,0.45,0.74])


ylim([0,0.8])
xlines = T_stats.time - 0.5*stat_interv_len;
for i=1:numel(xlines)
    h_xl = xline(xlines(i));
    h_xl.Alpha = 0.5;
    h_xl.LineStyle = ':';
end

ylim([0,5500]);

ylabel('Pump speed (RPM)')

%%

%% 
% Moving avg + st.dev. and avg for regular intervals
% Moving avg + quatile range and median for regular intervals

figure
x = T_10Hz.time;

plot(x,T_10Hz.pump_speed_movAvg,...
     'Linewidth',0.75,...
     'Color',[1.00,0.41,0.16,0.4])
hold on
plot(T_stats.time,...
    [T_stats.pump_speed_avg+T_stats.pump_speed_std...
     T_stats.pump_speed_avg-T_stats.pump_speed_std],'.',...
    'MarkerSize',8,...
    'Marker','.',...
    'LineWidth',2,...
    'Color',[0.64,0.08,0.18,0.4])
plot(T_stats.time,...
    T_stats.pump_speed_avg,'.',...
    'MarkerSize',5,...
    'Marker','o',...
    'LineWidth',2,...
    'Color',[0.64,0.08,0.18])

ylim([0,5500]);

xlines = T_stats.time - 0.5*stat_interv_len;
for i=1:numel(xlines)
    h_xl = xline(xlines(i));
    h_xl.Alpha = 0.25;
    h_xl.LineStyle = ':';
    h_xl.LineWidth = 0.5;
end

plot(T_stats.time,...
    [T_stats.pump_speed_25qrt...
     T_stats.pump_speed_75qrt],'.',...
    'MarkerSize',10,...
    'Marker','_',...
    'LineWidth',2,...
    'Color',[0.00,0.45,0.74,0.5])
plot(T_stats.time,...
    T_stats.pump_speed_med,'.',...
    'MarkerSize',5,...
    'Marker','o',...
    'LineWidth',2,...
    'Color',[0.00,0.45,0.74])

ylim([0,5500]);

xlines = T_stats.time - 0.5*stat_interv_len;
for i=1:numel(xlines)
    h_xl = xline(xlines(i));
    h_xl.Alpha = 0.9;
    h_xl.LineStyle = ':';
end


%% Add extra y-axis to current plot

yyaxis right

plot(x,T_1Hz.pump_curr_movAvg,...
     'Linewidth',0.75,...
     'Color',[1.00,0.41,0.16,0.4])
plot(T_stats.time,...
    T_stats.pump_curr_avg,'.',...
    'MarkerSize',6,...
    'Marker','o',...
    'LineWidth',2,...
    'Color',[0.00,0.45,0.74,0.5])

axis tight


%% Example of stacked plot

figure
stackedplot(T_1Hz,{{'pump_acc_norm_movRMS','e_acc_norm_movRMS'},'pump_speed_movAvg'})


%%

figure
tdur = double(seconds(T_1Hz{2}.time-T_1Hz{2}.time(1)));
boundedline(tdur,double(T_1Hz{2}.pump_speed_movAvg),double(T_1Hz{2}.pump_speed_movStd))
xticks(h,0:60*60:tdur(end));
h.XTickLabel=string(xticks/(60*60));

%%

make_rpm_order_map(T_extract,'pump_acc_norm',fs_new,'pump_speed', 0.015, 70);


