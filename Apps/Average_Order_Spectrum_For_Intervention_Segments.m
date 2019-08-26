close all

qc_event_type = {'Thrombus injection'};
resolution = 300;

qc_feat_inds = find(contains(string(features.precursor),qc_event_type));
n_qc_feats = numel(qc_feat_inds);
for i=1:n_qc_feats
    
    feat_ind = qc_feat_inds(i);
    title_text = sprintf('%s: Intervention segment %d of %d',qc_event_type{1},i,n_qc_feats);
    fprintf(['\n',title_text])
    
    % -----------------------
    
    h_fig1 = figure('Position',[210,355,1270,695],'Name','Average order spectra comparisons');
    h_ax = axes('NextPlot','add');
    
    [lvad_leadWin_spec,~] = make_average_order_spectrum(lvad_signal(features.leadWin_timerange{feat_ind},:));
    [lead_leadWin_spec,~] = make_average_order_spectrum(lead_signal(features.leadWin_timerange{feat_ind},:));
    [lvad_trailWin_spec,~] = make_average_order_spectrum(lvad_signal(features.trailWin_timerange{feat_ind},:));
    [lead_trailWin_spec,order] = make_average_order_spectrum(lead_signal(features.trailWin_timerange{feat_ind},:));
    h_ax = make_plot(h_ax,order,lvad_leadWin_spec,'Color',[0.49,0.65,0.76],'LineStyle',':');
    h_ax = make_plot(h_ax,order,lead_leadWin_spec,'Color',[0.88,0.55,0.41],'LineStyle',':');
    h_ax.ColorOrderIndex = 1;
    h_ax = make_plot(h_ax,order,lvad_trailWin_spec);
    h_ax = make_plot(h_ax,order,lead_trailWin_spec);
    
    title(title_text,'FontSize',14);
    legend({'leading win., LVAD','leading win., Driveline',...
        'trailing win., LVAD, trailing win., Driveline'},...
        'FontSize',12,...
        'Location','northeastoutside')
    text(-0.1,-0.1,datestr(features.timestamp(feat_ind)),'Units','normalized')
    
    % -----------------------
    
    h_fig2 = figure('Position',[210,355,1270,695],'Name','Average order spectra lead-trail-difference comparisons');
    h_ax = axes('NextPlot','add');
    
    lvad_diff_spec = lvad_trailWin_spec - lvad_leadWin_spec;
    lead_diff_spec = lead_trailWin_spec - lead_leadWin_spec;
    h_ax = make_plot(h_ax,order,lvad_diff_spec);
    h_ax = make_plot(h_ax,order,lead_diff_spec);
    
    legend({'LVAD','Driveline'},'FontSize',12,'Location','northeastoutside')
    title([title_text,' - Leading-trailing-window differences'],'FontSize',14);
    
    
    calc_rel_diff(lvad_trailWin_spec, lvad_leadWin_spec)
    
    save_figure(h_fig1, save_path, title_text, resolution)
    save_figure(h_fig2, save_path, title_text, resolution)
    pause
    
    
end

function calc_rel_diff(A,B)
    av_error = 100*( sqrt(sum((A-B).^2)) )/( sqrt(sum(A.^2)) );
    
function h_ax = make_plot(h_ax, order, spec, varargin)
    
    width = 2;
    plot_inds = order>0.5 & order<4.5;
    
    %plot(order(focus_inds), pow2db(spec(focus_inds)),varargin{:})
    %ylabel('Order Power Amplitude (dB)')
    
    plot(h_ax,order(plot_inds), spec(plot_inds),'LineWidth',width,varargin{:})
    ylabel('Order RMS Amplitude')
    
    xlabel('Order Number')
    grid on
    
    h_ax = gca;
end
