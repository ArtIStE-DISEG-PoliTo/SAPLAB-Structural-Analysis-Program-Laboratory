function rollerx2(location,varargin)
p=inputParser();
p.addParameter('parent',[]);
p.addParameter('color',[]);
p.parse(varargin{:});

x=location(1);
y=location(2);
bbox=location(4);

xx = [0 0 0 -bbox/5 -bbox/3 -bbox/3 -bbox/5 bbox/5 bbox/5+(bbox/3-bbox/5) bbox/5+(bbox/3-bbox/5) bbox/5 0];
xx = [xx, 0 -bbox/3 bbox/3];
yy = [0 -bbox/2.5 0 0 -bbox/9 -bbox/3.5 -bbox/2.5 -bbox/2.5 -bbox/3.5 -bbox/9 0 0];
yy = [yy, -bbox/2.5 -bbox/2.55 -bbox/2.5];

ax=p.Results.parent;

plot(ax,xx+x,yy+y,'Color',p.Results.color,'LineWidth',.1,'Tag','CONSTRAINT');
end