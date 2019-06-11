function c = mat2cellstr_pst(mat, n_decimals)
% Convert a numerical array to cell array of percentage strings.
%
% Input arguments
%     mat (num matrix)
%
% Optional arguments
%     n_decimals (num) : Number (positive integer) of decimals
%
% Example:
% c = mat2cellstr_pst([1 0.5; 2 0.10],2)
% 
% c =
% 
%   2×2 cell array
% 
%     {'100.00 %'}    {'100.00 %'}
%     {'200.00 %'}    {'200.00 %'}
%
% See also 
%     cellstr_pst2mat

if nargin==1
    n_decimals = 0;
else
    % if number of decimals are not correctly given, then it is safest to just
    % throw an error (probably wrong use of this function)
    assert(n_decimals>=0, 'Number of decimals must be positive')
    assert(mod(n_decimals,1)==0, 'Number of decimals is given with decimals')
end
fmt = ['%.',num2str(n_decimals),'f pst\t'];


mat = 100*mat;
[n_rows,n_cols] = size(mat);
c = cell(n_rows,n_cols);
for i=1:n_rows
    c(i,:) = strsplit(num2str(mat(i,:),fmt),'\t');
end

