% Tanvir Ferdousi
% Kansas State University
% Last Modified: Oct 2018
% Copyright (c) 2019, Tanvir Ferdousi. All rights reserved. 
% Redistribution and use in source and binary forms, with or without
% modification, are permitted

% Runs the ODE solver for vector model

function [Ys, Ye, Yi, t] = vector_sim(lambdaVH, IH, F, e1, e2, sigma, Ys0, Ye0, Yi0, endTime, gTime, startMonth, startLoc)

options = odeset('RelTol', 1e-5);
[t, pop] = ode45(@Diff_Vect, [0 endTime], [Ys0 Ye0 Yi0], options, lambdaVH, IH, F, e1, e2, sigma, gTime, startMonth, startLoc);

Ys = pop(:,1);   % Susceptible mosquito
Ye = pop(:,2);   % Exposed mosquito
Yi = pop(:,3);   % Infected mosquito

end

function dPop = Diff_Vect(t, pop, lambdaVH, IH, F, e1, e2, sigma, gTime, startMonth, startLoc)
    Sv = pop(1);
    Ev = pop(2);
    Iv = pop(3);

    Nv = Sv+Ev+Iv;
    
    abundanceFactor = seasonalVar(gTime+t, startMonth, startLoc);
    %abundanceFactor = 1;

    dPop = zeros(3,1);
    dPop(1) = abundanceFactor*F*Nv - lambdaVH*IH*Sv - e1*Sv;
    dPop(2) = lambdaVH*IH*Sv - sigma*Ev - e2*Ev;
    dPop(3) = sigma*Ev - e2*Iv;
end