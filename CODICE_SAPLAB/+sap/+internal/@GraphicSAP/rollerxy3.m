function rollerxy3(location,varargin)

p=inputParser();
p.addParameter('parent',[]);
p.addParameter('color',[]);
p.parse(varargin{:});

x=location(1);
y=location(2);
z=location(3);
bbox=location(4);

xxr = [0 0 0 -bbox/5 -bbox/3 -bbox/3 -bbox/5 bbox/5 bbox/5+(bbox/3-bbox/5) bbox/5+(bbox/3-bbox/5) bbox/5 0];
zzr = [0 -bbox/2.5 0 0 -bbox/9 -bbox/3.5 -bbox/2.5 -bbox/2.5 -bbox/3.5 -bbox/9 0 0];

xxr = [xxr, 0 -bbox/3 bbox/3];
zzr = [zzr, -bbox/2.5 -bbox/2.5 -bbox/2.5]; 
yyr = 0.*xxr;


ax=p.Results.parent;

plot3(ax,xxr+x,yyr+y,zzr+z,'Color',p.Results.color,'LineWidth',.1);
hold(ax,'on')
plot3(yyr+x,xxr+y,zzr+z,'Color',p.Results.color,'LineWidth',.1);

end