%         S_par = cell(3,1);
%         PL1 = PL(1:3);
%         PL2 = PL(4:6);
%         PL3 = PL(7:end);
%         clear PL
%         parfor i=1:3
%             if i==1, S_par{i} = merge_table_blocks(PL1); end
%             if i==2, S_par{i} = merge_table_blocks(PL2); end
%             if i==3, S_par{i} = merge_table_blocks(PL3); end
%         end
%         clear PL
%         S = merge_table_blocks(S_par);
