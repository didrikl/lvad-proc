function notify_about_notes_issues_found(isOK, Notes)
	if any(not(isOK))
		opts = struct('WindowStyle','non-modal','Interpreter','none');
		msg = sprintf('ID parameter issues detected in Notes.\n\n%s\n',...
			display_filename(Notes.Properties.UserData.FilePath));
		warndlg(msg,'Warning, Notes',opts)
	end
