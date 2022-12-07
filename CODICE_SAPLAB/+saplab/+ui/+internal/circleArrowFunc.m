function [x,y] = circleArrowFunc(x0,y0,val,r)

t = 0:pi/50:pi;
if val > 0
    t = flip(t);
end
x = r*cos(t)+x0;
y = r*sin(t)+y0;

sign = val/(abs(val));

x = [x, sign*r+x0 sign*r+sign*0.01*r+x0 sign*r+x0 .96*sign*r+x0];
y = [y,  y0 y0+r/5 y0 y0+r/5];

end