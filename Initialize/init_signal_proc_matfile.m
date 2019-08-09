function signal = init_signal_proc_matfile(filename, read_path, varargin)
    % INIT_SIGNAL_FILE
    %   Read already initlized or processed signal from disc, stored as binary 
    %   .mat file, using Matlab's load function. User is ask for location the
    %   file if given filename in given path does not exist.
    %
    % Usage:
    %   signal = init_signal_file(filename, read_path, varargin), where
    %   varargin optional inputs in the function load
    %
    % See also load, uigetfile, save_table
    
    filepath = fullfile(read_path,filename);
    
    if not(exist(filepath,'file'))
        warning('File does not exist.')
        fprintf('\nSelect file... ')
        [filename,read_path] = uigetfile('.mat','Select file to load',filepath);
        if filename
            filepath = fullfile(read_path,filename);           
        else
            fprintf('\n')
            warning('\n\tNo file selected.\n')
            signal = [];
            return
        end
    end
    
    % TODO: Test with load/saving structs/parts of file
    signal = load(filepath, varargin{:});
    fprintf('\nFile loaded:\n');
    fprintf(['\tName: ',strrep(filename,'\','\\'),'\n'])
    fprintf(['\tPath: ',strrep(read_path,'\','\\'),'\n'])
 
    if isfield('signal',signal)
        warning(['File did not contain signal variable. A struct ',...
            'containing the data is returned instead.'])
    else
        %assignin('caller','signal',data.signal);
        signal = signal.signal;
    end
 
end