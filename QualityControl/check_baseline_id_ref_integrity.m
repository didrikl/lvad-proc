function check_baseline_id_ref_integrity(idSpecs, Notes)
		for i=1:height(idSpecs)
			idNote_inds = Notes.analysis_id==idSpecs.analysis_id(i);
			id = idSpecs.analysis_id(i);
			if numel(unique(Notes.bl_id(idNote_inds)))>1
				rows = mat2str(Notes.noteRow(idNote_inds));
				warning(sprintf(['There are disparate baseline IDs',...
					'\n\tAnalysis ID: %s\n\tRows: %s'],string(id),rows));			
			end
			
		end
end