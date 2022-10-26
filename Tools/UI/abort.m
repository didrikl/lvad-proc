function abort(confirm, open_dlgbox)
  
    % TODO: Implement input parsing with input arg
    %   'confirm','confirm_msg': ask for confirmation
    %   'errdlg','dlg_msg': displayes a message box that execution is aborted
    
    confirm_msg = 'Do you want to abort program execution?';
    dlg_msg = 'Execution aborted';
    ans_default = 'Yes';
    
    if nargin<1
        confirm = false;
    end
    if nargin<2
        open_dlgbox = false;
    end
    
%     s = dbstack('-completenames');       
%     if print_stack
%         stacksize = numel(s);
%         for i=stacksize:-1:2
%             if i==stacksize
%                 fprintf(['\nExecution code stack: \n\t',s(i).name]);
%             else
%                 fprintf(['\n\t',repmat(' ',1,stacksize-i),'','--> ',s(i).name])
%             end
%         end
%         fprintf('\n\n')
%     end
        
    if confirm
        answer = questdlg(confirm_msg,...
            'Abort confirmation', ...
            'Yes','No',...
            ans_default);
        if strcmp(answer,'No')
            return
        end
    end
    
    if open_dlgbox
        errordlg(dlg_msg,'Execution aborted')
    end

    close2 all
    error(dlg_msg)
    