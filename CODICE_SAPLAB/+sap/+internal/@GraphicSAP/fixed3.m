function fixed3(location,varargin)

p=inputParser();
p.addParameter('parent',[]);
p.addParameter('color',[]);
p.parse(varargin{:});

x=location(1);
y=location(2);
z=location(3);
bbox=location(4);

xx = [0 0 -bbox/2.5 -bbox/2.5 bbox/2.5 bbox/2.5 -bbox/2.5 0];
zz = [0 -bbox/12 -bbox/12 -bbox/2.5 -bbox/2.5 -bbox/12 -bbox/12 -bbox/12]; 
yy = 0.*xx;

xx=[xx;yy];
yy=[yy;xx];
zz=[zz;zz];

ax=p.Results.parent;
plot3(ax,xx(1,:)+x,yy(1,:)+y,zz(1,:)+z,'Color',p.Results.color,'LineWidth',.1);
hold(ax,'on')
plot3(ax,xx(2,:)+x,yy(2,:)+y,zz(2,:)+z,'Color',p.Results.color,'LineWidth',.1);
end