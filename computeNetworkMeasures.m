% Tanvir Ferdousi
% Kansas State University
% Last Modified: Oct 2018
% Copyright (c) 2019, Tanvir Ferdousi. All rights reserved. 
% Redistribution and use in source and binary forms, with or without
% modification, are permitted

% Computes several network measures given the adjacency matrix
function [avgDeg,density] = computeNetworkMeasures(A)
    E = sum(sum(A))/2;
    dim = size(A);
    N = dim(1);
    K = sum(A);
    avgDeg = mean(K);
    density = E/((N*(N-1))/2);
end