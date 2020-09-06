function S_parts = add_spatial_angles(S_parts)
    % Function for IV2 model to add relevant variables
    % TODO: Make this an IV2 object method
    
    fprintf('\nCalculating spatial angles:')
    
    % Adding angles of most presumably most prominent vibration plane
    fprintf('\n\tEucledian angle of accA_x and accA_z')
    S_parts = add_in_parts(S_parts,{'accA_x','accA_z'},'accA_xz_angle');
    
    % NOTE: Could also include set of two angles for 3-D space, or a set of
    % angles mutually between all components (i.e. between x and y, and y and z) 
    fprintf('\nCalculating spatial norms done.\n')
    

function S_parts = add_in_parts(S_parts,inputVarNames, outputVarName)
    % NOTE: Similar function to that in calc_spatial_norm. It could be a common
    % class method or generic function.
    for i=1:numel(S_parts)
        
        if height(S_parts{i})==0, continue; end
        
        S_parts{i} = calc_spatial_angle(S_parts{i},inputVarNames,outputVarName);     
        
        % Filter out the DC component (e.g. drift or angles due to gravity)
        S_parts{i}.(outputVarName) = detrend(S_parts{i}.(outputVarName));
        
    end
   

