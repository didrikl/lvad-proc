function [T, segs] = make_dur_and_seg_info(T, Notes, fs)
	
	noteVarsNeeded = {
		'part'               
		'intervType'         
		'event'              
		'Q_LVAD'             
		'P_LVAD'      
		'balDiam_xRay'
		'balLev_xRay'         
		'arealObstr_xRay_pst'
		'embVol'             
		'embType'            
		'pumpSpeed'          
		'QRedTarget_pst'
		};
	
	T = join_notes(T, Notes, noteVarsNeeded);
	T.dur = linspace(0,1/fs*height(T),height(T))';
	segs = get_segment_info(T, 'dur');
	