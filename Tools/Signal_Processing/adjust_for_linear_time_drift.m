function US = adjust_for_linear_time_drift(US, secsAhead,diffReadTime)
    if nargin<3, diffReadTime = US.time(end); end
    
    secsRecDur = seconds(diffReadTime-US.time(1));
    driftPerSec = secsAhead/secsRecDur;
    
    driftCompensation = seconds(0:driftPerSec:secsAhead);
    driftCompensation = driftCompensation(1:height(US))';
    US.time = US.time-driftCompensation;
