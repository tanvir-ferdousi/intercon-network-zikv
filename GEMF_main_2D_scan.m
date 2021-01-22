% Tanvir Ferdousi
% Kansas State University
% Last Modified: Oct 2018
% Copyright (c) 2019, Tanvir Ferdousi. All rights reserved. 
% Redistribution and use in source and binary forms, with or without
% modification, are permitted

% Runs simulations for a range of different parameters (a pair at a time)

clear; clc
%% Initial Setup
% Define the scanning parameter and its value range

% 1: Tau vs Theta scan
% 2: Nv/Nh vs Tau scan
% 3: Theta vs Nv/Nh scan

simType = 3;

startLoc = 1;                                   % Simulation location: 1 for Miami, 2 for Phoenix
Tend = 300;                                     % Simulation end time
iter = 500;                                     % Number of stochastic realizations
ci = 0.95;                                      % Confidence interval


TAURange = 0.10:0.10:0.60;
THETARange = 0:0.1:1;
V2HratioRange = 1:10;



if simType == 1
    TAU = TAURange;
    THETA = THETARange;
    scanLenX = length(TAU);
    scanLenY = length(THETA);
elseif simType == 2
    V2Hratio = V2HratioRange;
    TAU = TAURange;
    scanLenX = length(V2Hratio);
    scanLenY = length(TAU);
elseif simType == 3
    THETA = THETARange;
    V2Hratio = V2HratioRange;
    scanLenX = length(THETA);
    scanLenY = length(V2Hratio);
end

% Variables
AR = zeros(scanLenX,scanLenY);
SS = zeros(scanLenX,scanLenY);
DS = zeros(scanLenX,scanLenY);
hostLastDayStoch = zeros(scanLenX,scanLenY);
hostLastDay = zeros(scanLenX,scanLenY);



for paraIndX=1:scanLenX
for paraIndY=1:scanLenY

fprintf('2D Para-scan iteration: %d,%d ',paraIndX,paraIndY)
if simType == 1
    fprintf('Parameter value, tau: %1.2f, theta: %1.2f \n', TAU(paraIndX), THETA(paraIndY))
elseif simType == 2
    fprintf('Parameter value, Nv/Nh: %d, tau: %.4f \n', V2Hratio(paraIndX), TAU(paraIndY))
elseif simType == 3
    fprintf('Parameter value, theta: %1.2f, Nv/Nh: %d \n', THETA(paraIndX), V2Hratio(paraIndY))
end

    
% Human host parameters
NH = 1e3;

%Network
load('outputs/network/population.mat')
Net = NetLoad('outputs/network/network.mat');
disp('Network load complete!')

% Mosquito vector parameters
% Total number of mosquitos
if simType == 2
    NV = NH*V2Hratio(paraIndX);
elseif simType == 3
    NV = NH*V2Hratio(paraIndY);
else
    NV = 5e3;
end

Yi0 = 1;           % Total number of infected mosquitos
Ys0 = NV-Yi0;      % Total number of susceptible mosquitos
Ye0 = 0;           % Total number of exposed mosquitos
e1 = 1/12;          % Susceptible mosquito mortality rate
e2 = e1;          % Infected mosquito mortality rate
F = 1/12;           % Mosquito birth rate per capita
b = 0.63;          % Bites per unit time (day) by one mosquito
r=b/NH;            % Bites per person per unit time (day) by one mosquito

% Disease parameters
T_VH = 0.770;                % Host to Vector transmission probability
T_HV = 0.634;                % Vector to Host transmission probability
lambdaVH = r*T_VH;           % Host to Vector transmission rate
lambdaHV = r*T_HV;           % Vector to Host transmission rate
delta=1/7;                   % Intrinsic Incubation rate in human hosts
sigma = 1/8;                 % Extrinsic Incubation rate in mosquito vectors
mu = 0.5;                    % Relative sexual transmissibility in convalescent state
beta = 0.0087;               % Host to host sexual transmission rate

if simType == 1
    tau = TAU(paraIndX);
elseif simType == 2
    tau = TAU(paraIndY);
else
    tau = 0.2;
end
                 
gamma1 = 1/7;       % Transition rate from infectious to convalescent state
gamma2 = 1/30;      % Transition rate from convalescent state to recovered state (Turmel et al., 2016)

% Simulation Parameter
% Relative transmissibility in asymptomatic state
if simType == 3
    theta = THETA(paraIndX);
elseif simType == 1
    theta = THETA(paraIndY);
else
    theta = 0.5;
end

% simulation start month
startMonth = 4;


% Structurization of parameters & initial conditions
Para=Para_SEIJR(lambdaHV, Yi0, delta, tau, beta, gamma1, gamma2, theta, mu);
M=Para{1};
ParaVector = Para_Vect(NV, Yi0, F, e1, e2, sigma, lambdaVH, lambdaHV, startMonth, startLoc);
x0=Initial_Cond_Gen(NH,'Population',[3 4 5 6],[0 0 0 0]);
StatesPlot=[1, 2, 3, 4, 5, 6, 7];


%% Stochastic

% StopCond={'EventNumber',15000};
StopCond={'RunTime',Tend};

StateCountCell = cell(1,iter);
TCell = cell(1,iter);
MSusCell = cell(1,iter);
MExpCell = cell(1,iter);
MInfCell = cell(1,iter);
TVecCell = cell(1,iter);
for m=1:iter

    tic
    [ts,n_index,i_index,j_index, MSusCell{m}, MExpCell{m}, MInfCell{m}, TVecCell{m}]=GEMF_COUPLED_SIM(Para,ParaVector,Net,Pop,x0,StopCond);
    iterTime = toc;
    fprintf('2D Para-scan iteration: X: %d/%d, Y: %d/%d, stochastic iteration: %d/%d, time: %.4f \n',paraIndX,scanLenX,paraIndY,scanLenY,m,iter,iterTime)

    % Post Processing
    [TCell{m}, StateCountCell{m}]=Post_Population(x0,M,NH,ts,i_index,j_index);

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


[avg_props, props_half_int] = computeOutPropAvg(HOST_PROP, VECT_PROP, ci);

%% compute survival

% Attack Rate
AR(paraIndX, paraIndY) = avg_props(1);

hostLastDayStoch(paraIndX, paraIndY) = avg_props(2);

SS(paraIndX, paraIndY) = avg_props(4);

end
end

%% Store survival data
if simType == 1
    save('outputs/autosave/paramScan/2d/tau_theta.mat','TAU', 'THETA', 'AR', 'SS', 'hostLastDayStoch')
elseif simType == 2
    save('outputs/autosave/paramScan/2d/v2hratio_tau.mat','V2Hratio', 'TAU', 'AR', 'SS', 'hostLastDayStoch')
elseif simType == 3
    save('outputs/autosave/paramScan/2d/theta_v2hratio.mat','THETA','V2Hratio', 'AR', 'SS', 'hostLastDayStoch')
end


%save('outputs/autosave/paramScan/2d/workspace')