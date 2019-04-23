function [h_shd, h_txt] = Make_Shade_Lines(shade, ax)
    % Make shading down at the x-axis, with text
    % Take the struct shade as input, with the following fields
    %     shade.height = 1.5;
    %     shade.interv = {10, 30, 'Some text'; 60, 80, 'Another text'}
    %     shade.alpha = 0.25
    %     Optional:
    %        shade.fontsize
    %        shade.fontweight
    %        shade.font
    
    
    if nargin<2, ax = gca; end
    ylim = get(ax,'ylim');
    shade_ylim = [ylim(1)-0.1*shade.height,ylim(1)+shade.height];
    xlim = get(ax,'xlim');
    J=0;
    n_shades = size(shade.interv,1);
    
    if isfield(shade,'fontsize')
        fontsize = shade.fontsize;
    else
        fontsize = 8.5;
    end
    if isfield(shade,'fontweight')
        fontweight = shade.fontweight;
    else
        fontweight = 'bold';
    end
    if isfield(shade,'font')
        font = shade.font;
    else
        font = 'Calibri Light';
    end
    
    h_shd = nan(n_shades,1);
    h_txt = nan(n_shades,1);
    for j=1:n_shades
        shade_xmin = max(shade.interv{j,1},xlim(1));
        shade_xmax = min(shade.interv{j,2},xlim(2));
        shade_txt = shade.interv{j,3};
        if shade_xmax<=shade_xmin 
            continue; 
        else
            J = J+1;
        end
        h_shd(J) = patch([repmat( shade_xmin,1,2) repmat( shade_xmax,1,2)], ...
        [shade_ylim fliplr(shade_ylim)], [0 0 0 0], shade.color);
        set(h_shd(J),'FaceAlpha',shade.alpha,'EdgeColor','None'); 

        x = get(h_shd(J),'XData');
        y = get(h_shd(J),'YData');
        txt_xpos = x(1)+0.5*abs(x(1)-x(3));
        txt_ypos = y(1)+0.5*abs(y(1)-y(3));
        
        h_txt(j) = text(...
            'String', shade_txt, ...
            'HorizontalAlignment', 'center', ...
            'VerticalAlignment', 'middle', ...
            'Position', [txt_xpos, txt_ypos, 0],...
            'FontSize', fontsize,...
            'FontWeight', fontweight,...
            'FontName', font...
            );

    end

end

