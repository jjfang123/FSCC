function Offspring = DE_cr(Parent1,Parent2,Parent3,Parent4,Parameter)
% DE operator used in TOP

%------------------------------- Copyright --------------------------------
% Copyright (c) 2018-2019 BIMK Group. You are free to use the PlatEMO for
% research purposes. All publications which use this platform or any code
% in the platform should acknowledge the use of "PlatEMO" and reference "Ye
% Tian, Ran Cheng, Xingyi Zhang, and Yaochu Jin, PlatEMO: A MATLAB platform
% for evolutionary multi-objective optimization [educational forum], IEEE
% Computational Intelligence Magazine, 2017, 12(4): 73-87".
%--------------------------------------------------------------------------

    %% Parameter setting
    if nargin > 3
        [CR,F,proM,disM] = deal(Parameter{:});
    else
        [CR,F,proM,disM] = deal(1,0.5,1,20);
    end
    if isa(Parent1(1),'INDIVIDUAL')
        calObj  = true;
        Parent_i  = Parent1.decs;
        Parent_r1 = Parent2.decs;
        Parent_r2 = Parent3.decs;
        Parent_r3 = Parent4.decs;
    else
        calObj = false;
    end
    [N,D]  = size(Parent_i);
    Global = GLOBAL.GetObj();

    
    %% Differental evolution
    Site = rand(N,D) < CR;
    Offspring       = Parent_i;
    Offspring(Site) = Offspring(Site) + F*(Parent_r1(Site)-Parent_i(Site))+ F*(Parent_r2(Site)-Parent_r3(Site));

    %% Polynomial mutation
    Lower = repmat(Global.lower,N,1);
    Upper = repmat(Global.upper,N,1);
    Site  = rand(N,D) < proM/D;
    mu    = rand(N,D);
    temp  = Site & mu<=0.5;
    Offspring       = min(max(Offspring,Lower),Upper);
    Offspring(temp) = Offspring(temp)+(Upper(temp)-Lower(temp)).*((2.*mu(temp)+(1-2.*mu(temp)).*...
                      (1-(Offspring(temp)-Lower(temp))./(Upper(temp)-Lower(temp))).^(disM+1)).^(1/(disM+1))-1);
    temp = Site & mu>0.5; 
    Offspring(temp) = Offspring(temp)+(Upper(temp)-Lower(temp)).*(1-(2.*(1-mu(temp))+2.*(mu(temp)-0.5).*...
                      (1-(Upper(temp)-Offspring(temp))./(Upper(temp)-Lower(temp))).^(disM+1)).^(1/(disM+1)));
    if calObj
        Offspring = INDIVIDUAL(Offspring);
    end
end