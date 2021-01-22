% Tanvir Ferdousi
% Kansas State University
% Last Modified: Oct 2018
% Copyright (c) 2019, Tanvir Ferdousi. All rights reserved. 
% Redistribution and use in source and binary forms, with or without
% modification, are permitted

% Creates time series plots for outbreak dynamics
%% Stochastic Plots
figure
%plot(T,StateCount(StatesPlot,:)/NH, 'LineWidth', 2); hold on;
plot(T,StateCount(2,:)/NH,'LineWidth', 2,'color',[0.8500, 0.3250, 0.0980]);
hold on
plot(T,StateCount(3,:)/NH,'LineWidth', 2,'color',[0.9290, 0.6940, 0.1250]);
plot(T,StateCount(4,:)/NH,'LineWidth', 2,'color',[0.4940, 0.1840, 0.5560]);
plot(T,StateCount(5,:)/NH,'LineWidth', 2,'color',[0.4660, 0.6740, 0.1880]);
plot(T,StateCount(6,:)/NH,'LineWidth', 2,'color',[0.3010, 0.7450, 0.9330]);
legend('Exposed','Infected (S)','Infected (A)','Convalescent (S)','Convalescent (A)');
xlim([0 StopCond{2}])
ylim([0 0.2])
xlabel('Time (Day)')
ylabel('Fraction of human hosts')
%title('ZIKV infection dynamics in hosts')
set(gca, 'fontsize', 15)
hold off
box on
savefig('outputs/autosave/singleSim/stochHost')


% Special situation: dataEndMarker < Tend
 if dataEndMarker > Tend
    plotRange = 1:Tend+1;
    figure
    semilogy(TVec, MSus, 'LineWidth', 2)
    hold on
    semilogy(TVec, MExp, 'LineWidth', 2)
    semilogy(TVec, MInf, 'LineWidth', 2)
    hold off
    ylim([10^0 10^5])
    xlim([0 StopCond{2}])
    legend('Susceptible','Exposed','Infected');
    xlabel('Time (Day)')
    ylabel('Number of mosquito vectors')
    %title('ZIKV in')
    set(gca, 'fontsize', 15)
    box on
    savefig('outputs/autosave/singleSim/stochVect')
 else
    plotRange = 1:(dataEndMarker+1);
    noDataRange = dataEndMarker+2:Tend+1;
    figure
    semilogy(TVec(plotRange), MSus(plotRange), 'LineWidth', 2)
    hold on
    semilogy(TVec(plotRange), MExp(plotRange), 'LineWidth', 2)
    semilogy(TVec(plotRange), MInf(plotRange), 'LineWidth', 2)
    hold off
    ylim([10^0 10^5])
    xlim([0 StopCond{2}])
    legend('Susceptible','Exposed','Infected');
    xlabel('Time (Day)')
    ylabel('Number of mosquito vectors')
    %title('Stochastic solution of vector dynamics')
    set(gca, 'fontsize', 15)
    box on
    savefig('outputs/autosave/singleSim/stochVect')
 end
 

%% ODE Plots
figure
hold on;
for k=1:length(StatesPlot)
    plot(t,sum(X(:,StatesPlot(k):M:end),2)/NH,'linewidth',2);
end
xlim([0 Tend])
ylim([0 1])
%legend('Susceptible','Exposed','Infected','Recovered');
xlabel('Time (Day)')
ylabel('Fraction of human hosts')
%title('ODE solution of human host dynamics')
set(gca, 'fontsize', 15)
box on
hold off
savefig('outputs/autosave/odeHost')

figure
semilogy(t,Y(:,1),'LineWidth', 2)
%plot(t,Y(:,1),'LineWidth', 2)
hold on
semilogy(t,Y(:,2),'LineWidth', 2)
semilogy(t,Y(:,3),'LineWidth', 2)
%plot(t,Y(:,2),'LineWidth', 2)
%plot(t,Y(:,3),'LineWidth', 2)
hold off
xlim([0 Tend])
ylim([10^0 10^5])
%legend('Susceptible','Exposed','Infected');
xlabel('Time (Day)')
ylabel('Number of mosquito vectors')
%title('ODE solution of vector dynamics')
set(gca, 'fontsize', 15)
box on
savefig('outputs/autosave/odeVect')