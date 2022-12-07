function [xx,yy,zz] = NegArrowFcn(bbox)
rot = linspace(0,3*pi/2);
xx = bbox*cos(rot);
yy = bbox*sin(rot);
xx = [xx, xx(end)-bbox/3 xx(end) xx(end)-bbox/3];
yy = [yy, yy(end)+bbox/5.5 yy(end) yy(end)-bbox/8];
zz = 0.*xx;
end

