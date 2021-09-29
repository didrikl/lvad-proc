resolution = 300;
orderMapVar = {'accA_xz_norm','accA_norm'};
plotVars = {
        %'P'
        'accA_xz_norm_movStd'
        'accA_norm_movStd'
        'accA_xz_norm_movRMS'
        'accA_norm_movRMS'
        %'accA_movRMS'
        %'P_LVAD'
        %'gyrA_norm_movRMS'
        %'Q'
        };
barVars = {
    'part',           brewermap(20,'Set3');
    %'intervType'      brewermap(20,'Pastel2');
    'pumpSpeed'       brewermap(20,'Paired');
    'Q_reduction'   brewermap(10,'BuPu');%'YlGnBu');
    'balloonLev'    brewermap(10,'RdPu');
    };
% Muting of non-comparable data (due to wrong setting in LabChart) in baseline
S_parts{1}.gyrA = nan(height(S_parts{1}),3);
S_parts{1}.gyrA_norm = nan(height(S_parts{1}),1);
S_parts{1}.gyrA_norm_movRMS = nan(height(S_parts{1}),1);
%Init_IV2_Seq2
    
%% Angio catheter parts

baseline_parts = [1,15,22];
intervention_parts = [8];
rpm = [2600];
baseline_parts = [15,22];
intervention_parts = [19];
rpm = [2300];
colScale = [-100,-30];

close all
clear check_table_var_input

for i=1:numel(intervention_parts)
    
    parts = sort([baseline_parts,intervention_parts(i)]);
    T = cell(numel(parts),1);
    for j=1:numel(parts)
        T{j} = S_parts{parts(j)};
        
        % overwrite with other overlapping in moving statistics calc
        T{j} = calc_moving(T{j}, ...
            {'accA_xz_norm'},{'Std','RMS'},sampleRate*1);
        
        T{j} = T{j}(get_steady_state_rows(T{j}) & T{j}.pumpSpeed==rpm(i),:);
    end
    
    T = merge_table_blocks(T);
    T.Properties.SampleRate = sampleRate;
    T.accA_x = T.accA(:,1);
    T.accA_y = T.accA(:,2);
    T.accA_z = T.accA(:,3);
    
    % Merging, so they will be plotted in same panel
    T = mergevars(T,{'p_eff','p_aff'},'NewVariableName','P');
    T = mergevars(T,{'affQ','effQ','Q_LVAD'},'NewVariableName','Q');
    %T = mergevars(T,{'accA_x','accA_y','accA_y'},'NewVariableName','accA');

    for j=1:numel(orderMapVar)
        h_fig = plot_ordermap_with_vars(T,orderMapVar{j},plotVars,barVars,sampleRate,colScale);
        h_fig.Name = sprintf('IV2_Seq2: Parts=%s - Order map of %s with vars',...
            mat2str(parts),orderMapVar{j});
        save_figure(h_fig, [proc_basePath,'\Figures'], h_fig.Name, resolution)
    end
end

%% PCI catherter parts

baseline = 15;
baseline_rpm = [2600];
parts = 16;
for i=1:numel(parts)
    make_rpm_order_plots(...
        proc_basePath,S_parts,parts(i),baseline,sampleRate,baseline_rpm(i));
end

% Clamping parts
baseline = [1];
for j=1:numel(baseline)
    baseline_rpm = [2600,2600,2000,2300,2900,3200];
    parts = 2:6;
    for i=1:numel(parts)
        make_rpm_order_plots(...
            proc_basePath,S_parts,parts(i),baseline(j),sampleRate,baseline_rpm(i));
    end
end
