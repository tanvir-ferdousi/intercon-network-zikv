clc
% SBeta -> TAU
% SM -> THETA
% v2hratio Same

%% Asymptomatic Relative Transmissibility Vs Host 2 Vect ratio
clear variables
FontS = 19;
load('theta_v2hratio.mat')
figure
contourf(THETA,V2Hratio,AR')
colormap jet
colorbar
caxis([0 1])
xlim([0 1])
ylim([1 10])
xlabel('Asymp. Rel. Trans.,\it \theta','Interpreter','tex')
ylabel('Vector-to-Host Ratio,\it {N_V} / {N_H}','Interpreter','tex')
title('Attack Rate,\it AR','Interpreter','tex')
set(gca, 'fontsize', FontS)

figure
contourf(THETA,V2Hratio,SS')
colormap jet
colorbar
caxis([40 100])
xlim([0 1])
ylim([1 10])
xlabel('Asymp. Rel. Trans.,\it \theta','Interpreter','tex')
ylabel('Vector-to-Host Ratio,\it {N_V} / {N_H}','Interpreter','tex')
title('Pathogen Survival,\it T_{PS}','Interpreter','tex')
set(gca, 'fontsize', FontS)

figure
contourf(THETA,V2Hratio,hostLastDayStoch')
colormap jet
colorbar
caxis([40 250])
xlim([0 1])
ylim([1 10])
xlabel('Asymp. Rel. Trans.,\it \theta','Interpreter','tex')
ylabel('Vector-to-Host Ratio,\it {N_V} / {N_H}','Interpreter','tex')
title('Host Inf. Length,\it T_{HL}','Interpreter','tex')
set(gca, 'fontsize', FontS)
%% Host 2 Vect ratio vs Proportion Asymptomatically Infected
clear variables
FontS = 20;
load('v2hratio_tau.mat')
figure
contourf(V2Hratio,TAU,AR')
colormap jet
colorbar
caxis([0 1])
xlim([1 10])
ylim([0.1 0.6])
xlabel('Vector-to-Host Ratio,\it {N_V} / {N_H}','Interpreter','tex')
ylabel('Prop. Symp. Infected,\it \tau ','Interpreter','tex')
title('Attack Rate,\it AR','Interpreter','tex')
set(gca, 'fontsize', FontS)

figure
contourf(V2Hratio,TAU,SS')
colormap jet
colorbar
caxis([40 100])
xlim([1 10])
ylim([0.1 0.6])
xlabel('Vector-to-Host Ratio,\it {N_V} / {N_H}','Interpreter','tex')
ylabel('Prop. Symp. Infected,\it \tau ','Interpreter','tex')
title('Pathogen Survival,\it T_{PS}','Interpreter','tex')
set(gca, 'fontsize', FontS)

figure
contourf(V2Hratio,TAU,hostLastDayStoch')
colormap jet
colorbar
caxis([40 250])
xlim([1 10])
ylim([0.1 0.6])
xlabel('Vector-to-Host Ratio,\it {N_V} / {N_H}','Interpreter','tex')
ylabel('Prop. Symp. Infected,\it \tau ','Interpreter','tex')
title('Host Inf. Length,\it T_{HL}','Interpreter','tex')
set(gca, 'fontsize', FontS)
%% Proportion Asymptomatically Infected vs Asymptomatic Relative Transmissibility
clear variables
FontS = 20;
load('tau_theta.mat')
figure
contourf(TAU,THETA,AR')
colormap jet
colorbar
caxis([0 1])
xlim([0.1 0.6])
ylim([0 1])
xlabel('Prop. Symp. Infected,\it \tau ','Interpreter','tex')
ylabel('Asymp. Rel. Trans.,\it \theta','Interpreter','tex')
title('Attack Rate,\it AR','Interpreter','tex')
set(gca, 'fontsize', FontS)

figure
contourf(TAU,THETA,SS')
colormap jet
colorbar
caxis([40 100])
xlim([0.1 0.6])
ylim([0 1])
xlabel('Prop. Symp. Infected,\it \tau ','Interpreter','tex')
ylabel('Asymp. Rel. Trans.,\it \theta','Interpreter','tex')
title('Pathogen Survival,\it T_{PS}','Interpreter','tex')
set(gca, 'fontsize', FontS)

figure
contourf(TAU,THETA,hostLastDayStoch')
colormap jet
colorbar
caxis([40 250])
xlim([0.1 0.6])
ylim([0 1])
xlabel('Prop. Symp. Infected,\it \tau ','Interpreter','tex')
ylabel('Asymp. Rel. Trans.,\it \theta','Interpreter','tex')
title('Host Inf. Length,\it T_{HL}','Interpreter','tex')
set(gca, 'fontsize', FontS)