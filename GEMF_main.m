% Faryad Darabi Sahneh
% Kansas State University
% Last Modified: Sep 2013
% Copyright (c) 2013, Faryad Darabi Sahneh. All rights reserved. 
% Redistribution and use in source and binary forms, with or without
% modification, are permitted

% Last Modified: Nov 2018
% Tanvir Ferdousi
% Kansas State University
% Supports host and vector interconnected simulations, multiple iterations, average computations

clear; clc
%% Initial Setup

% Human host parameters
NH = 1000;

% Population characteristics
maleRatio = 0.5;
ageGroupRatio = [0.19 0.66 .15]';   %USA, World Bank, WDI: pop dyn. http://wdi.worldbank.org/table/2.1
sexOrientation = [0.972 .025 0.003; 0.989 0.002 0.009];  % Row 1: men, Row 2: women. Cols: Straight, Bi and Gay % respectively 

% Classes: 0(no  partner), 1, 2, 3, 4, 5-9, 10-19, 20+
partnerClasses = [0.157 0.723 0.055 0.028 0.016 0.015 0.004 0.002]';
avgAdultDeg = 1.28;

%% Generation/Save

Pop = PopGen(NH, maleRatio, ageGroupRatio, sexOrientation);
save('outputs/network/population.mat','Pop')
[Net,avgGenAdultsDeg] = NetGen_CustomConfig(NH,Pop,partnerClasses,avgAdultDeg);
disp('Network generation complete!')
fprintf('Average degree in adult population: %d\n',avgGenAdultsDeg)

%% Load Population and network data

%load('outputs/network/population.mat')
%Net = NetLoad('outputs/network/network.mat');
%disp('Network load complete!')
%%
% Mosquito vector parameters
NV = 5e3;          % Total number of mosquitos
Yi0 = 1;           % Total number of infected mosquitos
Ys0 = NV-Yi0;      % Total number of susceptible mosquitos
Ye0 = 0;           % Total number of exposed mosquitos
e1 = 1/12;         % Susceptible mosquito mortality rate
e2 = e1;           % Infected mosquito mortality rate
F = 1/12;          % Mosquito birth rate per capita
b = 0.63;          % Bites per unit time (day) by one mosquito
r=b/NH;            % Bites per person per unit time (day) by one mosquito

% Disease parameters
T_VH = 0.770;                % Host to Vector transmission probability
T_HV = 0.634;                % Vector to Host transmission probability
lambdaVH = r*T_VH;           % Host to Vector transmission rate
lambdaHV = r*T_HV;           % Vector to Host transmission rate

delta=1/7;                   % Intrinsic Incubation rate in human hosts
sigma = 1/8;                 % Extrinsic Incubation rate in mosquito vectors
beta = 0.0017;                % Host to host sexual transmission rate

tau = 0.2;
gamma1 = 1/7;       % Transition rate from infectious to convalescent state
gamma2 = 1/30;      % Transition rate from convalescent state to recovered state (Turmel et al., 2016)
theta = 0.5;        % Relative sexual transmissibility in asymptomatic state
mu = 0.5;           % Relative sexual transmissibility in convalescent state

% Seasonal Parameters
startMonth = 11;              % Simulation start month (April, August, October)
startLoc = 1;                 % Simulation location: 1 for Miami, 2 for Phoenix

% Simulation Parameters
Tend = 300;                   % Simulation end time
iter = 500;                   % Number of stochastic realizations
ci = 0.95;                   % Confidence interval


% Structurization of parameters & initial conditions
Para=Para_SEIJR(lambdaHV, Yi0, delta, tau, beta, gamma1, gamma2, theta, mu);
M=Para{1};
ParaVector = Para_Vect(NV, Yi0, F, e1, e2, sigma, lambdaVH, lambdaHV, startMonth, startLoc);
x0=Initial_Cond_Gen(NH,'Population',[3 4 5 6],[0 0 0 0]);
StatesPlot=[1, 2, 3, 4, 5, 6, 7];

% Saving data


%% Stochastic

% StopCond={'EventNumber',15000};
StopCond={'RunTime',Tend};

StateCountCell = cell(1,iter);
TCell = cell(1,iter);
MSusCell = cell(1,iter);
MExpCell = cell(1,iter);
MInfCell = cell(1,iter);
TVecCell = cell(1,iter);
TS = cell(1,iter);
for m=1:iter
    fprintf('Iteration %d/%d\n',m,iter)
    tic
    [TS{m},n_index,i_index,j_index, MSusCell{m}, MExpCell{m}, MInfCell{m}, TVecCell{m}]=GEMF_COUPLED_SIM(Para,ParaVector,Net,Pop,x0,StopCond);
    toc

    % Post Processing
    [TCell{m}, StateCountCell{m}]=Post_Population(x0,M,NH,TS{m},i_index,j_index);
end

%% Average out multiple stochastic realizations
endMarkers = zeros(1,iter);
for m=1:iter
    endMarkers(m) = TCell{m}(end);
end
dataEndMarker = floor(mean(endMarkers));

% % Special situation: dataEndMarker < Tend
if dataEndMarker > Tend
 dataRange = 1:Tend+1;
else
 dataRange = 1:(dataEndMarker+1);
end

[T, StateCount, CIH, HOST_PROP] = computeHostAvg(TCell, StateCountCell, iter, Tend, M, NH, ci);
[TVec, MSus, MExp, MInf, CIV, VECT_PROP] = computeVectAvg(TVecCell, MSusCell, MExpCell, MInfCell, iter, Tend, dataRange, ci);
StateCountV = [MSus;MExp;MInf];

% Avg of AR, THL, TVL, TPS with the half of the conf. interval
[avg_props, props_half_int] = computeOutPropAvg(HOST_PROP, VECT_PROP, ci);


% Plots
figure
plot(T,StateCount(StatesPlot,:)/NH, 'LineWidth', 2); hold on;
legend('Susceptible','Exposed','Infected (S)','Infected (A)','Convalescent (S)','Convalescent (A)','Recovered');
xlim([0 StopCond{2}])
xlabel('Time (Day)')
ylabel('Fraction of human hosts')
title('Stochastic solution of human host dynamics')
set(gca, 'fontsize', 15)
hold off
box on
savefig('outputs/autosave/singleSim/stochHost')


% Special situation: dataEndMarker < Tend
 figure
 if dataEndMarker > Tend
    semilogy(TVec, MSus, 'LineWidth', 2)
    hold on
    semilogy(TVec, MExp, 'LineWidth', 2)
    semilogy(TVec, MInf, 'LineWidth', 2)
 else
    noDataRange = dataEndMarker+2:Tend+1;
    semilogy(TVec(dataRange), MSus(dataRange), 'LineWidth', 2)
    hold on
    semilogy(TVec(dataRange), MExp(dataRange), 'LineWidth', 2)
    semilogy(TVec(dataRange), MInf(dataRange), 'LineWidth', 2)
 end
hold off
ylim([10^0 10^5])
xlim([0 StopCond{2}])
legend('Susceptible','Exposed','Infected');
xlabel('Time (Day)')
ylabel('Number of mosquito vectors')
title('Stochastic solution of vector dynamics')
set(gca, 'fontsize', 15)
box on
savefig('outputs/autosave/singleSim/stochVect')

%% Compute other plots and save workspace
%PlotTimeDomCI
%save('outputs/autosave/singleSim/workspace')


%% Plot TS

% Trim upto 100 days.
lastDay = 100;
TS_TR = cell(1,iter);
TS_ARRAY = [];
for m=1:iter
    ts = TS{m};
    ts_cum = cumsum(ts);
    ts_trimmed = ts(ts_cum <= lastDay);
    TS_TR{m} = ts_trimmed;
    TS_ARRAY = [TS_ARRAY ts_trimmed];
end

figure
hold on
for m=1:iter
plot(cumsum(TS_TR{m}),TS_TR{m},'o')
end
hold off
xlabel('Time since outbreak start (Day)')
ylabel('Inter-event time (Day)')
set(gca, 'fontsize', 15)

%edges = 0:round(max(TS_ARRAY));
edges = 0:0.1:5;
figure
histogram(TS_ARRAY,edges, 'Normalization', 'probability')
xlabel('Inter-event time (Day)')
ylabel('Fraction of Events')
set(gca, 'fontsize', 15)

ts_mean = mean(TS_ARRAY);
[ts_range, ts_half_int] = ConfidenceInterval(TS_ARRAY',ci);

%%
len = zeros(1,iter);
inada = zeros(1,iter);
for i=1:iter
len(i) = length(TS_TR{i});
inada(i) = sum(TS_TR{i} < 1);
end