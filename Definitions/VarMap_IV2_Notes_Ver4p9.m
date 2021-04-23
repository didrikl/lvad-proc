    
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
        %'Timer'                   'timer'            'int16'         'event'
        %'X-ray series'            'xraySer'          'int16'         'step'
        %'Hand notes'             'handNotesTag'      'cell'          'step'
        %'Analysis'                'analysisTag'      'categorical'   'step'
        'Part'                    'part'             'categorical'   'step' 
        'Interval'                'intervType'       'categorical'   'step'
        'Event'                   'event'            'categorical'   'step'
        %'Par. tag'                'parTag'           'categorical'   'unset'
        %'Inject vol.'             'thrombusVol'      'int16',        'unset'
        %'Embolus type'            'thrombusType'     'categorical'   'unset'
        'Pump speed'              'pumpSpeed'        'int16'         'step'
        'Balloon level'           'balloonLevel'     'categorical'   'step'
        'Balloon diameter'        'balloonDiam'      'single'        'unset'
        'Manometer control'       'manometerCtrl'    'categorical'   'unset'
        'Catheter type'           'catheter'         'categorical'   'unset'%'step'
        'Clamp flow red.'         'Q_RedPst'         'categorical'   'unset'
        'Flow red. target'        'Q_RedTarget'      'single'        'unset'
        %'Balloon offset'          'balloonOffset'    'categorical'   'unset'
        %'Balloon diam. est.'      'balDiamEst'       'single'        'unset'
        'Flow est.'               'Q_LVAD'           'single'        'step'
        'Power'                   'P_LVAD'           'single'        'step'
        'Flow'                    'Q_noted'          'single'        'unset'
        %'Max art. p'              'p_maxArt'         'int16'         'unset'
        %'Min art. p'              'p_minArt'         'int16'         'unset'
        %'MAP'                     'MAP'              'int16'         'unset'
        %'Max pulm. p'             'p_maxPulm'        'int16'         'unset'
        %'Min pulm. p'             'p_minPulm'        'int16'         'unset'
        %'HR'                      'HR'               'int16'         'unset'
        %'CVP'                     'CVP'              'int16'         'unset'
        %'SvO2'                    'SvO2'             'int16'         'unset'
        %'Cont. CO'                'CO_cont'          'int16'         'step'
        %'Thermo. CO'              'CO_thermo'        'int16'         'step'
        %'Hema-tocrit'             'HCT'              'int16'         'unset'
        'Plan and preparation'     'procedure'        'cell'          'event'
        'Experiment'              'exper_notes'      'cell'          'event'
        'Quality control'         'QC_notes'         'cell'          'event'
        'Interval annotation'     'annotation'       'cell'          'event'
        };