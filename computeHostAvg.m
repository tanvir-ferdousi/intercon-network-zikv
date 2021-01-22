% Tanvir Ferdousi
% Kansas State University
% Last Modified: Oct 2018
% Copyright (c) 2019, Tanvir Ferdousi. All rights reserved. 
% Redistribution and use in source and binary forms, with or without
% modification, are permitted

% Computes averages for host simulation results from multiple iterations

function [T, StateCount, CI, HOST_PROP] = computeHostAvg(TCell, StateCountCell, iter, Tend, M, NH, ci)

    % Avg out the host population
    
    % Declare necessary objects
    StateCountDayWiseCell = cell(1,iter);
    StateCountDayWise = zeros(M,Tend+1);
    T = 0:Tend;
    for i=1:iter
        T_raw = TCell{1,i};
        StateCount_raw = StateCountCell{1,i};
        
        % Trim out unnecessary part of the data
        T_corrected = T_raw(T_raw <= Tend);
        dataLen = length(T_corrected);
        StateCount_corrected = StateCount_raw(:,1:dataLen);
        
        % Starting values for day 0
        StateCountDayWise(:,1) = StateCount_corrected(:,1);
        
        % Down-sample data into per day resolution
        for day = 1:Tend
            matchingIndices = find(T_corrected > (day-1) & T_corrected <= day);
            if isempty(matchingIndices)
                % Use the previous value
                StateCountDayWise(:,day+1) = StateCountDayWise(:,day);
            else
                latestIndex = matchingIndices(end);
                StateCountDayWise(:,day+1) = StateCount_corrected(:,latestIndex);
            end
        end 
        
        StateCountDayWiseCell{i} = StateCountDayWise;
    end
    
    % Sum up/find avg
    StateCount = zeros(M,Tend+1);
    for day=1:Tend+1
        for i=1:iter
            StateCount(:,day) = StateCount(:,day)+ StateCountDayWiseCell{i}(:,day);
        end
    end
    
    StateCount = StateCount/iter;
    
    % Sort data to compute confidence intervals
    StateDataDayWise = zeros(iter,M,Tend+1);
    
    for i=1:iter
        for s=1:M
            for d=1:Tend+1
                StateDataDayWise(i,s,d) = StateCountDayWiseCell{i}(s,d);
            end
        end
    end
    
    % Compute CI daywise
    CI = zeros(2,M,Tend+1);
    
    % CI (Range,Compartments,Day)
    for d=1:Tend+1
        CI(:,:,d) = ConfidenceInterval(StateDataDayWise(:,:,d),ci);
    end
    
    
    % Compute host outbreak properties (AR, THL)
    
    % Col 1: AR, Col 2: THL
    HOST_PROP = zeros(iter,2);
    
    for i=1:iter
        % attack rate
        ar = max(StateDataDayWise(i,7,:))/NH;

        hostDaysIs = find(StateDataDayWise(i,3,:)>1);
        hostDaysIa = find(StateDataDayWise(i,4,:)>1);
        hostDaysJs = find(StateDataDayWise(i,5,:)>1);
        hostDaysJa = find(StateDataDayWise(i,6,:)>1);
        
        if isempty(hostDaysIs)
            lastDayIs = 0;
        else
            lastDayIs = hostDaysIs(end);
        end

        if isempty(hostDaysIa)
            lastDayIa = 0;
        else
            lastDayIa = hostDaysIa(end);
        end

        if isempty(hostDaysJs)
            lastDayJs = 0;
        else
            lastDayJs = hostDaysJs(end);
        end

        if isempty(hostDaysJa)
            lastDayJa = 0;
        else
            lastDayJa = hostDaysJa(end);
        end

        % epidemic length
        thl = max(max(lastDayIs,lastDayIa), max(lastDayJs,lastDayJa));
        
        HOST_PROP(i,:) = [ar thl];
    end
end