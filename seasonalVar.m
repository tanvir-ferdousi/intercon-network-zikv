% Tanvir Ferdousi
% Kansas State University
% Last Modified: Dec 2017
% Copyright (c) 2019, Tanvir Ferdousi. All rights reserved. 
% Redistribution and use in source and binary forms, with or without
% modification, are permitted

% Estimates the mosquito abundance factor based on the day of the year
function [f] = seasonalVar(simTime, startMonth, loc)
    % simTime: 0-360
    % startMonth: 1-12
    % loc: 1 for Miami, 2 for Phoenix
    M = zeros(3,14);
    loc = loc+1;
    day = simTime + (startMonth-1)*30;
    
    while day > 360
        day = day - 360;
    end
    % The data is taken from 
    % http://currents.plos.org/outbreaks/article/on-the-seasonal-occurrence-and-abundance-of-the-zika-virus-vector-mosquito-aedes-aegypti-in-the-contiguous-united-states/
    M(1,:) = [0 15 45 75 105 135 165 195 225 255 285 315 345 360];
    
    % Miami
    M(2,:) = [0.08 0.06 0.03 0.03 0.05 0.23 0.98 1 0.7 0.35 0.17 0.05 0.1 0.08];
    
    % Phoenix
    M(3,:) = [0 0 0.01 0.015 0.04 0.1 0.23 0.23 0.415 1 0.93 0.195 0.02 0];
    
    ind = find(M(1,:) >= day);
    i2 = ind(1);
    i1 = i2 - 1;
    
    if i1 == 0
        f = M(loc,i2);
    else
        f = M(loc,i1) + ((M(loc,i2)-M(loc,i1))/(M(1,i2)-M(1,i1)))*(day-M(1,i1));
    end
    % Turn off seasonality
    %f = 0.5;
end