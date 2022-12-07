function pinned22(location,varargin)

p=inputParser();
p.addParameter('parent',[]);
p.addParameter('color',[]);
p.parse(varargin{:});

ax=p.Results.parent;

if isnumeric(location)
    x=location(1);
    y=location(2);
    bbox=location(4);
    xx = [0 0 0 -bbox/3.5 bbox/3.5 0];
    yy = [0 -bbox/2.5-bbox/15 0 -bbox/2.5-bbox/15 -bbox/2.5-bbox/15 0];
    plot(ax,xx+x,yy+y,'Color',p.Results.color,'LineWidth',.1);
    hold(ax,'on')
    plot(ax,yy+x,xx+y,'Color',p.Results.color,'LineWidth',.1);
else
    obj = findobj(ax,'Tag', location{1});
    bbox = location{2};
    x = obj.XData(1:end-1);
    y = obj.YData(1:end-1);
    x = x([1 ceil(1*numel(x)/5) ceil(2*numel(x)/5) ceil(3*numel(x)/5) ceil(4*numel(x)/5) ceil(5*numel(x)/5)]);
    y = y([1 ceil(1*numel(y)/5) ceil(2*numel(y)/5) ceil(3*numel(y)/5) ceil(4*numel(y)/5) ceil(5*numel(y)/5)]);
    xx = [0 0 0 -bbox/3.5 bbox/3.5 0]';
    yy = [0 -bbox/2.5-bbox/15 0 -bbox/2.5-bbox/15 -bbox/2.5-bbox/15 0]';
    plot(ax,xx+x,yy+y,'Color',p.Results.color,'LineWidth',.1);
    hold(ax,'on')
    plot(ax,yy+x,xx+y,'Color',p.Results.color,'LineWidth',.1);
end


end

