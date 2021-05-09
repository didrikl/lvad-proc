seq6_ids = unique(S_analysis.IV2_Seq6.analysis_id);
seq7_ids = unique(S_analysis.IV2_Seq7.analysis_id);
seq9_ids = unique(S_analysis.IV2_Seq9.analysis_id);
seq10_ids = unique(S_analysis.IV2_Seq10.analysis_id);
seq11_ids = unique(S_analysis.IV2_Seq11.analysis_id);
seq12_ids = unique(S_analysis.IV2_Seq12.analysis_id);
seq13_ids = unique(S_analysis.IV2_Seq13.analysis_id);
seq14_ids = unique(S_analysis.IV2_Seq14.analysis_id);
seq18_ids = unique(S_analysis.IV2_Seq18.analysis_id);
seq19_ids = unique(S_analysis.IV2_Seq19.analysis_id);

ids = unique([seq6_ids;seq7_ids;seq9_ids;seq10_ids;seq11_ids;seq12_ids;...
    seq13_ids;seq14_ids;seq18_ids;seq19_ids]);

id_list = {
    '01.0'	'31.1 #1'
    '01.0'	'31.2'
    '01.0'	'31.3'
    '01.0'	'31.1 #2'
    '02.0'	'32.1 #1'
    '02.0'	'32.2'
    '02.0'	'32.3'
    '02.0'	'32.1 #2'
    '03.0'	'33.1 #1'
    '03.0'	'33.2'
    '03.0'	'33.3'
    '03.0'	'33.1 #2'
    '04.0'	'34.1 #1'
    '04.0'	'34.2'
    '04.0'	'34.3'
    '04.0'	'34.1 #2'
    '01.0'	'41.1 #1'
    '01.0'	'41.2'
    '01.0'	'41.3'
    '01.0'	'41.4'
    '01.0'	'41.5'
    '01.0'	'41.1 #2'
    '02.0'	'42.1 #1'
    '02.0'	'42.2'
    '02.0'	'42.3'
    '02.0'	'42.4'
    '02.0'	'42.5'
    '02.0'	'42.1 #2'
    '03.0'	'43.1 #1'
    '03.0'	'43.2'
    '03.0'	'43.3'
    '03.0'	'43.4'
    '03.0'	'43.5'
    '03.0'	'43.1 #2'
    '04.0'	'44.1 #1'
    '04.0'	'44.2'
    '04.0'	'44.3'
    '04.0'	'44.4'
    '04.0'	'44.5'|
    '04.0'	'44.1 #2'
    }

%%

% Read sequence notes made with Excel file template
notes_filePath = fullfile(experiment_subdir,notes_subdir,notes_fileName);
Notes = init_notes_xlsfile_ver4(notes_filePath,'',notes_varMapFile);
ID = Notes(:,{'pumpSpeed','balloonLevel','catheter','Q_RedPst','analysis_id','bl_id'});
ID = standardizeMissing(ID,'-');
ID = ID(not(ismissing(ID.analysis_id)),:);


%%

ids = ID.analysis_id;
bl_ids = ID.bl_id;
seqs = fieldnames(S_analysis);

all_vars = {...
    'Q_LVAD','P_LVAD','affP','effP',...
    'Q','accA_norm','accA_x','accA_y','accA_z',...
    'accA_norm_nf','accA_x_nf','accA_y_nf','accA_z_nf'
    };
std_vars = {...
    'accA_norm','accA_x','accA_y','accA_z',...
    'accA_norm_nf','accA_x_nf','accA_y_nf','accA_z_nf'
    };

stats = make_stats(ids,seqs,S_analysis,all_vars,std_vars);
stats_bl = make_stats(bl_ids,seqs,S_analysis,all_vars,std_vars);

%stats_dev = stats(:,5:end) - stats_bl(:,5:end)
%stats_relDev = stats_dev ./ stats_bl(:,5:end)

interSeqStats = rowfun(@std,stats,...
    'GroupingVariable','IntervID');%,'OutputVariableName','StdDev')


%%

jj=1;
stats.Seg = cellstr(repmat("",height(stats),1));
for i=1:numel(ids)   
    for j=1:numel(seqs)
        
        %                 S = S_analysis.(seqs{j});
        %                 inds = S.analysis_id==ids(i);
        stats.Seg{jj} = seqs{j};
        stats.IntervID(jj) = string(ids(i));
        jj=jj+1;
        
    end
end

jj=1;
stats.Seg = cellstr(repmat("",height(stats),1));
for i=1:numel(ids)   
    for j=1:numel(seqs)
        
        %                 S = S_analysis.(seqs{j});
        %                 inds = S.analysis_id==ids(i);
        stats_bl.Seg{jj} = seqs{j};
        stats_bl.IntervID(jj) = string(ids(i));
        jj=jj+1;
        
    end
end

    
    
