function Notes = add_obstruction_pst(Config, Notes, var, newVar)

	Notes.(var) = double(string(Notes.(var)));
	Notes.(newVar) = 100*(Notes.(var).^2)/(Config.inletInnerDiamLVAD^2);
	Notes.Properties.CustomProperties.Measured(newVar) = true;
	Notes = movevars(Notes,newVar,"After",var);