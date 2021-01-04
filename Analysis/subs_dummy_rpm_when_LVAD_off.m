function T = subs_dummy_rpm_when_LVAD_off(T)
% % Just to visualize signal in RPM order plot also when pump is off. First pump
% % speed after turning of LVAD is used as dummy RPM value. It should be clear
% % from the plot that the LVAD is off.
% % TODO: Move this into plot function. It is misleading to do this as
% % preprocessing. It is only for RPM order plotting.
% turnOn_ind = find(diff(S.pumpSpeed==0)==-1)+1;
% turnOff_ind = find(diff(S.pumpSpeed==0)==1)+1;
% 
% % If notes starts with LVAD off, then include also this in turnOff_ind
% firstisOff_ind = find(S.pumpSpeed==0,1,'first');
% if not(ismember(firstisOff_ind,turnOff_ind))
%     turnOff_ind = [firstisOff_ind;turnOff_ind];
% end% % Just to visualize signal in RPM order plot also when pump is off. First pump
% % speed after turning of LVAD is used as dummy RPM value. It should be clear
% % from the plot that the LVAD is off.
% % TODO: Move this into plot function. It is misleading to do this as
% % preprocessing. It is only for RPM order plotting.
% turnOn_ind = find(diff(S.pumpSpeed==0)==-1)+1;
% turnOff_ind = find(diff(S.pumpSpeed==0)==1)+1;
% 
% % If notes starts with LVAD off, then include also this in turnOff_ind
% firstisOff_ind = find(S.pumpSpeed==0,1,'first');
% if not(ismember(firstisOff_ind,turnOff_ind))
%     turnOff_ind = [firstisOff_ind;turnOff_ind];
% end

% 
% % Insert dummy RPM values for when LVAD is off in order to create spectrogram
% % using RPM order plot. (Dummy value is the first LVAD-on-RPM value.)
% for i=1:numel(turnOn_ind)
%     S.pumpSpeed(turnOff_ind(i):turnOff_ind-1) = S.pumpSpeed(turnOn_ind(i));
% end
% 
% % Handle special case if notes ends with LVAD off 
% % (Dummy value is the last LVAD-on-RPM value.)
% if numel(turnOff_ind)==numel(turnOn_ind)+1
%     S.pumpSpeed(turnOff_ind(end):end) = turnOff_ind(end)-1;
% end
%    % 
