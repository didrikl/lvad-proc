function [T1,T2] = handle_duplicate_varnames(T1,T2)
    
    [dupes,inds1,inds2] = intersect(T1.Properties.VariableNames,T2.Properties.VariableNames);
    if not(isempty(dupes))
        
        for i=1:numel(dupes)
            msg = sprintf('Duplicate varible names found.\nHow to handle this?');
            opts = {
                'Rename'   
                'Keep only from left table'
                'Keep only from right table'
                'Keep none'
                'Abort'
                };
            resp = ask_list_ui(opts,msg,1);
            
            if resp==1
                title = 'Input for new variable name';
                prompt = {
                    'Enter new variable name in left table';
                    'Enter new variable name in right table'
                    };
                dims = [1,30];
                defaults = {dupes{i},''};
                
                answer = inputdlg(prompt,title,dims,defaults);
                T1.Properties.VariableNames{inds1(i)} = answer{1};
                T2.Properties.VariableNames{inds2(i)} = answer{2};
            
            elseif resp==2
                T2(:,inds2(1))=[];
                
            elseif resp==3
                T1(:,inds1(1))=[];
                
            elseif resp==4
                T1(:,inds1(1))=[];
                T2(:,inds2(1))=[];
                
            elseif resp==5
                abort
                
            end
            
        end
        
    end
                