% Tanvir Ferdousi
% Kansas State University
% Last Modified: Oct 2018
% Copyright (c) 2019, Tanvir Ferdousi. All rights reserved. 
% Redistribution and use in source and binary forms, with or without
% modification, are permitted

% Creates time series plots with confidence intervals for outbreak dynamics
lower = zeros(M,Tend+1);
upper = zeros(M,Tend+1);
for m=1:M
    for d=1:Tend+1
        lower(m,d) = CIH(1,m,d);
        upper(m,d) = CIH(2,m,d);
    end
end

%col = ['g', 'y', 'r', 'b'];
cap = {'Susceptible'; 'Exposed'; 'Infected (S)'; 'Infected (A)'; 'Convalescent (S)'; 'Convalescent (A)'; 'Recovered'};

for m=1:M
    figure
    ciplot(lower(m,:)/NH, upper(m,:)/NH, T,'k')
    alpha(0.1)
    hold on
    plot(T,StateCount(m,:)/NH, 'k','LineWidth', 1.5)
    ylim([0 max(upper(m,:)/NH)+0.01])
    xlim([0 Tend])
    xlabel('Time (Day)')
    ylbl = sprintf('Fraction of %s',cap{m});
    ylabel(ylbl)
    tt = sprintf('%s host population',cap{m});
    %title(tt)
    set(gca, 'fontsize', 15)
    hold off
    box on
    filePath = sprintf('outputs/autosave/singleSim/ciplots/host/%s',cap{m});
    savefig(filePath)
end



% Plot stochastic vector data
MV = 3;
lower = zeros(MV,Tend+1);
upper = zeros(MV,Tend+1);
for m=1:MV
    for d=1:Tend+1
        lower(m,d) = CIV(1,m,d);
        upper(m,d) = CIV(2,m,d);
    end
end

%col = ['g','r'];
cap = {'Susceptible';'Exposed';'Infected'};

for m=1:MV
    figure
    ciplot(lower(m,plotRange), upper(m,plotRange), TVec(plotRange),'k')
    alpha(0.1)
    hold on
    plot(TVec(plotRange),StateCountV(m,plotRange),'k','LineWidth', 1.5)
    ylim([0 max(upper(m,:))+0.01])
    xlim([0 Tend])
    xlabel('Time (Day)')
    ylbl = sprintf('Number of %s',cap{m});
    ylabel(ylbl)
    tt = sprintf('%s vector population',cap{m});
    %title(tt)
    set(gca, 'fontsize', 15)
    hold off
    box on
    filePath = sprintf('outputs/autosave/singleSim/ciplots/vect/%s',cap{m});
    savefig(filePath)
end