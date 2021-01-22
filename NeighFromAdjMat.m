% Tanvir Ferdousi
% Kansas State University
% Last Modified: Apr 2017
% Copyright (c) 2019, Tanvir Ferdousi. All rights reserved. 
% Redistribution and use in source and binary forms, with or without
% modification, are permitted

% Generates neighborhood style data from adjacency matrix
function [V, i1, i2] = NeighFromAdjMat(A)
    N = length(A);
    V = zeros(1,sum(sum(A)));   % array of neighbors
    i1 = zeros(1,N);    % start index of neighbors
    i2 = zeros(1,N);    % end index of neighbors

    k = 1;
    for i=1:N
        i1(i) = 0;
        i2(i) = 0;
        for j = 1:N
            if A(i,j) ~= 0  % node j is a neighbor of node i
                V(k) = j;

                if i1(i) == 0
                    i1(i) = k;  % set the start index
                end
                i2(i) = k;  % update the end index based on the latest neighbor found

                k = k+1;
            end
        end
    end
end