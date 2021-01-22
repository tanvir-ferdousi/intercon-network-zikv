% Tanvir Ferdousi
% Kansas State University
% Last Modified: Oct 2018
% Copyright (c) 2019, Tanvir Ferdousi. All rights reserved. 
% Redistribution and use in source and binary forms, with or without
% modification, are permitted

% Computes several outbreak properties (attack rate, host infection length and pathogen survial)
function [AR,THL,TPS]=computeOutbreakProperties(NH,StateCount,MInf,dataRange)
    % Attack Rate
    AR = max(StateCount(7,:)/NH);

    
    hostDaysIs = find(StateCount(3,:)>1);
    hostDaysIa = find(StateCount(4,:)>1);
    hostDaysJs = find(StateCount(5,:)>1);
    hostDaysJa = find(StateCount(6,:)>1);

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

    % Epidemic length
    THL = max(max(lastDayIs,lastDayIa),max(lastDayJs,lastDayJa));

    vectDays = find(MInf(dataRange)>1);
    TVL = vectDays(end);

    % Pathogen Survival
    TPS = THL - TVL;
end