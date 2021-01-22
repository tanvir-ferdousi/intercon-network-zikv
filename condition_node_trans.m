% Tanvir Ferdousi
% Kansas State University
% Last Modified: Aug 2018
% Copyright (c) 2019, Tanvir Ferdousi. All rights reserved. 
% Redistribution and use in source and binary forms, with or without
% modification, are permitted

% Computes conditional node based transition rates
function A_d_con = condition_node_trans(A_d,is,c_am)
    % is is the initial state, it can be any of 1:M-1
    A_d_con = A_d(is,:);
    if is == 3
        A_d_con(5) = A_d_con(5)*c_am;
        A_d_con(7) = A_d_con(7)*(~c_am);
    elseif is == 4
        A_d_con(6) = A_d_con(6)*c_am;
        A_d_con(7) = A_d_con(7)*(~c_am);
    end
end