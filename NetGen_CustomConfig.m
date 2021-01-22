% Tanvir Ferdousi
% Kansas State University
% Last Modified: Oct 2018
% Copyright (c) 2019, Tanvir Ferdousi. All rights reserved. 
% Redistribution and use in source and binary forms, with or without
% modification, are permitted

% Generates sexual contact network based on prescribed degree distribution, sexual orientation, and gender 

function [Net,avgAdultsDeg] = NetGen_CustomConfig(N,Pop,partnerClasses,avgDeg)
    % Generate the graph
    adults = find(Pop(:,2) == 2);
    %avgDeg = 1.28;
    bestErrorAvg = inf;
    iter = 1;
    while iter <= 10
        currA = customConfigurationNetwork(N,Pop,partnerClasses,avgDeg);
        K = sum(currA);
        avgAdultsDeg = mean(K(adults));
        
        errorAvg = abs(avgDeg- avgAdultsDeg)/avgDeg;
        
        if errorAvg < bestErrorAvg
            bestErrorAvg = errorAvg;
            A = currA;
        end
        iter = iter + 1;
    end
    
    K = sum(A);
    avgAdultsDeg = mean(K(adults));
    
    % Save the graph
    edgeList = edgeListGen(A);
    saveEdgeList('outputs/network/customConfigEdges.csv', edgeList);
    saveNodeList('outputs/network/customConfigNodes.csv', N, Pop);
    save('outputs/network/network.mat', 'A')
    
    [avgDegree, density] = computeNetworkMeasures(A);
    save('outputs/network/networkProperties.mat','avgDegree','density','avgAdultsDeg')
    
    % Format everything into GEMF compatible data
    adj = cell(1);
    adj{1} = sparse(A);
    adj{1} = adj{1} + adj{1}';
    d = sum(A)';
    
    Neigh = cell(1);
    [V, I1, I2] = NeighFromAdjMat(A);
    Neigh{1} = V;
    
    Net = {Neigh, I1, I2, d, adj};
end