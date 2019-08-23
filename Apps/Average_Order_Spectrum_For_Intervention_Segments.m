close all

qc_event_type = {'Thrombus injection'};
resolution = 300;

qc_feat_inds = find(contains(string(features.precursor),qc_event_type));
n_qc_feats = numel(qc_feat_inds);
for i=1:n_qc_feats
    
    feat_ind = qc_feat_inds(i);
    qc_event_feat = features(feat_ind,:);
    title_text = sprintf('%s: Intervention segment %d of %d',qc_event_type{1},i,n_qc_feats);
    fprintf(['\n',title_text])
    
    figure(...
        'Position',[208.2000 354.6000 1.0958e+03 695.4000],...
        'Name','Average order spectra comparisons');
    ax = axes;
    hold on
    make_average_order_spectrum(lvad_signal(features.leadWin_timerange{feat_ind},:),'LineStyle',':','LineWidth',2,'Parent',ax);
    make_average_order_spectrum(lead_signal(features.leadWin_timerange{feat_ind},:),'LineStyle',':','LineWidth',2,'Parent',ax);
    ax.ColorOrderIndex = 1;
    make_average_order_spectrum(lvad_signal(features.trailWin_timerange{feat_ind},:),'LineWidth',2,'Parent',ax);
    make_average_order_spectrum(lead_signal(features.trailWin_timerange{feat_ind},:),'LineWidth',2,'Parent',ax);
    
    legend({'LVAD, leading window','Driveline, leading window','LVAD, trailing window','Driveline, trailing window'},...
        'FontSize',12,...
        'Location','best')
    title(title_text,...
        'FontSize',16);%,...
%         'Position',[0.5,1.0215,0],...
%         'Units','normalized')
%text(-0.1,-0.1,datestr(data.timestamp(1)),'Units','normalized')

    
    %pause
    save_figure(save_path, title_text, resolution) 
    
end