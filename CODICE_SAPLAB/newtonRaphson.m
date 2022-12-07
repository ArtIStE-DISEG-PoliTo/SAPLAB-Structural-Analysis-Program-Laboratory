function [KK,aa,ff]=newtonRaphson(P,f,ni)
%NEWTHONRAPHSON - Algoritmo di Newton Raphson implementato in MATLAB
%Argomenti di input della funzione:
%      - P: funzione non lineare (syms)
%      - f: parametro di target
%      - ni: numero di iterazioni da effettuare
a_i = 0; Pa = P(a_i); R = f - Pa;

i  = 0; %subscript
dP = diff(P);
while 1
    Kt = dP(a_i);
    da = Kt\R;
    a_i = a_i+da;
    R  = f - P(a_i);
    i = i + 1;
    if i==ni
        KK = double(Kt); aa = double(a_i); ff = double(P(a_i));
        break;
    end
end