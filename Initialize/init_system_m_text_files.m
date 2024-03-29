function B = init_system_m_text_files(fileNames,path,varMapFile)
    % Initialize System M data
    %
    % Usage:
    %     T = init_system_m_text_files(fileNames,path,varMap)
    % varMap is used to set variable continuity, which is used when doing
    % resampling by the retime function.
        
    % TODO: Make one generic function to initialize blocks, that can be used for
    % init_labchart_mat_files too
    
    if nargin==1, path = ''; end
    eval(varMapFile);
    
    timeFmt = 'dd-MMM-uuuu HH:mm:ss.SSSS';
 
    welcome('Initialize Spectrum Medical Ultrasonic data')

    [filePaths,fileNames,path] = check_file_name_and_path_input(fileNames,path);

    if numel(fileNames)==0
        warning('No ultrasonic data initialized')
        return; 
    end
    
    B = cell(numel(filePaths),1);
    for i=1:numel(filePaths)
        
        display_filename(filePaths{i});
        
        B{i} = init_system_m_text_files_read_2sensors(filePaths{i});
        
        B{i}.time = datetime(B{i}.('DateandTime'),...
            'InputFormat',"yyyy/MM/dd HH:mm:ss",...
            'Format',timeFmt,...
            'TimeZone','Europe/Oslo');
        B{i}(:,'DateandTime') = [];
        
        % Make timetable, and add properties metadata
        B{i} = table2timetable(B{i},'RowTimes','time');
        % TODO: Use this function instead:
        %signal = make_signal_timetable(signal, include_time_duration)
        % TODO: The above function must be modified to support raw time format
        % as function argument input.
        
        % TODO: Make OO, for which much of the same code of is used for PowerLab
        % as well
        [B{i},inFile_inds] = map_varnames(B{i}, varMap(:,1), varMap(:,2));
        varMap = varMap(inFile_inds,:);
        
        % Storing info about sensors (metadata for each variable)
        B{i} = addprop(B{i},'SensorSampleRate','variable');
        channels_in_use = ismember(B{i}.Properties.VariableNames,varMap(:,2));
        B{i}.Properties.CustomProperties.SensorSampleRate(channels_in_use) = varMap{:,3};
        
        % All variables shall be treated as continous and measured in data fusion
        B{i} = addprop(B{i},'Measured','variable');
        B{i}.Properties.CustomProperties.Measured(:) = true;
        B{i}.Properties.UserData = make_init_userdata(fileNames{i},path);
        
        B{i}.Properties.VariableContinuity = varMap(:,5);
        
        B{i}.Properties.DimensionNames{1} = 'time'; 
        B{i}.Properties.DimensionNames{2} = 'variables'; 
        
        % Cast all columns, other than time columns, to specific format
        B{i} = convert_columns(B{i},varMap(:,4));
        
        B{i}.Properties.VariableNames = varMap(:,2);
        B{i}.Properties.VariableUnits = varMap(:,6);
        
    end
    
function T_block = init_system_m_text_files_read_2sensors(filePath)
   %IMPORTFILE Import data from a text file
    %  signal = init_system_m_text_files_read_2sensors(FILE) reads data from 
    %  text file FILE for the default selection.  Returns the data as a table.
    %
    %  signal = init_system_m_text_files_read_2sensors(FILE) reads data for the specified
    %  row interval(s) of text file FILENAME. 
    %
    %  See also READTABLE.
    %
    % Auto-generated by MATLAB on 20-Jan-2020 17:17:17 %% Input handling

    % Setup the Import Options and import the data
    opts = delimitedTextImportOptions("NumVariables", 115);
    
    % Specify range and delimiter
    opts.DataLines = [3, Inf];
    opts.Delimiter = "\t";
    
    % Specify column names and types
    opts.VariableNames = ["DateandTime", "Var2", "Var3", "Var4", "Var5", "Var6", "Var7", "ArtflowLmin", "VenflowLmin", "ArterialflowLmin", "Var11", "Var12", "Var13", "Var14", "EmboliVolume1uLsec", "EmboliTotalCount1", "Var17", "EmboliVolume2uLsec", "EmboliTotalCount2", "Var20", "EmboliVolume3uLsec", "EmboliTotalCount3", "Var23", "Var24", "Var25", "Var26", "Var27", "Var28", "Var29", "Var30", "Var31", "Var32", "Var33", "Var34", "Var35", "Var36", "Var37", "Var38", "Var39", "Var40", "Var41", "Var42", "Var43", "Var44", "Var45", "Var46", "Var47", "Var48", "Var49", "Var50", "Var51", "Var52", "Var53", "Var54", "Var55", "Var56", "Var57", "Var58", "Var59", "Var60", "Var61", "Var62", "Var63", "Var64", "Var65", "Var66", "Var67", "Var68", "Var69", "Var70", "Var71", "Var72", "Var73", "Var74", "Var75", "Var76", "Var77", "Var78", "Var79", "Var80", "Var81", "Var82", "Var83", "Var84", "Var85", "Var86", "Var87", "Var88", "Var89", "Var90", "Var91", "Var92", "Var93", "Var94", "Var95", "Var96", "Var97", "Var98", "Var99", "Var100", "Var101", "Var102", "Var103", "Var104", "Var105", "Var106", "Var107", "Var108", "Var109", "Var110", "Var111", "Var112", "Var113", "Var114", "Var115"];
    opts.SelectedVariableNames = ["DateandTime", "ArtflowLmin", "VenflowLmin", "ArterialflowLmin", "EmboliVolume1uLsec", "EmboliTotalCount1", "EmboliVolume2uLsec", "EmboliTotalCount2", "EmboliVolume3uLsec", "EmboliTotalCount3"];
    opts.VariableTypes = ["char", "char", "char", "char", "char", "char", "char", "char", "char", "double", "char", "char", "char", "char", "double", "double", "char", "double", "double", "char", "double", "double", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char"];
    
    % Specify file level properties
    opts.ExtraColumnsRule = "ignore";
    opts.EmptyLineRule = "read";
    
    % Specify variable properties
    opts = setvaropts(opts, ["DateandTime", "Var2", "Var3", "Var4", "Var5", "Var6", "Var7", "ArtflowLmin", "VenflowLmin", "Var11", "Var12", "Var13", "Var14", "Var17", "Var20", "Var23", "Var24", "Var25", "Var26", "Var27", "Var28", "Var29", "Var30", "Var31", "Var32", "Var33", "Var34", "Var35", "Var36", "Var37", "Var38", "Var39", "Var40", "Var41", "Var42", "Var43", "Var44", "Var45", "Var46", "Var47", "Var48", "Var49", "Var50", "Var51", "Var52", "Var53", "Var54", "Var55", "Var56", "Var57", "Var58", "Var59", "Var60", "Var61", "Var62", "Var63", "Var64", "Var65", "Var66", "Var67", "Var68", "Var69", "Var70", "Var71", "Var72", "Var73", "Var74", "Var75", "Var76", "Var77", "Var78", "Var79", "Var80", "Var81", "Var82", "Var83", "Var84", "Var85", "Var86", "Var87", "Var88", "Var89", "Var90", "Var91", "Var92", "Var93", "Var94", "Var95", "Var96", "Var97", "Var98", "Var99", "Var100", "Var101", "Var102", "Var103", "Var104", "Var105", "Var106", "Var107", "Var108", "Var109", "Var110", "Var111", "Var112", "Var113", "Var114", "Var115"], "WhitespaceRule", "preserve");
    opts = setvaropts(opts, ["DateandTime", "Var2", "Var3", "Var4", "Var5", "Var6", "Var7", "ArtflowLmin", "VenflowLmin", "Var11", "Var12", "Var13", "Var14", "Var17", "Var20", "Var23", "Var24", "Var25", "Var26", "Var27", "Var28", "Var29", "Var30", "Var31", "Var32", "Var33", "Var34", "Var35", "Var36", "Var37", "Var38", "Var39", "Var40", "Var41", "Var42", "Var43", "Var44", "Var45", "Var46", "Var47", "Var48", "Var49", "Var50", "Var51", "Var52", "Var53", "Var54", "Var55", "Var56", "Var57", "Var58", "Var59", "Var60", "Var61", "Var62", "Var63", "Var64", "Var65", "Var66", "Var67", "Var68", "Var69", "Var70", "Var71", "Var72", "Var73", "Var74", "Var75", "Var76", "Var77", "Var78", "Var79", "Var80", "Var81", "Var82", "Var83", "Var84", "Var85", "Var86", "Var87", "Var88", "Var89", "Var90", "Var91", "Var92", "Var93", "Var94", "Var95", "Var96", "Var97", "Var98", "Var99", "Var100", "Var101", "Var102", "Var103", "Var104", "Var105", "Var106", "Var107", "Var108", "Var109", "Var110", "Var111", "Var112", "Var113", "Var114", "Var115"], "EmptyFieldRule", "auto");
    opts = setvaropts(opts, ["EmboliVolume2uLsec", "EmboliTotalCount2"], "TrimNonNumeric", true);
    opts = setvaropts(opts, ["EmboliVolume2uLsec", "EmboliTotalCount2"], "ThousandsSeparator", ",");
    
    % Import the data
    T_block = readtable(filePath, opts);
    
    % Store various/unstructured info (start with initializing standard info)
    T_block.Properties.UserData.header = cellstr(opts.SelectedVariableNames);
    T_block.Properties.VariableDescriptions = opts.SelectedVariableNames;