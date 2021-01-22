% Tanvir Ferdousi
% Kansas State University
% Last Modified: Oct 2018
% Copyright (c) 2019, Tanvir Ferdousi. All rights reserved. 
% Redistribution and use in source and binary forms, with or without
% modification, are permitted

% Computes averages for vector simulation results from multiple iterations
function [TVec, MSus, MExp, MInf, CI, VECT_PROP] = computeVectAvg(TVecCell, MSusCell, MExpCell, MInfCell, iter, Tend, dataRange, ci)
    
    % Average out the vector population
    
    % Declare necessary objects
    MSusDayWiseCell = cell(1,iter);
    MSusDayWise = zeros(1,Tend+1);
    
    MExpDayWiseCell = cell(1,iter);
    MExpDayWise = zeros(1,Tend+1);
    
    MInfDayWiseCell = cell(1,iter);
    MInfDayWise = zeros(1,Tend+1);
    
    TVec = 0:Tend;
    
    for i=1:iter
        T_raw = TVecCell{1,i};
        MSus_raw = MSusCell{1,i};
        MExp_raw = MExpCell{1,i};
        MInf_raw = MInfCell{1,i};
        
        % Trim out unnecessary part of the data
        T_corrected = T_raw(T_raw <= Tend);
        dataLen = length(T_corrected);
        MSus_corrected = MSus_raw(1:dataLen);
        MExp_corrected = MExp_raw(1:dataLen);
        MInf_corrected = MInf_raw(1:dataLen);
        
        % Starting values for day 0
        MSusDayWise(1) = MSus_corrected(1);
        MExpDayWise(1) = MExp_corrected(1);
        MInfDayWise(1) = MInf_corrected(1);
        
        for day = 1:Tend
            matchingIndices = find(T_corrected > (day-1) & T_corrected <= day);
            if isempty(matchingIndices)
                % Use the previous value
                MSusDayWise(day+1) = MSusDayWise(day);
                MExpDayWise(day+1) = MExpDayWise(day);
                MInfDayWise(day+1) = MInfDayWise(day);
            else
                latestIndex = matchingIndices(end);
                MSusDayWise(day+1) = MSus_corrected(latestIndex);
                MExpDayWise(day+1) = MExp_corrected(latestIndex);
                MInfDayWise(day+1) = MInf_corrected(latestIndex);
            end
        end
        
        MSusDayWiseCell{i} = MSusDayWise;
        MExpDayWiseCell{i} = MExpDayWise;
        MInfDayWiseCell{i} = MInfDayWise;
    end
    
    % Sum up/find avg
    MSus = zeros(1,Tend+1);
    MExp = zeros(1,Tend+1);
    MInf = zeros(1,Tend+1);
    for day=1:Tend+1
        for i=1:iter
            MSus(day) = MSus(day) + MSusDayWiseCell{i}(day);
            MExp(day) = MExp(day) + MExpDayWiseCell{i}(day);
            MInf(day) = MInf(day) + MInfDayWiseCell{i}(day);
        end
    end
    
    MSus = MSus/iter;
    MExp = MExp/iter;
    MInf = MInf/iter;
    
    % Sort data to compute confidence intervals
    MV = 3; % Number of vector compartments
    StateDataDayWise = zeros(iter,MV,Tend+1);
    
    for i=1:iter
        for d=1:Tend+1
            StateDataDayWise(i,1,d) = MSusDayWiseCell{i}(d);
            StateDataDayWise(i,2,d) = MExpDayWiseCell{i}(d);
            StateDataDayWise(i,3,d) = MInfDayWiseCell{i}(d);
        end
    end
    
    % Compute CI daywise
    CI = zeros(2,MV,Tend+1);
    
    for d=1:Tend+1
        CI(:,:,d) = ConfidenceInterval(StateDataDayWise(:,:,d),ci);
    end
    
    
    % Compute vector outbreak property (TVL)
    
    % Col 1: TVL
    VECT_PROP = zeros(iter,1);
    
    for i=1:iter
        vectDays = find(StateDataDayWise(i,3,dataRange)>=1);
        tvl = vectDays(end);
        VECT_PROP(i) = tvl;
    end
    
    
end