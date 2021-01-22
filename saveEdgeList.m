% Tanvir Ferdousi
% Kansas State University
% Last Modified: Dec 2017
% Copyright (c) 2019, Tanvir Ferdousi. All rights reserved. 
% Redistribution and use in source and binary forms, with or without
% modification, are permitted

% Generates a file with a list of edges
function [] = saveEdgeList(fileName, edgeList)
    
    fid = fopen(fileName, 'w');
    fprintf(fid, 'Source,Target,Type\n');
    fprintf(fid, '%d,%d,Undirected\n', edgeList');
    fclose(fid);
end