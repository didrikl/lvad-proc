close all

diam = {
    [0.94, 5.40, 6.20]
    [1.67, 7.30, 8.44]
    [1.30, 5.58, 6.20]
    %   0, 2, 2.5, 3.125, 3.75
    [2.33, 9, 10.3, 11.65, 12.5] 
    [0.81, 1.87, 2.13]
    [0.81, 2.14, 2.42]
    [0.81, 3.69, 4.73]
    };

heights = {
     [8, 8, 8]
     [30, 30, 30]
     [39, 39, 39]
     [2.33, 6, 7, 8.5, 10.65]
     [28, 28, 28]
     [8, 8, 8]
     [12, 12, 12]
     };
 
LVAD_diam = 12.70;
 
volumes = cellfun(@(w,h) (pi*(0.5*w).^2).*h, diam, heights, 'UniformOutput',false);

% For RHC: Take average of spherical and cylindrical volume calculation
sphericVol_RHC = (4/3)*pi*((diam{4}./2).^3);
volumes{4} = mean([sphericVol_RHC;volumes{4}]);

for i=1:4
    scatter(diam{i},volumes{i},...
        'Filled',...
        ...'LineWidth', 2,...
        'Marker','o',...
        'MarkerEdgeAlpha',0.6, ...
        'MarkerFaceAlpha',0.75 ...
    )
    hold on   
end

for i=5:7
    scatter(diam{i},volumes{i},...
        'Marker','x',...
        'LineWidth', 2,...
        'MarkerEdgeAlpha',0.7 ...
    );
    hold on   
end

leg_text = {
    '6mm x 8mm PCI'
    '8mm x 30mm PCI'
    '6mm x 39mm PCI'
    '11mm RHC'
    '2mm x 28mm PCI'
    '2.5mm x 8mm PCI'
    '4.5mm x 12mm PCI'
    };
legend(leg_text,...
    'Location','northwest')

ylabel('Approx. Ballon Volume  (\muL)')
xlabel('Ballon Diameter (mm)')
title('Catheters Balloon Sizes Used in Pilot Experiment');

h_ax = gca;
h_ax.Position = [0.1300 0.1300 0.8150 0.8150];
h_fig = gcf;
h_fig.Position = [226.6,125,560,560];

save_figure([save_path,'\Figures'], 'Catheter size overview', 300)