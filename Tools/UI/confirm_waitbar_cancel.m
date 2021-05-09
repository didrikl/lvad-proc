function cancel = confirm_waitbar_cancel(cancel,waitbar_string_tag)
    if cancel
        resp = ask_list_ui({'Yes','No'},'Sure you want to cancel?',2);
        if resp==1
            fprintf('\nRemaining files are dropped by user\n')
            multiWaitbar(waitbar_string_tag,'Color',[254,178,76]/256);
            cancel = true;
        elseif resp==2
            multiWaitbar(waitbar_string_tag,'ResetCancel');
            cancel = false;
        end
    end