% Tanvir Ferdousi
% Kansas State University
% Last Modified: Aug 2018
% Copyright (c) 2019, Tanvir Ferdousi. All rights reserved. 
% Redistribution and use in source and binary forms, with or without
% modification, are permitted

% Generates random population based on prescribed gender, age and sexual orientation
function Pop = PopGen(NH, maleRatio, ageGroupRatio, sexOrientation)
    % Sex
    % 1: Male, 2: Female
    
    % Age Group
    % 1: Children, 2: Adults, 3: Elderly
    
    % Sexual Orientation
    % 1: Heterosexual, 2: Bisexual, 3: Homosexual
    
    % Pop(n,1): Gender
    % Pop(n,2): Age Group
    % Pop(n,3): Sexual Orientation
    
    NChar = 3;
    Pop = zeros(NH, NChar);
    
    cumAgeGroupRatio = cumsum(ageGroupRatio);
    cumSexOrientation = cumsum(sexOrientation,2);
    
    for n=1:NH
        r = rand;
        if r <= maleRatio
            % It's a boy!
            Pop(n,1) = 1;
        else
            Pop(n,1) = 2;
        end
        
        r = rand;
        typeIndices = find(r <= cumAgeGroupRatio);
        typeIndex = typeIndices(1);
        Pop(n,2) = typeIndex;
        
        r = rand;
        orientIndices = find(r <= cumSexOrientation(Pop(n,1),:));
        orientIndex = orientIndices(1);
        Pop(n,3) = orientIndex;
    end
    
    
end