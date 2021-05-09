    
    % * Name in Excel: Must match the name in Excel, but can be changed easily.
    % * Name Matlab code: Static variable name used in code. Must be valid a
    %   variable name.
    % * Type is used for parsing data from Excel into notes Matlab table
    % * Continuity is a status property, particularily useful when merging with 
    %   recorded data, and for resampling using retime, c.f. the timetable 
    %   VariableContinuity documentation.  
    %   NB: Categoric type take a lot less memory to store
    %   NOTE: Must be listed in the same order as in Excel file.
    %   TODO: Make more flexible wrt. list order
    % TODO: Specific a list of variables for data fusion, while the rest is just
    % stored in the notes table??
    varMap = {...  
        % Name in Excel           Name Matlab code     Type          Continuity
        'Date'                    'date'             'datetime'      'event'
        'Timestamp'               'timestamp'        'double'        'event'
        'Elapsed time'            'partDurTime'      'duration'      'unset'
        'Part'                    'part'             'categorical'   'step' 
        %'Timer'                   'timer'            'int16'         'event'
        'Interval'                'intervType'       'categorical'   'step'
        'Event'                   'event'            'categorical'   'step'
        %'Par. tag'                'par_id'             'categorical'   'step' 
        'Baseline ref.'           'bl_id'            'categorical'   'unset'
        'Analysis'                'analysis_id'      'categorical'   'step'
        'Pump speed'              'pumpSpeed'        'int16'         'step'
        'Balloon level'           'balloonLevel'     'categorical'   'step'
        'Balloon diameter'        'balloonDiam'      'single'        'unset'
        'Manometer control'       'manometerCtrl'    'categorical'   'unset'
        'Catheter type'           'catheter'         'categorical'   'unset'%'step'
        'Clamp flow red.'         'Q_RedPst'         'categorical'   'unset'
        'Flow red. target'        'Q_RedTarget'      'single'        'unset'
        %'Balloon diam. est.'      'balDiamEst'       'single'        'unset'
        'Flow est.'               'Q_LVAD'           'single'        'step'
        'Power'                   'P_LVAD'           'single'        'step'
        'Flow'                    'Q_noted'          'single'        'unset'
        'Planned procedure'       'procedure'        'cell'          'event'
        'Experiment'              'exper_notes'      'cell'          'event'
        'Quality control'         'QC_notes'         'cell'          'event'
        'Annotation'              'annotation'       'cell'          'event'
        };