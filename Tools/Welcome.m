function void = Welcome(text)
%[ST,I] = dbstack(1);
%code_files = ST.file;
if not(isempty(text))
    str = sprintf(['\n',text]);%,'... (',code_files,')']);
else
    str = '';
end
underline(1:80) = '-';
%underline(1:length(str)) = '-';
try
    cprintf([0,0,0],'\n')
    cprintf([0,0,0.75],[str,'\n'])
    cprintf([0,0,0.75],[underline])
    cprintf([0,0,0],'\n')
catch
    disp(str)
    disp(underline)
end
