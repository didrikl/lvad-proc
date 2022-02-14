function idSpecs = init_id_specifications(workbookFile)
    % TODO: Make object oriented or at least more generic
        
    % Set up the Import Options and import the data
    opts = spreadsheetImportOptions("NumVariables", 14);
    
	% Specify sheet and range
    opts.DataRange = "A2:N250";
    
    % TODO: Make object oriented
    % Specify column names and types
    opts.VariableNames = ["categoryLabel", "levelLabel",  "idLabel",     "analysis_id", "analysisDuration", "interventionType", "extra",       "contingency", "QRedTarget_pst", "pumpSpeed", "catheter",    "balLev",      "balDiam", "balVol", "arealObstr_pst"];
    opts.VariableTypes = ["categorical",   "categorical", "categorical", "categorical", "single",           "categorical",      "categorical", "categorical", "single",         "single",    "categorical", "categorical", "single",  "single", "single"];
    
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
	extra_col = false(height(idSpecs),1);
    extra_col(ismember(idSpecs.extra,{'x','X'})) = true;
    idSpecs.extra = extra_col;

	% Reader have read to many rows from Excel file (c.f opts.DataRange above)
	idSpecs(ismissing(idSpecs.analysis_id),:) = [];

	check_for_duplicate_id_rows(idSpecs, 1:height(idSpecs))

	idSpecs = addprop(idSpecs,{'Controlled','Measured'},{'variable','variable'}); 
    idSpecs.Properties.CustomProperties.Controlled(:) = true;