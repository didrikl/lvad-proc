function set_Q_scatter_style(h)
     
    grid(h,'on')
    
    h(1).GridLineStyle =':';
    h(2).GridLineStyle =':';
    h(3).GridLineStyle =':';
    h(4).GridLineStyle =':';
    
    h(1).GridAlpha = 0.4;
    h(2).GridAlpha = 0.4;
    h(3).GridAlpha = 0.4;
    h(4).GridAlpha = 0.4;
    
    h(1).FontSize = 11;
    h(2).FontSize = 11;
    h(3).FontSize = 11;
    h(4).FontSize = 11;
    
    h(1).XTickLabel = {};
    h(2).XTickLabel = {};
    h(2).YTickLabel = {};
    h(4).YTickLabel = {};
    h(1).YTickLabel{end} = '';
    h(3).YTickLabel{end} = '';
    
    h(1).XAxis.TickLength = [0,0]; 
    h(2).XAxis.TickLength = [0,0]; 
    h(3).YAxis.TickLength = [0,0]; 
    h(4).YAxis.TickLength = [0,0]; 
    
    box(h,'on')