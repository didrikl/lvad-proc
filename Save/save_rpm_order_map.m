function save_rpm_order_map(map, proc_path, seq)

welcome('Save RPM order map','function')

save_filePath = fullfile(proc_path, [seq,'_RPM order map']);

save(save_filePath, 'map')
display_filename([seq,'_RPM order map.mat'], proc_path, '\nSaved to:', '\t');
