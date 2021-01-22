% Tanvir Ferdousi
% Kansas State University
% Last Modified: Oct 2018
% Copyright (c) 2019, Tanvir Ferdousi. All rights reserved. 
% Redistribution and use in source and binary forms, with or without
% modification, are permitted

% Averages out several properties
function [avg_props, props_half_int] = computeOutPropAvg(HOST_PROP, VECT_PROP, ci)
    % AR, THL, TVL
    PROP = [HOST_PROP VECT_PROP];
    
    PROP(:,4) = PROP(:,2) - PROP(:,3);
    
    
    avg_props = mean(PROP);
    
%     ar = avg_properties(1);
%     thl = avg_properties(2);
%     tvl = avg_properties(3);
%     tps = avg_properties(4);
    
    [range, props_half_int] = ConfidenceInterval(PROP,ci);
    
%     arc = c(1);
%     thlc = c(2);
%     tvlc = c(3);
%     tpsc = c(4);
%    
end