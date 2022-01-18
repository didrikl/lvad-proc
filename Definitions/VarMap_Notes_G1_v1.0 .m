% * Name in Excel: Must match the name in Excel, but can be changed easily.
% * Name Matlab code: Static variable name used in code. Must be valid a
%   variable name.
% * Type is used for parsing data from Excel into notes Matlab table
% * Continuity is a status property, particularily useful when merging with
%   recorded data, and for resampling using retime, c.f. the timetable
%   VariableContinuity documentation.
%   NB: Categoric type take a lot less memory to store
%   NOTE: Must be listed in the same order as in Excel file.

varMap = {...
    % Name in Excel           Name Matlab code     Type          Continuity
    'Date'                    'date'             'datetime'      'event'
    'Timestamp'               'timestamp'        'double'        'event'
    'Elapsed time'            'partDurTime'      'duration'      'unset'
    'Part'                    'part'             'categorical'   'step'
    %'Timer'                   'timer'            'int16'         'event'
    'Interval'                'intervType'       'categorical'   'step'
    'Event'                   'event'            'categorical'   'step'
    'Par. tag'                'par_id'            'categorical'  'unset'
    'Baseline ref.'           'bl_id'            'categorical'   'step'
    'Analysis'                'analysis_id'      'categorical'   'step'
    'Pump speed'              'pumpSpeed'        'int16'         'step'
    'Balloon level'           'balLev'       'categorical'   'step'
    'Balloon diameter'        'balDiam'      'categorical'   'step'
    'Manometer control'       'manometerCtrl'    'categorical'   'unset'
    'Catheter type'           'catheter'         'categorical'   'unset'
    'Clamp flow red.'         'QRedTarget_pst'   'categorical'   'unset'
    'Flow red. target'        'QRedTarget'       'categorical'   'unset'
    'Flow est.'               'Q_LVAD'           'single'        'step'
    'Power'                   'P_LVAD'           'single'        'step'
    'Flow'                    'Q_noted'          'single'        'step'
    'Injection effect'        'injEff'           'categorical'   'step'
	'Planned procedure'       'procedure'        'cell'          'event'
    'Experiment'              'exper_notes'      'cell'          'event'
    'Quality control'         'QC_notes'         'cell'          'event'
    'Annotation'              'annotation'       'cell'          'event'
    };