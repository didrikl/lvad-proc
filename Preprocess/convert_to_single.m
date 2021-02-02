function T = convert_to_single(T, varNames)
    % Function for IV2 model to save memory in converting selected variables 
    % to single precission 
    % TODO: Make this an IV2 object method
    
%     if nargin<2
%         varNames = { 
%             'accA_norm_movRMS'
%             'accA_1norm_movRMS'
%             'accA_xz_norm_movRMS'
%             'accA_xz_1norm_movRMS'
%             'accA_norm_movStd'
%             'accA_1norm_movStd'
%             'accA_xz_norm_movStd'
%             'accA_xz_1norm_movStd'
%             'accB_norm_movRMS'
%             'accB_1norm_movRMS'
%             'accB_xz_norm_movRMS'
%             'accB_xz_1norm_movRMS'
%             'accB_norm_movStd'
%             'accB_1norm_movStd'
%             'accB_xz_norm_movStd'
%             'accB_xz_1norm_movStd'
%             };  
%     end  
    
    % TODO: Make method for validating varName lists, with this code and code
    % for checking existence of variables in each signal part
    [returnAsCell,T] = get_cell(T);
    varNames = cellstr(convertStringsToChars(varNames));
    
    for i=1:numel(T)
        
        varNames_i = varNames(...
            ismember(varNames,T{i}.Properties.VariableNames));
      
        % Convert to single precision to save memory
        for j=1:numel(varNames_i)
            T{i}.(varNames_i{j}) = single(T{i}.(varNames_i{j}));
        end
    end 
    
    if not(returnAsCell), T = T{1}; end