% Tanvir Ferdousi
% Kansas State University
% Last Modified: Sep 2018
% Copyright (c) 2019, Tanvir Ferdousi. All rights reserved. 
% Redistribution and use in source and binary forms, with or without
% modification, are permitted

% Creates 2D plots for sensitivity analysis
%% Start Month Vs Host 2 Vect ratio
figure
surf(SM,V2Hratio,AR)
xlabel('Start Month')
ylabel('NV/NH')


%% Host 2 Vect ratio vs Sexual Transmission rate
figure
surf(V2Hratio,SBeta,AR)
xlabel('NV/NH')
ylabel('Beta')


%% Sexual transmission rate vs Start Month
figure
surf(SBeta,SM,AR)
xlabel('Beta')
ylabel('Start Month')