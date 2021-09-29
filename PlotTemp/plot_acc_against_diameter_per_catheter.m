function h_figs = plot_acc_against_diameter_per_catheter(F,G,vars,type)

catheters = unique(F.catheter);
catheters = catheters(not(catheters=='-'));
markers = {'o','diamond','square','pentagram'};
speeds = {'2200','2500','2800','3100'};

if strcmpi(type,'relative')
    F{F.categoryLabel=='Nominal',vars(:,1)} = 0;
    G{G.categoryLabel=='Nominal',vars(:,1)} = 0;
end
    
for v=1:size(vars,1)
    var = vars{v,1};
    title_str = ['Plot 4: ',type,' change in acc against diameter at all speeds, per catheter'];
    h_figs(v) = figure('Name',title_str,'Position',[200,200,1200,600]);
    
    h = tiledlayout(1,4,'Padding','compact','TileSpacing','compact');
    for i=1:numel(catheters)
        h_ax(i) = nexttile;
        F_c_inds = (F.categoryLabel=='Nominal' & F.interventionType=='Control') | ...
            (F.catheter==catheters(i) & F.interventionType=='Effect');
        G_c_inds = (G.categoryLabel=='Nominal' & G.interventionType=='Control') | ...
            (G.catheter==catheters(i) & G.interventionType=='Effect');
        for j=1:numel(speeds)
            F_rpm_inds = F.pumpSpeed==speeds{j};
            G_rpm_inds = G.pumpSpeed==double(string(speeds{j}));
            
            F_x = double(string(F.balloonDiam(F_c_inds & F_rpm_inds)))+mod(j,2)*0.1-0.1;
            F_y = F.(var)(F_c_inds & F_rpm_inds);
            G_y = G.(var)(G_c_inds & G_rpm_inds);
            G_x = double(string(G.balloonDiam(G_c_inds & G_rpm_inds)))+mod(j,2)*0.1-0.1;
            G_x(isnan(G_x)) = 0;
            F_x(isnan(F_x)) = 0;
            h_ax(i).ColorOrderIndex=j;
                h_s = scatter(F_x,F_y,'filled',...
                'Marker',markers{j},...
                'MarkerEdgeColor','none',...
                'MarkerFaceAlpha',0.45);
            hold on
%               h_p2(j) = plot(F_x,F_y,'Marker','.',...markers{j},...
%                 'MarkerSize',5,...
%                 'LineStyle','none');
%             h_p2(j).Color = [h_p2(j).Color,0.9];
%             h_p2(j).MarkerFaceColor = h_p2(j).Color;
%             h_p2(j).MarkerEdgeColor = h_p2(j).Color;
            
            seqs = unique(F.seq);
            %h_ax(i).ColorOrderIndex=h_ax(i).ColorOrderIndex-1;
            for k=1:numel(seqs)
                h_ax(i).ColorOrderIndex=j;
                F_x = double(string(F.balloonDiam(F_c_inds & F_rpm_inds & F.seq==seqs(k))))+j*0.10-0.20;
                F_y = F.(var)(F_c_inds & F_rpm_inds & F.seq==seqs(k));
                G_x(isnan(G_x)) = 0;
                F_x(isnan(F_x)) = 0;
                max_x_ind = F_x==max(F_x);
                min_x_ind = F_x==min(F_x);
                h_p3(j) = plot(F_x(min_x_ind|max_x_ind),F_y(min_x_ind|max_x_ind));
                h_p3(j).Color = [h_p3(j).Color,0.25];
            end
            
        end
        
        for j=1:numel(speeds)
            
            F_rpm_inds = F.pumpSpeed==speeds{j};
            G_rpm_inds = G.pumpSpeed==double(string(speeds{j}));
            
            F_x = double(string(F.balloonDiam(F_c_inds & F_rpm_inds)))+j*0.05-0.10;
            F_y = F.accA_y_nf_stdev(F_c_inds & F_rpm_inds);
            G_y = G.(var)(G_c_inds & G_rpm_inds);
            G_x = double(string(G.balloonDiam(G_c_inds & G_rpm_inds)))+j*0.05-0.10;
            G_x(isnan(G_x)) = 0;
            F_x(isnan(F_x)) = 0;
            h_p(j) = plot(G_x([1,end]),double(G_y([1,end])),...
                'Marker',markers{j},...
                'MarkerSize',8, ...7
                'LineWidth',2, ...
                'Color',h_p3(j).Color ...
                );
            h_p(j).MarkerFaceColor = h_p(j).Color;
            
            if not(isempty(vars{v,2}))
                ylim(vars{v,2})
            end
            xlim([-0.5,11.2])
            title(string(catheters(i)),'FontWeight','normal')
            h_ax(i).YGrid = 'on';
            h_ax(i).GridLineStyle = ':';
            h_ax(i).GridAlpha = 0.7;
        end
        
        ylabel(h,var,'Interpreter','none')
        xlabel(h,'Balloon diameter (mm)')
        if i==1
            h_leg = legend(h_p,speeds+" RPM");
            h_leg.Title.String = 'Speed';
            h_leg.Location = 'northwest';
            h_leg.FontSize = 11;
            h_leg.Box = 'off';
        else
            h_ax(i).YAxis.TickLabel = [];
            h_ax(i).YAxis.TickDirection = 'both';
            h_ax(i).YAxis.TickLength = [0,0];
        end
        h_ax(i).FontSize = 11;
        
    end
end