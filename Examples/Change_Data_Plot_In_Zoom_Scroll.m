% Change data plot in zoom scroll
h_zoom_data= findobj(h_zoom,'Tag','scrollDataLine');
h_zoom_data.YData = iv_signal.(sub2_yy_varname);
yyaxis right
h_zoom.YAxis.Limits = h_sub(2).YLim;
h_zoom_plt = findall(h_zoom,'Tag','scrollDataLine');
h_zoom_plt.Color = [.87 .75 .69];