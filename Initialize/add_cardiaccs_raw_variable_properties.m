function raw = add_cardibox_raw_variable_properties(raw)
    
    raw.Properties.VariableDescriptions{'t'} = 'The Current Unix Timestamp';
    raw.Properties.VariableDescriptions{'adc'} = 'External analog input';
    raw.Properties.VariableDescriptions{'adcscale'} = 'Scaling factor for physical scale in voltage (mV)';
    raw.Properties.VariableDescriptions{'acc'} = 'Acceleration';
    raw.Properties.VariableDescriptions{'accscale'} = 'Scaling factor for gravitational scale (g)';
    raw.Properties.VariableUnits{'t'} = 'sec';
    raw.Properties.VariableUnits{'adc'} = 'AU';
    raw.Properties.VariableUnits{'acc'} = 'AU';
    raw.Properties.VariableUnits{'adcscale'} = 'mV';
    raw.Properties.VariableUnits{'accscale'} = 'g';
