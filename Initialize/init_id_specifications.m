function idSpecs = init_id_specifications(workbookFile)
        
    % Set up the Import Options and import the data
    opts = spreadsheetImportOptions("NumVariables", 14);
    
	% TODO: Make object oriented
    % Specify sheet and range
    opts.DataRange = "A2:N150";
    
    % TODO: Make object oriented
    % Specify column names and types
    opts.VariableNames = ["categoryLabel", "levelLabel",  "idLabel",     "analysis_id", "analysisDuration", "interventionType", "contingency", "QRedTarget_pst", "pumpSpeed", "catheter",    "balLev",  "balDiam",  "balVol", "arealOccl_pst"];
    opts.VariableTypes = ["categorical",   "categorical", "categorical", "categorical", "single",           "categorical",      "categorical", "single",    "single",    "categorical", "categorical", "single",    "single",        "single"];
    
    % TODO: Make object oriented
    % Specify variable properties
    opts = setvaropts(opts, ["categoryLabel", "levelLabel", "idLabel", "interventionType", "contingency", "QRedTarget_pst", "catheter"], "EmptyFieldRule", "auto");
    
    % Import the data
    idSpecs = readtable(workbookFile, opts, "UseExcel", false);
    
    % Parse column info
    idSpecs.analysisDuration = seconds(idSpecs.analysisDuration);
    cont_col = false(height(idSpecs),1);
    cont_col(ismember(idSpecs.contingency,{'x','X'})) = true;
    idSpecs.contingency = cont_col;

	% Reader have read to many rows from Excel file (d/t bug?)
	idSpecs(ismissing(idSpecs.analysis_id),:) = [];