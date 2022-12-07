function bbox = evalBoundingBox(ax)
xlim = get(ax,'XLim');
ylim = get(ax,'YLim');
zlim = get(ax,'ZLim');

dx = xlim(2)-xlim(1); dx = abs(dx);
dy = ylim(2)-ylim(1); dy = abs(dy);
dz = zlim(2)-zlim(1); dz = abs(dz);

gradient = [dx,dy,dz];
maxG = max(gradient);

bbox = maxG/20;
end

