resolution = 300;
orderMapVar = {'accA_x','accA_norm','accA_norm_movRMS'};
plotVars = {
        %'P'
        %'accA_movStd'
        'accA_norm_movRMS'
        'power_noted'
        %'gyrA_norm_movRMS'
        'Q'
        };

% Muting of non-comparable data in baseline
S_parts{1}.gyrA = nan(height(S_parts{1}),3);
S_parts{1}.gyrA_norm = nan(height(S_parts{1}),1);
S_parts{1}.gyrA_norm_movRMS = nan(height(S_parts{1}),1);

% Angio catheter parts
baseline_part = 22;
rpm = [2600];
parts = ;

BL = S_parts{baseline_part};
for i=1:numel(parts)
    BL = BL(get_steady_state_rows(BL) & BL.pumpSpeed==rpm(i),:);
    BL = calc_moving(BL, {'accA','accA_norm'}, {'Std','RMS'}, 0.1);
    P = S_parts{parts(i)};
    P = calc_moving(P, {'accA','accA_norm'}, {'Std','RMS'}, 0.1);
    P = merge_table_blocks({BL,P});
    P = splitvars(P,'accA','NewVariableNames',{'accA_x','accA_y','accA_z'});
    P = P(get_steady_state_rows(P) & P.pumpSpeed==rpm(i),:);
    for j=1:numel(orderMapVar)
        h_fig = plot_ordermap_with_vars(P,orderMapVar{j},plotVars);
        h_fig.Name = sprintf('Part=%d (BL=Part%d) - Order map of %s with vars',...
            parts(i),baseline_part,orderMapVar{j});
        save_figure(h_fig, [proc_basePath,'\Figures'], h_fig.Name, resolution)
    end
end


% % PCI catherter parts
% close all
% baseline = 15;
% baseline_rpm = [2600];
% parts = 16;
% for i=1:numel(parts)
%     make_rpm_order_plots(...
%         proc_basePath,S_parts,parts(i),baseline,sampleRate,baseline_rpm(i));
% end
% 
% % Clamping parts
% baseline = [1];
% for j=1:numel(baseline)
%     baseline_rpm = [2600,2600,2000,2300,2900,3200];
%     parts = 2:6;
%     for i=1:numel(parts)
%         make_rpm_order_plots(...
%             proc_basePath,S_parts,parts(i),baseline(j),sampleRate,baseline_rpm(i));
%     end
% end
