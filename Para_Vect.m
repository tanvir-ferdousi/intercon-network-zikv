% Tanvir Ferdousi
% Kansas State University
% Last Modified: Dec 2017
% Copyright (c) 2019, Tanvir Ferdousi. All rights reserved. 
% Redistribution and use in source and binary forms, with or without
% modification, are permitted

% Creates a GEMF compatible data structure using vector model parameters
function [ParaVector] = Para_Vect(NV, Yi0, F, e1, e2, sigma, lambdaVH, lambdaHV, startMonth, startLoc)
    ParaVector = {NV, Yi0, F, e1, e2, sigma, lambdaVH, lambdaHV, startMonth, startLoc};
end