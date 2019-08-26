function lead_signal = sync_lead_with_lvad_acc(lead_signal, lvad_signal)
    
    % Assume first that the clocks start at the same time, hence changing the
    % time stamps accordingly in acc2. This is useful in the case there the time
    % stamps are way off. This in turn allows for using notes info to look for
    % finer adjustments  
    ts_start_diff = lead_signal.timestamp(1) - lvad_signal.timestamp(1);
    lead_signal.timestamp = lead_signal.timestamp - ts_start_diff;
    
    % Calculate variables used for verifying the syncing
    lvad_signal = calc_norm(lvad_signal,'acc');
    lead_signal = calc_norm(lead_signal,'acc');
    lvad_signal = calc_moving(lvad_signal,'acc');
    lead_signal = calc_moving(lead_signal,'acc');
   
    % Sync point found manually
    lvad_signal_sync_point = datetime('7-Dec-2018 17:24:12.865','InputFormat','dd-MMM-yyyy HH:mm:ss.SSS','Format','dd-MMM-uuuu HH:mm:ss.SSS');
    lead_signal_sync_point = datetime('7-Dec-2018 17:29:49.540','InputFormat','dd-MMM-yyyy HH:mm:ss.SSS','Format','dd-MMM-uuuu HH:mm:ss.SSS');
    ts_data_diff = lead_signal_sync_point - lvad_signal_sync_point;
    lead_signal.timestamp = lead_signal.timestamp - ts_data_diff;
    
    % Verify visually that syncing worked (at picked manually event/window, 
    % that not containing the sync points)
    lvad_zoom  = lvad_signal.timestamp > '07-Dec-2018 17:00:30.011' & lvad_signal.timestamp < '07-Dec-2018 17:05:10.523';
    lead_zoom  = lead_signal.timestamp > '07-Dec-2018 17:00:30.011' & lead_signal.timestamp < '07-Dec-2018 17:05:10.523';
    close all
    figure('Name','3 component vector length for LVAD accelerometer')
    h1 = plot(lvad_signal.timestamp(lvad_zoom),lvad_signal.accNorm(lvad_zoom));
    ylim([0.7 1.3]);
    figure('Name','3 component vector length for driveline accelerometer')
    h2 = plot(lead_signal.timestamp(lead_zoom),lead_signal.accNorm(lead_zoom));
    ylim([0.7 1.3]);
    
    % Verify visually also with movrms
    figure('Name','Moving RMS for LVAD accelerometer')
    plot(lvad_signal.timestamp,lvad_signal.movRMS)
    figure('Name','Moving RMS for driveline accelerometer')
    plot(lead_signal.timestamp,lead_signal.movRMS)
    