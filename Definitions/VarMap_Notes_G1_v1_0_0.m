% * Name in Excel: Must match the name in Excel, but can be changed easily.
% * Name Matlab code: Static variable name used in code. Must be valid a
%   variable name.
% * Type is used for parsing data from Excel into notes Matlab table
% * Continuity is a status property, particularily useful when merging with
%   recorded data, and for resampling using retime, c.f. the timetable
%   VariableContinuity documentation.
%   - Unset: no merging
%   - Step: Stepwise interpolation
%   - Continious: Interpolation with given method
%   - Event: Just fill data at the noted timestamp and missing in between
%   NB: Categoric type take a lot less memory to store
%   NOTE: Must be listed in the same order as in Excel file?
%   NOTE: Use the new variable type 'half' for some the single variabls?

varMap = {...
	% Name in Excel       Name Matlab code     Type          Continuity
	'Date'                'date'             'datetime'      'event'
	'Timestamp'           'timestamp'        'double'        'event'
	'Elapsed time'        'partDurTime'      'duration'      'unset'
	%'Timer'               'timer'            'int16'         'event'
	'X-ray series'        'xRay_id'          'int16'         'unset'
	%'Hand notes'         'handNotes_id'      'cell'          'step'
	'Baseline ref.'       'bl_id'            'categorical'   'step'
    'Analysis'            'analysis_id'      'categorical'   'step'
	'Part'                'part'             'categorical'   'step'
	'Interval'            'intervType'       'categorical'   'step'
	'Event'               'event'            'categorical'   'step'
	'Par. tag'            'parTag'           'categorical'   'unset'
	'Embolus vol.'        'embVol'           'single'        'unset'
	'Embolus type'        'embType'          'categorical'   'unset'
	'Pump speed'          'pumpSpeed'        'int16'         'step'
	'Balloon level'       'balLev'           'categorical'   'unset'
	'Balloon diameter'    'balDiam'          'categorical'   'unset'
	'Manometer control'   'manoCtrl'         'categorical'   'unset'
	'Catheter type'       'catheter'         'categorical'   'unset'
	'Clamp flow red.'     'QRedTarget_pst'   'categorical'   'unset'
	'Flow red. target'    'QRedTarget'       'single'        'unset'
	'Balloon offset'      'balOffset'        'single'        'unset'
	'Balloon diam. est.'  'balDiamEst'       'single'        'step'
	'Flow est.'           'Q_LVAD'           'single'        'step'
	'Power'               'P_LVAD'           'single'        'step'
	'Flow'                'Q_noted'          'single'        'unset'
	'Max art. p'          'p_maxArt'         'int16'         'unset'
	'Min art. p'          'p_minArt'         'int16'         'unset'
	'MAP'                 'MAP'              'int16'         'unset'
	'Max pulm. p'         'p_maxPulm'        'int16'         'unset'
	'Min pulm. p'         'p_minPulm'        'int16'         'unset'
	'HR'                  'HR'               'int16'         'unset'
	'CVP'                 'CVP'              'int16'         'unset'
	'SvO2'                'SvO2'             'int16'         'unset'
	'Cont. CO'            'CO_cont'          'int16'         'step'
	'Thermo. CO'          'CO_thermo'        'int16'         'step'
	'Hematocrit'          'HCT'              'int16'         'unset'
	'Injection effect'    'injEff'           'categorical'   'step'
	'Procedure'           'procedure'        'cell'          'event'
	'Experiment'          'experNotes'       'cell'          'event'
	'Quality control'     'QCNotes'          'cell'          'event'
	};