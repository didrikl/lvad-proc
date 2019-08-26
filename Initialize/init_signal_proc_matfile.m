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
    % See also load, save, save_table
    
    filepath = fullfile(read_path,filename);
    display_filename(filename,read_path,'\nReading signal with loading .mat file');
    
    if not(exist(filepath,'file'))
        fprintf('\nFile does not exist.')
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
    
     fields = fieldnames(signal);
     if numel(fields)~=1
         warning(['File did not contain one unique field. A struct ',...
             'containing the data is returned instead.']);        
     elseif numel(fields)==1
        signal = signal.(fields{1});
     end
       
%     if not(isfield(signal,'signal'))
%         warning(['File did not contain signal variable. A struct ',...
%             'containing the data is returned instead.'])
%     else
%         %assignin('caller','signal',data.signal);
%         signal = signal.signal;
%     end
 
end