% Tanvir Ferdousi
% Kansas State University
% Last Modified: Oct 2018
% Copyright (c) 2019, Tanvir Ferdousi. All rights reserved. 
% Redistribution and use in source and binary forms, with or without
% modification, are permitted

% Computes confidence interval for given data 
function [range, c] = ConfidenceInterval(x, ci)
    % x needs to be a column vector or a matrix with each column
    % representing a set of data for which CI will be computed
    alpha = 1 - ci;
    sz = size(x);
    n = sz(1);  % Number of samples (row)
    t = tinv(1-alpha/2, n-1);
    c = (t*std(x))/sqrt(n);
    
    dataSetCount = sz(2);   % The types of data (col)
    
    range = zeros(2,dataSetCount);
    for i=1:dataSetCount
        range(1,i) = mean(x(:,i)) - c(i);
        range(2,i) = mean(x(:,i)) + c(i);
    end
end