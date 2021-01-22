% Tanvir Ferdousi
% Kansas State University
% Last Modified: Sep 2018
% Copyright (c) 2019, Tanvir Ferdousi. All rights reserved. 
% Redistribution and use in source and binary forms, with or without
% modification, are permitted

% Creates plots for survival analysis
%% BA_m
figure
plot(BA_m,AR,'LineWidth',2)
xlabel('Barabasi Albert parameter, m')
ylabel('Epidemic Attack Rate')
set(gca, 'fontsize', 15)

figure
plot(BA_m,SS,'LineWidth',2)
xlabel('Barabasi Albert parameter, m')
ylabel('Pathogen Survival (days)')
set(gca, 'fontsize', 15)


figure
plot(BA_m,hostLastDayStoch,'LineWidth',2)
xlabel('Barabasi Albert parameter, m')
ylabel('Epidemic Length (days)')
set(gca, 'fontsize', 15)

% figure
% plot(BA_m,DS,'LineWidth',2)
% xlabel('Barabasi Albert parameter, m')
% ylabel('Pathogen survival days (Deterministic)')
% set(gca, 'fontsize', 15)
% 
% figure
% plot(BA_m,hostLastDay,'LineWidth',2)
% xlabel('Barabasi Albert parameter, m')
% ylabel('Epidemic length in Days (Deterministic)')
% set(gca, 'fontsize', 15)


%% start month
figure
plot(SM,AR,'LineWidth',2)
xlabel('Pathogen Introduction Month')
ylabel('Epidemic Attack Rate')
set(gca, 'fontsize', 15)

figure
plot(SM,SS,'LineWidth',2)
xlabel('Pathogen Introduction Month')
ylabel('Pathogen Survival (days)')
set(gca, 'fontsize', 15)


figure
plot(SM,hostLastDayStoch,'LineWidth',2)
xlabel('Pathogen Introduction Month')
ylabel('Epidemic Length (days)')
set(gca, 'fontsize', 15)

% figure
% plot(SM,DS,'LineWidth',2)
% xlabel('Pathogen Introduction Month')
% ylabel('Pathogen survival days (Deterministic)')
% set(gca, 'fontsize', 15)
% 
% figure
% plot(SM,hostLastDay,'LineWidth',2)
% xlabel('Pathogen Introduction Month')
% ylabel('Epidemic length in Days (Deterministic)')
% set(gca, 'fontsize', 15)

%% Beta
figure
plot(SBeta,AR,'LineWidth',2)
xlabel('Sexual Transmission Rate, \beta')
ylabel('Epidemic Attack Rate')
set(gca, 'fontsize', 15)

figure
plot(SBeta,SS,'LineWidth',2)
xlabel('Sexual Transmission Rate, \beta')
ylabel('Pathogen Survival (days)')
set(gca, 'fontsize', 15)


figure
plot(SBeta,hostLastDayStoch,'LineWidth',2)
xlabel('Sexual Transmission Rate, \beta')
ylabel('Epidemic Length (days)')
set(gca, 'fontsize', 15)


% figure
% plot(SBeta,DS,'LineWidth',2)
% xlabel('Sexual Transmission Rate, \beta')
% ylabel('Pathogen survival days (Deterministic)')
% set(gca, 'fontsize', 15)
% 
% figure
% plot(SBeta,hostLastDay,'LineWidth',2)
% xlabel('Sexual Transmission Rate, \beta')
% ylabel('Epidemic length in Days (Deterministic)')
% set(gca, 'fontsize', 15)