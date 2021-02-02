function T = convert_to_int(T, varNames,convFnc)
    % Function for IV2 model to save memory in converting selected variables 
    % to single precission 
    % TODO: Make this an IV2 object method
     
    if nargin<3, convFnc=@int16; end
    
    % TODO: Make method for validating varName lists, with this code and code
    % for checking existence of variables in each signal part
    [returnAsCell,T] = get_cell(T);
    varNames = cellstr(convertStringsToChars(varNames));
    
    for i=1:numel(T)
        
        varNames_i = varNames(...
            ismember(varNames,T{i}.Properties.VariableNames));
      
        % Convert to int 
        % TODO: Do some checks and/or try-catch
        for j=1:numel(varNames_i)
            T{i}.(varNames_i{j}) = convFnc(T{i}.(varNames_i{j}));
        end
    end 
    
    if not(returnAsCell), T = T{1}; end