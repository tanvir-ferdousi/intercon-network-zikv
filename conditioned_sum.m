% Tanvir Ferdousi
% Kansas State University
% Last Modified: Aug 2018
% Copyright (c) 2019, Tanvir Ferdousi. All rights reserved. 
% Redistribution and use in source and binary forms, with or without
% modification, are permitted

% Applies conditions when summing up node based transition rates
function di = conditioned_sum(A_d, N_AM, N_NAM, N)
    
    di = sum(A_d,2);
    
    di(3) = A_d(3,5)*(N_AM/N) + A_d(3,7)*(N_NAM/N);
    di(4) = A_d(4,6)*(N_AM/N) + A_d(4,7)*(N_NAM/N);
    
end