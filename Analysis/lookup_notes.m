function T = lookup_notes(rows,Notes,T,notesVars)
notes_rows = ismember(Notes.rows,rows)

% warning if no note row
% warning if T does not contain row no.
% error if notes contain non-unique row info (i.e. is row is not a key)

% return notes extration
% if nargin==2, return T with notes fused

% if nargin==4, take only relevant vars specified fused into T
% And, check if notesVar exist
notesVarsChecked = check_table_var_input(Notes, notesVars);

% even if empty lookup, T should be added with columns with same variable types
% as in notes.