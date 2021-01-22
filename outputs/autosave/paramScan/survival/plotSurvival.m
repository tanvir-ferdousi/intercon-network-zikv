%% Load Data

LineW = 1.5;
FontS = 19;

AR_RANGE = [0 0.5];
TPS_RANGE = [30 100];
THL_RANGE = [50 200];
%% Theta
clear PROPS
clear PROP_HCONF
load('theta.mat')

figure
di = 1;
ciplot(PROPS(:,di)-PROP_HCONF(:,di),PROPS(:,di)+PROP_HCONF(:,di),THETA, 'k')
alpha(0.2)
hold on
plot(THETA,PROPS(:,di),':s','LineWidth',LineW)
%xlim([0 1])
ylim(AR_RANGE)
xlabel('Asymp. Rel. Transmissibility,\it \theta','Interpreter','tex')
ylabel('Attack Rate,\it AR','Interpreter','tex')
set(gca, 'fontsize', FontS)
hold off

figure
di = 4;
ciplot(PROPS(:,di)-PROP_HCONF(:,di),PROPS(:,di)+PROP_HCONF(:,di),THETA, 'k')
alpha(0.2)
hold on
plot(THETA,PROPS(:,di),':s','LineWidth',LineW)
%xlim([1 5])
ylim(TPS_RANGE)
xlabel('Asymp. Rel. Transmissibility,\it \theta','Interpreter','tex')
ylabel('Pathogen Survival,\it T_{PS}','Interpreter','tex')
set(gca, 'fontsize', FontS)
hold off


figure
di = 2;
ciplot(PROPS(:,di)-PROP_HCONF(:,di),PROPS(:,di)+PROP_HCONF(:,di),THETA, 'k')
alpha(0.2)
hold on
plot(THETA,PROPS(:,di),':s','LineWidth',LineW)
%xlim([1 5])
ylim(THL_RANGE)
xlabel('Asymp. Rel. Transmissibility,\it \theta','Interpreter','tex')
ylabel('Host Infection Length,\it T_{HL}','Interpreter','tex')
set(gca, 'fontsize', FontS)
hold off


%% Mu
clear PROPS
clear PROP_HCONF
load('mu.mat')

figure
di = 1;
ciplot(PROPS(:,di)-PROP_HCONF(:,di),PROPS(:,di)+PROP_HCONF(:,di),MU, 'k')
alpha(0.2)
hold on
plot(MU,PROPS(:,di),':s','LineWidth',LineW)
%xlim([1 12])
ylim(AR_RANGE)
xlabel('Conv. Rel. Transmissibility,\it \mu','Interpreter','tex')
ylabel('Attack Rate,\it AR','Interpreter','tex')
set(gca, 'fontsize', FontS)
hold off

figure
di = 4;
ciplot(PROPS(:,di)-PROP_HCONF(:,di),PROPS(:,di)+PROP_HCONF(:,di),MU, 'k')
alpha(0.2)
hold on
plot(MU,PROPS(:,di),':s','LineWidth',LineW)
%xlim([1 12])
ylim(TPS_RANGE)
xlabel('Conv. Rel. Transmissibility,\it \mu','Interpreter','tex')
ylabel('Pathogen Survival,\it T_{PS}','Interpreter','tex')
set(gca, 'fontsize', FontS)
hold off

figure
di = 2;
ciplot(PROPS(:,di)-PROP_HCONF(:,di),PROPS(:,di)+PROP_HCONF(:,di),MU, 'k')
alpha(0.2)
hold on
plot(MU,PROPS(:,di),':s','LineWidth',LineW)
%xlim([1 12])
ylim(THL_RANGE)
xlabel('Conv. Rel. Transmissibility,\it \mu','Interpreter','tex')
ylabel('Host Infection Length,\it T_{HL}','Interpreter','tex')
set(gca, 'fontsize', FontS)
hold off


%% Beta
clear PROPS
clear PROP_HCONF
load('beta_sexual.mat')

figure
di = 1;
ciplot(PROPS(:,di)-PROP_HCONF(:,di),PROPS(:,di)+PROP_HCONF(:,di),SBeta, 'k')
alpha(0.2)
hold on
plot(SBeta,PROPS(:,di),':s','LineWidth',LineW)
xlim([0 0.0175])
ylim(AR_RANGE)
xlabel('Sexual Transmission Rate,\it \beta ','Interpreter','tex')
ylabel('Attack Rate,\it AR','Interpreter','tex')
set(gca, 'fontsize', FontS)
hold off

figure
di = 4;
ciplot(PROPS(:,di)-PROP_HCONF(:,di),PROPS(:,di)+PROP_HCONF(:,di),SBeta, 'k')
alpha(0.2)
hold on
plot(SBeta,PROPS(:,di),':s','LineWidth',LineW)
xlim([0 0.0175])
ylim(TPS_RANGE)
xlabel('Sexual Transmission Rate,\it \beta ','Interpreter','tex')
ylabel('Pathogen Survival,\it T_{PS}','Interpreter','tex')
set(gca, 'fontsize', FontS)
hold off


figure
di = 2;
ciplot(PROPS(:,di)-PROP_HCONF(:,di),PROPS(:,di)+PROP_HCONF(:,di),SBeta, 'k')
alpha(0.2)
hold on
plot(SBeta,PROPS(:,di),':s','LineWidth',LineW)
xlim([0 0.0175])
ylim(THL_RANGE)
xlabel('Sexual Transmission Rate,\it \beta ','Interpreter','tex')
ylabel('Host Infection Length,\it T_{HL}','Interpreter','tex')
set(gca, 'fontsize', FontS)
hold off


%% TAU
clear PROPS
clear PROP_HCONF
load('tau.mat')


figure
di = 1;
ciplot(PROPS(:,di)-PROP_HCONF(:,di),PROPS(:,di)+PROP_HCONF(:,di),TAU, 'k')
alpha(0.2)
hold on
plot(TAU,PROPS(:,di),':s','LineWidth',LineW)
xlim([0.1 0.6])
ylim(AR_RANGE)
xticklabels({'0.1','','0.2','','0.3','','0.4','','0.5','','0.6'})
xlabel('Prop. Symp. Infected,\it \tau','Interpreter','tex')
ylabel('Attack Rate,\it AR','Interpreter','tex')
set(gca, 'fontsize', FontS)

figure
di = 4;
ciplot(PROPS(:,di)-PROP_HCONF(:,di),PROPS(:,di)+PROP_HCONF(:,di),TAU, 'k')
alpha(0.2)
hold on
plot(TAU,PROPS(:,di),':s','LineWidth',LineW)
xlim([0.1 0.6])
ylim(TPS_RANGE)
xticklabels({'0.1','','0.2','','0.3','','0.4','','0.5','','0.6'})
xlabel('Prop. Symp. Infected,\it \tau','Interpreter','tex')
ylabel('Pathogen Survival,\it T_{PS}','Interpreter','tex')
set(gca, 'fontsize', FontS)

figure
di = 2;
ciplot(PROPS(:,di)-PROP_HCONF(:,di),PROPS(:,di)+PROP_HCONF(:,di),TAU, 'k')
alpha(0.2)
hold on
plot(TAU,PROPS(:,di),':s','LineWidth',LineW)
xlim([0.1 0.6])
ylim(THL_RANGE)
xticklabels({'0.1','','0.2','','0.3','','0.4','','0.5','','0.6'})
xlabel('Prop. Symp. Infected,\it \tau','Interpreter','tex')
ylabel('Host Infection Length,\it T_{HL}','Interpreter','tex')
set(gca, 'fontsize', FontS)


% %% Start Month
% clear
% LineW = 1.5;
% FontS = 19;
% M = load('sm.mat');
% 
% figure
% plot(M.SM,M.AR,':s','LineWidth',LineW)
% xlim([1 12])
% %ylim([0 0.5])
% xlabel('Pathogen Introduction,\it M_{Start}','Interpreter','tex')
% %xticklabels({'Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec',})
% %xtickangle(90)
% ylabel('Epidemic Attack Rate,\it AR','Interpreter','tex')
% set(gca, 'fontsize', FontS)
% 
% figure
% plot(M.SM,M.SS,':s','LineWidth',LineW)
% xlim([1 12])
% %ylim([50 120])
% xlabel('Pathogen Introduction,\it M_{Start}','Interpreter','tex')
% %xticklabels({'Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec',})
% %xtickangle(90)
% ylabel('Pathogen Survival,\it T_{PS}','Interpreter','tex')
% set(gca, 'fontsize', FontS)
% 
% figure
% plot(M.SM,M.hostLastDayStoch,':s','LineWidth',LineW)
% xlim([1 12])
% %ylim([100 250])
% xlabel('Pathogen Introduction,\it M_{Start}','Interpreter','tex')
% %xticklabels({'Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec',})
% %xtickangle(90)
% ylabel('Host Infection Length,\it T_{HL}','Interpreter','tex')
% set(gca, 'fontsize', FontS)