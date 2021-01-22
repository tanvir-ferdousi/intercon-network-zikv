% Tanvir Ferdousi
% Kansas State University
% Last Modified: Oct 2018
% Copyright (c) 2019, Tanvir Ferdousi. All rights reserved. 
% Redistribution and use in source and binary forms, with or without
% modification, are permitted

% Generates a file with a list of nodes
% Pop(n,1): Gender
% Pop(n,2): Age Group
% Pop(n,3): Sexual Orientation
function [] = saveNodeList(fileName, N, Pop)
    
    fid = fopen(fileName, 'w');
    fprintf(fid, 'Id,Gender,Age\n');
    for i=1:N
        fprintf(fid, '%d,%d,%d\n', i,Pop(i,1),Pop(i,2));
    end
    fclose(fid);
end