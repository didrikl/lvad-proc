path = 'C:\Data\Domus Medica\Ai Van\Artikkel 1\Figurer produsert 16.02.2019 - 2. innsending';
file_path = fullfile(path,'Fig3b_LDF-d.fig');
h1 = openfig(file_path,'reuse'); % open figure
ax1 = gca; % get handle to axes of figure

%anelh = handles.uipanel1;   %presuming you already created it
figure
panelh = subplot(1,2,1)
%panelh = uipanel;
hc = findall(h1, '-depth', 1);
hct = get(hc,'type')
fighand = strcmp(hct, 'figure');
uihand = strncmp(hct, 'ui', 2);
annothand = strncmp(hct, 'annotationpane',2);
h_leg =  strcmp(hct, 'legend');
hc(fighand | uihand | annothand | h_leg) = [];  %get rid of those
for ch = hc
  ch
    try
        set(ch,'Parent', panelh);
    catch err
        err
    end
end




























% % h2 = openfig('test2.fig','reuse');
% % ax2 = gca;
% % test1.fig and test2.fig are the names of the figure files which you would % like to copy into multiple subplots
% 
% h3 = figure; %create new figure
% s1 = subplot(4,2,[1 3 5 7]); %create and get handle to the subplot axes
% %fig1 = get(ax1,'children'); %get handle to all the children in the figure
% 
% copyobj(fig1,h1); %copy children to new parent axes i.e. the subplot axes
%copyobj(fig2,s2);