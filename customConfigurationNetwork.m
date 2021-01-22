% Tanvir Ferdousi
% Kansas State University
% Last Modified: September 2018
% Copyright (c) 2019, Tanvir Ferdousi. All rights reserved. 
% Redistribution and use in source and binary forms, with or without
% modification, are permitted

% Generates a custom configuration network based on prescribed degree sequence
function A = customConfigurationNetwork(N,Pop,partnerClasses,avgDeg)
    
    %avgDeg = 1.28;
    %totDeg = avgDeg*N;
    
    males = find(Pop(:,1) == 1);
    females = find(Pop(:,1) == 2);
    straights = find(Pop(:,3) == 1);
    bisexuals = find(Pop(:,3) == 2);
    gays = find(Pop(:,3) == 3);
    adults = find(Pop(:,2) == 2);
    
    % Assign node degree
    cumPartnerClasses = cumsum(partnerClasses);
    K = zeros(N,1);
    
    %bestK = K;
    iter = 1;
    bestErrorAvg = inf;
    
    while iter <= 100
        % Run 100 iterations, make generated avgDegree as close to given avgDegree.
        for i=1:N
            
            if Pop(i,2) ~= 2
                K(i) = 0;
                continue;
            end
            
            r = rand;
            partnerClassIndices = find(r <= cumPartnerClasses);
            degreeClass = partnerClassIndices(1);

            switch degreeClass
                case 1
                    K(i) = 0;
                case 2
                    K(i) = 1;
                case 3
                    K(i) = 2;
                case 4
                    K(i) = 3;
                case 5
                    K(i) = 4;
                case 6
                    % 5 - 9
                    K(i) = round((9-5)*rand + 5);
                case 7
                    % 10 -19
                    K(i) = round((19-10)*rand + 10);
                case 8
                    % 20+
                    K(i) = round((50-20)*rand + 20);
            end

        end

        % Adjust, make degree even
        if mod(sum(K),2) == 1
            [m,i] = max(K);
            K(i) = K(i)+1;
        end
        
        genAvgDeg = mean(K(adults));
        
        errorAvg = abs(avgDeg - genAvgDeg)/avgDeg;
        
        if errorAvg < bestErrorAvg
            bestErrorAvg = errorAvg;
            bestK = K;
        end
        
        iter = iter + 1;
    end
    
    K = bestK;
    
    
    
    iter = 1;
    bestErrorAvg = inf;
    while iter < 10
        % Join the stubs uniformly random
        currK = K;
        nEdge = 0.7*sum(K);
        currA = zeros(N,N);

        % Sort the nodes according to degree
        % pick the highest degree node
        % pick randomly from the lowest degree node (gender constrained)


        for edge = 1:nEdge
            %edge
            [B, I] = sort(currK,'descend');
            n1 = I(1);

            n1Gender = Pop(n1,1);     % 1: male, 2: female
            sexOrientation = Pop(n1,3);     % 1: straight, 2: bi, 3: gay

            availablePops = find(currK > 0);
            if sexOrientation == 1
                % Find an opposite gender
                if n1Gender == 1
                    % Find a straight/bi female
                    feasiblePops = intersect(union(straights,bisexuals),females);
                else
                    % Find a straight/bi male
                    feasiblePops = intersect(union(straights,bisexuals),males);
                end
            elseif sexOrientation == 2
                % Either gender would work
                if n1Gender == 1
                    % Bisexual male: find a straight female, or gay male or
                    % another bisexual
                    feasiblePops = union(union(intersect(straights,females),intersect(gays,males)),bisexuals);
                else
                    % Bisexual female: find a straight male, or gay female or
                    % another bisexual
                    feasiblePops = union(union(intersect(straights,males),intersect(gays,females)),bisexuals);
                end
            else
                % Find the same gender
                if n1Gender == 1
                    % find a gay or bisexual male
                    feasiblePops = intersect(union(gays,bisexuals),males);
                else
                    % find a gay or bisexual female
                    feasiblePops = intersect(union(gays,bisexuals),females);
                end
            end

            choicePool = intersect(availablePops,feasiblePops);

            if isempty(choicePool)
                %disp('Choice pool empty')
                continue;
            end
            n2 = datasample(choicePool,1);

            currA(n1,n2) = 1;
            currA(n2,n1) = 1;
            currK(n1) = currK(n1) - 1;
            currK(n2) = currK(n2) - 1;
        end

        k_new = sum(currA);
        errorAvg = abs(avgDeg- mean(k_new(adults)))/avgDeg;
        
        if errorAvg < bestErrorAvg
            bestErrorAvg = errorAvg;
            bestA = currA;
        end
        
        iter = iter + 1;
    end
    A = bestA;
end