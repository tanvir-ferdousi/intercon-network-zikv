% Tanvir Ferdousi
% Kansas State University
% Last Modified: Oct 2018
% Copyright (c) 2019, Tanvir Ferdousi. All rights reserved. 
% Redistribution and use in source and binary forms, with or without
% modification, are permitted

% Runs simulations for a range of different parameters (one at a time)

clear; clc
%% Initial Setup
% Define the scanning parameter and its value range


% 1: Theta scan
% 2. Mu scan
% 3: Beta scan
% 4: tau scan (0.10 ~ 0.60)
% 5: Start month scan (9:12, 1:4)

simType = 3; 

if simType == 1
    THETA = 0:0.1:1;
    scanLen = length(THETA);
elseif simType == 2
    MU = 0:0.1:1;
    scanLen = length(MU);
elseif simType == 3
    SBeta = linspace(0,0.0175,10);
    scanLen = length(SBeta);
elseif simType == 4
    TAU = 0.10:0.10:0.60;
    scanLen = length(TAU);
elseif simType == 5
    %SM = [9:12 1:4];
    SM = 5:8;
    scanLen = length(SM);
end


% Variables
PROPS = zeros(scanLen,4);
PROP_HCONF = zeros(scanLen,4);

for paraIndex=1:scanLen

fprintf('Para-scan iteration: %d ',paraIndex)
if simType == 1
    fprintf('Parameter value, THETA: %.2f \n', THETA(paraIndex))
elseif simType == 2
    fprintf('Parameter value, MU: %.2f \n', MU(paraIndex))
elseif simType == 3
    fprintf('Parameter value, beta: %.4f \n', SBeta(paraIndex))
elseif simType == 4
    fprintf('Parameter value, tau: %.2f \n', TAU(paraIndex))
elseif simType == 5
    fprintf('Parameter value, SM: %d \n', SM(paraIndex))
end

    
% Human host parameters
NH = 1e3;

%Network

load('outputs/network/population.mat')
Net = NetLoad('outputs/network/network.mat');
disp('Network load complete!')

% Mosquito vector parameters
NV = 5e3;          % Total number of mosquitos
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

% Host to host sexual transmission rate
if simType == 3
    beta = SBeta(paraIndex);
else
    beta = 0.0087;
end

if simType == 4
    tau = TAU(paraIndex);
else
    tau = 0.2;           % Proportion of symptomatically infected individuals
end

gamma1 = 1/7;       % Transition rate from infectious to convalescent state
gamma2 = 1/30;      % Transition rate from convalescent state to recovered state (Turmel et al., 2016)

if simType == 1
    theta = THETA(paraIndex);
else
    theta = 0.5;        % Relative sexual transmissibility in asymptomatic state
end

if simType == 2
    mu = MU(paraIndex);
else
    mu = 0.5;           % Relative sexual transmissibility in convalescent state
end




% Simulation Parameter
if simType == 5
    startMonth = SM(paraIndex);
else
    startMonth = 11;
end
startLoc = 1;                                   % Simulation location: 1 for Miami, 2 for Phoenix

Tend = 300;                                     % Simulation end time
iter = 500;                                      % Number of stochastic realizations
ci = 0.95;                                      % Confidence interval


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
fprintf('Para-scan iteration: %d/%d, stochastic iteration: %d/%d, time: %.4f \n',paraIndex,scanLen,m,iter, iterTime)

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

% Avg of AR, THL, TVL, TPS with the half of the conf. interval
[avg_props, props_half_int] = computeOutPropAvg(HOST_PROP, VECT_PROP, ci);

%% compute survival
PROPS(paraIndex,:) = avg_props;
PROP_HCONF(paraIndex,:) = props_half_int;

end

%% Store survival data
if simType == 1
    save('outputs/autosave/paramScan/survival/theta.mat','THETA', 'PROPS', 'PROP_HCONF')
elseif simType == 2
    save('outputs/autosave/paramScan/survival/mu.mat','MU', 'PROPS', 'PROP_HCONF')
elseif simType == 3
    save('outputs/autosave/paramScan/survival/beta_sexual.mat','SBeta', 'PROPS', 'PROP_HCONF')
elseif simType == 4
    save('outputs/autosave/paramScan/survival/tau.mat','TAU', 'PROPS', 'PROP_HCONF')
elseif simType == 5
    save('outputs/autosave/paramScan/survival/sm.mat','SM', 'PROPS', 'PROP_HCONF')
end

%save('outputs/autosave/paramScan/survival/workspace')