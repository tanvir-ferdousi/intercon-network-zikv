% Tanvir Ferdousi
% Kansas State University
% Last Modified: April 2017
% Copyright (c) 2019, Tanvir Ferdousi. All rights reserved. 
% Redistribution and use in source and binary forms, with or without
% modification, are permitted

% Generates the edge list from the adjacency matrix
function [edgeList]=edgeListGen(A)
    
    N = length(A);

    edgeList = zeros((N*(N-1)/2), 2);

    k = 0;
    for i=1:N
        for j=i:N
            if A(i,j) ~= 0
                k = k + 1;
                edgeList(k,1) = i;
                edgeList(k,2) = j;
            end
        end
    end
    
    edgeList = edgeList(1:k,:);

end