% Numerical stochastic simulation of GEMF
% Faryad Darabi Sahneh
% Kansas State University
% Last Modified: Sep 2013
% Copyright (c) 2013, Faryad Darabi Sahneh. All rights reserved. 
% Redistribution and use in source and binary forms, with or without
% modification, are permitted

% Last Modified: Oct 2018
% Tanvir Ferdousi
% Kansas State University
% Supports interconnected vector borne transmission model, variable parameters, conditional transitions
function [ts,n_index,i_index,j_index, MSus, MExp, MInf, Tvec]=GEMF_COUPLED_SIM(Para,ParaVector,Net,Pop,x0,StopCond)

% Host & network parameters
M=Para{1}; q=Para{2}; L=Para{3}; A_d=Para{4}; A_b=Para{5}; theta=Para{6};
mu=Para{7};

Neigh=Net{1}; I1=Net{2}; I2=Net{3}; N=length(I1);

% Vector parameters
NV = ParaVector{1}; Yi0 = ParaVector{2}; F = ParaVector{3};
e1 = ParaVector{4}; e2 = ParaVector{5}; sigma = ParaVector{6};
lambdaVH = ParaVector{7}; lambdaHV = ParaVector{8};
startMonth = ParaVector{9}; startLoc = ParaVector{10};
Ys0 = NV-Yi0;
Ye0 = 0;

% Variables for vector
MSus = [];
MExp = [];
MInf = [];
Tvec = [];

bil=zeros(M,L);
for l=1:L
    bil(:,l)=sum(A_b(:,:,l),2);
end
% bil is a column vector of size M x 1. Each element indicates the total edge-based transition rate out of
% that particular state

bi=cell(1,M);
for i=1:M
    temp=[];
    for l=1:L
        temp=[temp,squeeze(A_b(i,:,l))'];
    end;
    bi{i}=temp;
end;

% bi is a 1 x M sized cell of M x 1 Column vector. Each element of the ith column indicates the 
% edge-based transition rate from ith state to the corresponding state.

X0=zeros(M,N);
for i=1:N
    X0(x0(i),i)=1;
end;
X=X0;

% x0 is a 1 x N vecter with each element indicating the particular host
% state. The values can be any of 1:M.
% X0 is a M x N vector where each column indicates state of the host.
% The values can be 1 and 0.

C_AM = zeros(1,N);
C_NAM = zeros(1,N);

for n=1:N
    if Pop(n,1) == 1 && Pop(n,2) == 2
        C_AM(n) = 1;
    else
        C_NAM(n) = 1;
    end
end


    
szq = size(q);
influencerCount = szq(2);

% Finding Nq (L by N) matrix. Neighbors must be adult male, n must be adult
Nq=zeros(influencerCount,N,L);
for n=1:N
    for l=1:L
        if I1(l,n) == 0 || I2(l,n) == 0     % No neighbors
            %disp('no neighbors')
            continue;
        end

        if Pop(n,2) ~= 2    % Ensuring that n is an adult
            %disp('n not adult')
            continue;
        end

        Nln=Neigh{l}(I1(l,n):I2(l,n));
        neighPop = Pop(Nln,:);
        NlnFlag = zeros(1,length(Nln));

        for pop_i = 1:length(Nln)   % Ensuring that neighbors are adult male
            if neighPop(pop_i,1) == 1 && neighPop(pop_i,2) == 2
                NlnFlag(pop_i) = 1;
            end
        end

        Nln(NlnFlag == 0) = [];

        if isempty(Nln)
            %disp('no adult male neighbor')
            continue;
        end

        for i=1:influencerCount
            Nq(i,n,l)=sum(X(q(l,i),Nln));   % Number of type i influencer neighbors of node n
        end
    end
end


EventNum=StopCond{2};
RunTime=StopCond{2};

s=0; Tf=0;

while Tf < RunTime %number of events
    s=s+1;

    
    %di=sum(A_d,2); 
    di = conditioned_sum(A_d, sum(C_AM), sum(C_NAM), N);  % Column vector, element i is the node based transition rate out of state i

    % Rates
    % Rate of edge transition of each node out of a state due to state q(l,2)
    
    Rnode = zeros(1,N);
    for n=1:N
        Rnode(n) = di(X(:,n)==1);
    end
    
    %Rnode=  di*ones(1,N);
    Redge = bil*Nq(1,:).*X + theta*bil*Nq(2,:).*X + mu*bil*Nq(3,:).*X + mu*theta*bil*Nq(4,:).*X;
    
    %Rin=di*ones(1,N).*X+bil*Nq.*X;      % Enter the conditions here
    Rin = Rnode + sum(Redge,1);
    %Ri=sum(Rin,2);
    R=sum(Rin);
    
    % Rin(M,N) matrix. each nonzero element (i,j) indicates if a node j is in compartment i, the
    % probability/rate of leaving that compartment equal to the value of that element.
    % Ri(M,1) column vector summed over all nodes: each element is the
    % total rate of transition out of that compartment. R is the total
    % transition rate

    if R<1e-6
        break;
    end;

    % Event Occurance
    ts(s)=-log(rand)/R;
    
    ns = rnd_draw(Rin);
    is = find(X(:,ns) == 1);
    %is=rnd_draw(Ri);    % Choose one event with nonzero rate to occur (event: leaving a particular compartment)
    %ns=rnd_draw(Rin(is,:).*X(is,:)); % only those which are is. Choose one node to do that event.
    
    A_d_con = condition_node_trans(A_d,is,C_AM(ns));   % The conditional rate of reaching a particular future state
    bi_con = bi{is}*(Nq(1,ns)+theta*Nq(2,ns)+mu*(Nq(3,ns)+theta*Nq(4,ns)));
    %js=rnd_draw(A_d(is,:)'+bi{is}*Nq(:,ns));    % Apply condition
    js=rnd_draw(A_d_con'+bi_con);   % Find the next state of the chosen node ns.
    
    % Node ns transitions from state is to state js.

    n_index(s)=ns;
    j_index(s)=js;
    i_index(s)=is;

    % Updateing
    % Update State: is: from, js: to, ns: node0
    X(is,ns)=0; X(js,ns)=1;
    
    % ns has changed state from is to js. Has it become an influencer? Or changed influencer type?
    % ns must be adult male. neighbors must be adult
    if js >= 3
        if Pop(ns,1) == 1 && Pop(ns,2) == 2
            % ns is an adult male
            % Check the neighbors
            if I1(1,ns) == 0 || I2(1,ns) == 0     % No neighbors
                
            else
                Nln=Neigh{1}(I1(1,ns):I2(1,ns));
                neighPop = Pop(Nln,:);
                NlnFlag = zeros(1,length(Nln));

                for pop_i = 1:length(Nln)   % Ensuring that neighbors are adult
                    if neighPop(pop_i,2) == 2
                        NlnFlag(pop_i) = 1;
                    end
                end

                Nln(NlnFlag == 0) = [];

                oType = is-2;
                nType = js-2;

                if ~isempty(Nln)
                    % There are adult neighbors
                    neiCount = length(Nln);

                    if nType >= 1 && nType <= 2
                        for i=1:neiCount
                            Nq(nType,Nln(i),1) = Nq(nType,Nln(i),1)+1;
                        end
                    elseif nType >= 3 && nType <= 4
                        for i=1:neiCount
                            Nq(nType,Nln(i),1) = Nq(nType,Nln(i),1)+1;
                            Nq(oType,Nln(i),1) = Nq(oType,Nln(i),1)-1;
                        end
                    elseif nType == 5
                        for i=1:neiCount
                            Nq(oType,Nln(i),1) = Nq(oType,Nln(i),1)-1;
                        end
                    end
                end
            end
        end
    end
    
    % Update vector population
    IH = sum(X(q(1),:) == 1) + theta*sum(X(q(2),:) == 1);
    
    %abundanceFactor = seasonalVar(Tf, startMonth);
    [Ys, Ye, Yi, t] = vector_sim(lambdaVH, IH, F, e1, e2, sigma, Ys0, Ye0, Yi0, ts(s), Tf, startMonth, startLoc);
    % Initial condition for the next cycle
    Ys0 = Ys(end);
    Ye0 = Ye(end);
    Yi0 = Yi(end);
    t = Tf + t;
    
    MSus = [MSus; Ys];
    MExp = [MExp; Ye];
    MInf = [MInf; Yi];
    Tvec = [Tvec; t];
    
    A_d(1,2) = lambdaHV*Yi0;

    Tf=Tf+ts(s);
end