% Tanvir Ferdousi
% Kansas State University
% Last Modified: Apr 2017
% Copyright (c) 2019, Tanvir Ferdousi. All rights reserved. 
% Redistribution and use in source and binary forms, with or without
% modification, are permitted

% Loads adjacency matrix and generates neighborhood style data
function Net = NetLoad(file)
    load(file);
    
    % Format everything into GEMF compatible data
    adj = cell(1);
    adj{1} = sparse(A);
    adj{1} = adj{1} + adj{1}';
    d = sum(A)';
    
    Neigh = cell(1);
    [V, I1, I2] = NeighFromAdjMat(A);
    Neigh{1} = V;
    
    Net = {Neigh, I1, I2, d, adj};

end