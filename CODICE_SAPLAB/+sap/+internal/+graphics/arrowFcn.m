function [x,y,z] = arrowFcn(bbox)
x = [0 bbox bbox-.3*bbox bbox bbox-0.3*bbox];
y = [0 0 0.1*bbox 0 -0.1*bbox];
z = [0 0 0 0 0];
end

