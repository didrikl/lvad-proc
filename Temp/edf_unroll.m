TT = timetable;
parfor col=1:width(data)
    unroll_col = NaN(height(data)*1000,1);
    for row=1:height(data)
        block_inds = (row-1)*1000+1:(row)*1000;
        unroll_col(block_inds) = data{row,col}{:,1}{:,1};
    end
    TT{:,col} = unroll_col;
end