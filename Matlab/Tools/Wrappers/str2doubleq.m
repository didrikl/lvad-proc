function num_arr = str2doubleq(str_arr)
    % Function is a wrapper function that checks if a compiled version of 
    % str2double is installed, having the name str2doubleq. This function will
    % may not be called if the installed str2doubleq has calling precedence,
    % according to how Matlab checks for function files.
    % 
    % The function str2doubleq can be downloaded from Matlab Central:
    % https://se.mathworks.com/matlabcentral/fileexchange/28893-fast-string-to-double-conversion), 
    % 
    
    try       
        num_arr = Compiled.str2doubleq(str_arr);
    catch ME
        if (strcmp(ME.identifier,'MATLAB:UndefinedFunction'))
            warning(['Compiled C code function str2doubleq not available.',...
                'Try installing this to gain speedup']);
        end
        num_arr = str2double(str_arr);
    end