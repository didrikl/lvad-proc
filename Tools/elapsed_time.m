function etime = elapsed_time(datetime_arr)
    etime = seconds(datetime_arr-datetime_arr(1));
