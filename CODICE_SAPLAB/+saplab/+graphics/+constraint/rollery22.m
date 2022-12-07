function rollery22(location,varargin)

p=inputParser();
p.addParameter('parent',[]);
p.addParameter('color',[]);
p.parse(varargin{:});

ax=p.Results.parent;

if isnumeric(location)
    x=location(1);
    y=location(2);
    bbox=location(4);
    xx = [0 0 0 -bbox/5 -bbox/3 -bbox/3 -bbox/5 bbox/5 bbox/5+(bbox/3-bbox/5) bbox/5+(bbox/3-bbox/5) bbox/5 0];
    xx = [xx, 0 -bbox/3 bbox/3];
    yy = [0 -bbox/2.5 0 0 -bbox/9 -bbox/3.5 -bbox/2.5 -bbox/2.5 -bbox/3.5 -bbox/9 0 0];
    yy = [yy, -bbox/2.5 -bbox/2.55 -bbox/2.5];
    plot(ax,-yy+x,xx+y,'Color',p.Results.color,'LineWidth',.1,'Tag','CONSTRAINT');
else
    obj = findobj(ax,'Tag', location{1});
    bbox = location{2};
    x = obj.XData(1:end-1);
    y = obj.YData(1:end-1);
    x = x([1 ceil(1*numel(x)/5) ceil(2*numel(x)/5) ceil(3*numel(x)/5) ceil(4*numel(x)/5) ceil(5*numel(x)/5)]);
    y = y([1 ceil(1*numel(y)/5) ceil(2*numel(y)/5) ceil(3*numel(y)/5) ceil(4*numel(y)/5) ceil(5*numel(y)/5)]);
    xx = [0 0 0 -bbox/5 -bbox/3 -bbox/3 -bbox/5 bbox/5 bbox/5+(bbox/3-bbox/5) bbox/5+(bbox/3-bbox/5) bbox/5 0];
    xx = [xx, 0 -bbox/3 bbox/3]';
    yy = [0 -bbox/2.5 0 0 -bbox/9 -bbox/3.5 -bbox/2.5 -bbox/2.5 -bbox/3.5 -bbox/9 0 0];
    yy = [yy, -bbox/2.5 -bbox/2.55 -bbox/2.5]';
    plot(ax,-yy+x,xx+y,'Color',p.Results.color,'LineWidth',.1,'Tag','CONSTRAINT');

end


end

