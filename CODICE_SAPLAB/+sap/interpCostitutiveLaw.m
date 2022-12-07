function [U,F,KK,R] = interpCostitutiveLaw(X,Y,varargin)
%INTERPCOSTITUTIVELAW evaluate constitutive law parameters

p = inputParser();
addParameter(p, 'Tol',[]);
addParameter(p, 'InterpMethod', 'linear');
addParameter(p, 'Yvalue', [], @(val) isscalar(val) && isnumeric(val));
addParameter(p, 'Xvalue', [], @(val) isscalar(val) && isnumeric(val));
parse(p, varargin{:});

%Get results
Xvalue = p.Results.Xvalue;
Yvalue = p.Results.Yvalue;
interpMethod = p.Results.InterpMethod;

% [X,is] = sort(X);

dX = diff(X);
nDiscr = 70000;
dTol = dX/nDiscr;

X0 = X;
X0 = X0(:);
Y0 = Y(:);
SP = unique([X0,Y0],'rows','stable'); %curve sample points

%compute fitted curve
XX = [];
for i=1:numel(dX)
    XX = [XX,X0(i):dTol:X0(i+1)]; %#ok
end

YY = interp1(SP(:,1),SP(:,2),XX,interpMethod);

if ~isempty(Xvalue) %search for displacement
    [Max_x,I] = max(XX);
    if Xvalue > Max_x
        U = Max_x;
        F = YY(I);
        KK = (YY(I)-YY(I-1))/(XX(I)-XX(I-1));
        return;
    end
    [Min_x,I] = min(XX);
    if Xvalue < Min_x
        U = Min_x;
        F = YY(I);
        KK = (YY(I)-YY(I+1))/(XX(I)-XX(I+1));
        return;
    end
    
    if Xvalue >= 0
        pos = find(XX >= 0);
    else
        pos = find(XX < 0);
    end
    XX = XX(pos);
    YY = YY(pos);
    [~,I] = min(abs(Xvalue - XX));
    U = XX(I);
    F = YY(I);

    if I > 1, KK = (YY(I)-YY(I-1))/(XX(I)-XX(I-1)); else, KK = (YY(I)-YY(I+1))/(XX(I)-XX(I+1)); end
    if isnan(KK)
        KK = 0;
    end
    R = abs(Xvalue-U);
else
    [Max_y,I] = max(YY);
    if Yvalue > Max_y
        F = Max_y;
        U = XX(I);
        KK = (YY(I)-YY(I-1))/(XX(I)-XX(I-1));
        return;
    end
    [Min_y,I] = min(YY);
    if Yvalue < Min_y
        F = Min_y;
        U = XX(I);
        KK = (YY(I)-YY(I+1))/(XX(I)-XX(I+1));
        return;
    end
    
    if Yvalue >= 0
        pos = find(YY >= 0);
    else
        pos = find(YY < 0);
    end
    XX = XX(pos);
    YY = YY(pos);
    abs(Yvalue - YY)
    [~,I] = min(abs(Yvalue - YY));
    U = XX(I);
    F = YY(I);
    if I > 1, KK = (YY(I)-YY(I-1))/(XX(I)-XX(I-1)); else, KK = (YY(I)-YY(I+1))/(XX(I)-XX(I+1)); end
    R = abs(Yvalue-F);
end