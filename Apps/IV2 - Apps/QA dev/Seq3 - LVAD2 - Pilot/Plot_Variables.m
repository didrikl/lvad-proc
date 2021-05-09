%% Time analysis
% Acceleration plot of part 8

figure(...
    'units','normalized',...
    'outerposition',[0 0 1 1],...
    'name','Accelerations of part 8')

% subplot(2,1,1)
yyaxis left
%plot(S_parts{8}.time, S_parts{8}.accA_norm_movRMS)
plot(S_parts{8}.time, S_parts{8}.accA_norm)
yyaxis right
plot(S_parts{8}.time, S_parts{8}.accA_norm_movStd)