function signal = init_signal_proc_matfile(fileName, read_path, varargin)
    % INIT_SIGNAL_FILE
    %   Read already initlized or processed signal from disc, stored as binary 
    %   .mat file, using Matlab's load function. User is ask for location the
    %   file if given fileName in given path does not exist.
    %
    % Usage:
    %   signal = init_signal_file(fileName, read_path, varargin), where
    %   varargin optional inputs in the function load
    %
    % See also load, save, save_table
    
    filePath = fullfile(read_path,fileName);
    display_filename(fileName,read_path,'\nReading signal with loading .mat file');
    
    if not(exist(filePath,'file'))
        fprintf('\nFile does not exist.')
        fprintf('\nSelect file... ')
        [fileName,read_path] = uigetfile('.mat','Select file to load',filePath);
        if fileName
            filePath = fullfile(read_path,fileName);           
        else
            fprintf('\n')
            warning('\n\tNo file selected.\n')
            signal = [];
            return
        end
    end
    
    % TODO: Test with load/saving structs/parts of file
    signal = load(filePath, varargin{:});
    
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