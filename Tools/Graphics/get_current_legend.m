function h_leg = get_current_legend(h_fig)
if nargin==0, h_fig = gcf; end

h = get(h_fig,'children');
h_leg = [];
for k = 1:length(h)
    if strcmpi(get(h(k),'Tag'),'legend')
        h_leg = h(k);
        break;
    end
end