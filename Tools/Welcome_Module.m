function void = Welcome_Module(text)
	if not(isempty(text))
		str = sprintf(['\n ',text]);
	else
		str = '';
	end
	border(1:80) = '*';
	try
		cprintf([0,0,0],'\n\n')
		cprintf([0,0,0.75],border)
		cprintf([0,0,0.75],[upper(str),'\n'])
		cprintf([0,0,0.75],border)
		cprintf([0,0,0],'\n')
	catch
		disp('')
		disp(border)
		disp(str)
		disp(border)
	end