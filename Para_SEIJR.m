% Tanvir Ferdousi
% Kansas State University
% Last Modified: Sep 2018
% Copyright (c) 2019, Tanvir Ferdousi. All rights reserved. 
% Redistribution and use in source and binary forms, with or without
% modification, are permitted

% Creates a GEMF compatible data structure using host model parameters
function Para=Para_SEIJR(lambdaHV, V, delta, tau, beta, gamma1, gamma2,theta,mu)

q = zeros(1,4);
M=7; q(1,:)=[3 4 5 6]; L=1;
A_d=zeros(M);

A_d(1,2) = lambdaHV*V;
A_d(2,3) = tau*delta;
A_d(2,4) = (1-tau)*delta;
A_d(3,5) = gamma1;
A_d(3,7) = gamma1;
A_d(4,6) = gamma1;
A_d(4,7) = gamma1;
A_d(5,7) = gamma2;
A_d(6,7) = gamma2;


A_b=zeros(M,M,L);

A_b(1,2,1)=beta;

Para={M,q,L,A_d,A_b,theta,mu};

end