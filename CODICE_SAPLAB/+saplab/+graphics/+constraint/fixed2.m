function fixed2(location,varargin)

p=inputParser();
p.addParameter('parent',[]);
p.addParameter('color',[]);
p.parse(varargin{:});

x=location(1);
y=location(2);
bbox=location(4);

xx = [0 0 -bbox/2.5 -bbox/2.5 bbox/2.5 bbox/2.5 -bbox/2.5 0 0]+x;
yy = [0 -bbox/15 -bbox/15 -bbox/2.5 -bbox/2.5 -bbox/15 -bbox/15 -bbox/15 -bbox/2.5]+y;

ax=p.Results.parent;
plot(ax,xx,yy,'Color',p.Results.color,'LineWidth',.1,'Tag','CONSTRAINT');
end