function [xx,yy,zz] = PosArrowFcn(bbox)
rot = linspace(0,3*pi/2);
xx = bbox*cos(rot);
yy = bbox*sin(rot);
xx = [xx(1)-bbox/5 xx(1) xx(1)+bbox/9,xx];
yy = [yy(1)+bbox/3 yy(1) yy(1)+bbox/3,yy];
zz = 0.*xx;
end

