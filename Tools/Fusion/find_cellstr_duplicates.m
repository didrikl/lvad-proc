function [unique_elements, duplicated_elements] = find_cellstr_duplicates(c)
    N = arrayfun(@(k) sum(arrayfun(@(j) isequal(c{k}, c{j}), 1:numel(c))), 1:numel(c));
    unique_elements = c(N==1);
    duplicated_elements = c(N>1);