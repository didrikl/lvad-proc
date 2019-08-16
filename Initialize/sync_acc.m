function lead_acc = sync_acc(lead_acc, lvad_acc)
    
    % Assume first that the clocks start at the same time, hence changing the
    % time stamps accordingly in acc2. This is useful in the case there the time
    % stamps are way off. This in turn allows for using notes info to look for
    % finer adjustments  
    ts_start_diff = lead_acc.timestamp(1) - lvad_acc.timestamp(1);
    lead_acc.timestamp = lead_acc.timestamp - ts_start_diff;
    
    % Calculate variables used for syncing
%     lvad_acc.acc_length = sqrt(sum(lvad_acc.acc.^2,2));
%     lead_acc.acc_length = sqrt(sum(lead_acc.acc.^2,2));
%     lvad_acc = calc_moving(lvad_acc);
%     lead_acc = calc_moving(lead_acc);
    
    % Sync point found manually
    lvad_acc_sync_point = datetime('7-Dec-2018 17:24:12.865','InputFormat','dd-MMM-yyyy HH:mm:ss.SSS','Format','dd-MMM-uuuu HH:mm:ss.SSS');
    lead_acc_sync_point = datetime('7-Dec-2018 17:29:49.540','InputFormat','dd-MMM-yyyy HH:mm:ss.SSS','Format','dd-MMM-uuuu HH:mm:ss.SSS');
    ts_data_diff = lead_acc_sync_point - lvad_acc_sync_point;
    lead_acc.timestamp = lead_acc.timestamp - ts_data_diff;
    
    % Verify visually that syncing worked (at picked manually event/window, 
    % that not containing the sync points)
    lvad_zoom  = lvad_acc.timestamp > '07-Dec-2018 17:00:30.011' & lvad_acc.timestamp < '07-Dec-2018 17:05:10.523';
    lead_zoom  = lead_acc.timestamp > '07-Dec-2018 17:00:30.011' & lead_acc.timestamp < '07-Dec-2018 17:05:10.523';
    close all
    figure('Name','3 component vector length for LVAD accelerometer')
    h1 = plot(lvad_acc.timestamp(lvad_zoom),lvad_acc.acc_length(lvad_zoom));
    ylim([0.7 1.3]);
    figure('Name','3 component vector length for driveline accelerometer')
    h2 = plot(lead_acc.timestamp(lead_zoom),lead_acc.acc_length(lead_zoom));
    ylim([0.7 1.3]);
    
    % Verify visually also with movrms
    figure('Name','Moving RMS for LVAD accelerometer')
    plot(lvad_acc.timestamp,lvad_acc.movrms)
    figure('Name','Moving RMS for driveline accelerometer')
    plot(lead_acc.timestamp,lead_acc.movrms)
    