function save_rpm_order_map(RPM_order_maps, proc_path, seq)

welcome('Save RPM order map','function')

save_filePath = fullfile(proc_path, [seq,'_RPM_order_maps']);

save(save_filePath, 'RPM_order_maps')
display_filename([seq,'_RPM_order_map.mat'], proc_path, '\nSaved to:', '\t');
