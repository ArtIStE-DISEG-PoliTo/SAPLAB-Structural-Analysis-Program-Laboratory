function [p2d_mouse,selectedItem] = canvasRayCasting(Model,ax,linkedPoints,pointsTags)
%CANVASRAYCASTING Summary of this function goes here
%   Detailed explanation goes here

persistent txt;
delete(txt);

if isempty(Model)
    p2d_mouse = ["N/A", "N/A"];
    selectedItem = 'none';
    return
end

gOptions = Model.Graphics;

% get the current point position and view
cpt = ax.CurrentPoint; 
v = ax.View;
t = viewmtx(v(1),v(2));
cpt = mean(cpt);
cpt = round(cpt*1000)/1000;
x = cpt(1);
y = cpt(2);
z = cpt(3);

if isempty(linkedPoints)
    p2d_mouse = [x;y;z];
    selectedItem = 'none';
    return
end

%get linked points in 3D
X = linkedPoints(:,1)';
Y = linkedPoints(:,2)'; 
Z = linkedPoints(:,3)'; 
[i,j] = size(X);
x4d = [X(:),Y(:),Z(:),ones(i*j,1)]';

%compute linked points in 2D
p2d = t*x4d; 
p2d = p2d(1:2,:);

%project mouse coordinates in 2D
x4d_mouse = [x y z 1]';
p2d_mouse = t*x4d_mouse; 
p2d_mouse = p2d_mouse(1:2,:);

if isempty(linkedPoints)
    selectedItem = 'none';
    return;
end

underLineColor = [1 0.5 0.25];

%find the nearest point to the mouse position
[idx, distmin] = dsearchn(p2d',p2d_mouse');

tol = tolerance(ax);

if numel(idx) == 1 && (distmin) <= tol
    getObject = findobj(ax,'Tag',pointsTags{idx});
    getObject(1).MarkerSize = gOptions.Appearance.MarkerSize+2;
    getObject(1).LineWidth  = gOptions.Appearance.LineWidth+2;
    getObject(1).Color = underLineColor;
    getObject(1).MarkerFaceColor = underLineColor;
    selectedItem = pointsTags{idx};
   if isscalar(getObject(1).XData)
       if ~isempty(getObject(1).ZData)
            txt = text(ax,getObject(1).XData, getObject(1).YData, getObject(1).ZData, pointsTags{idx},'FontName','Verdana','VerticalAlignment','bottom');
       else
            txt = text(ax,getObject(1).XData, getObject(1).YData, pointsTags{idx},'FontName','Verdana','VerticalAlignment','bottom');
       end
   else
       if ~isempty(getObject(1).ZData)
            txt = text(ax,0.5*sum(getObject(1).XData), 0.5*sum(getObject(1).YData), 0.5*sum(getObject(1).ZData), pointsTags{idx},'FontName','Verdana','VerticalAlignment','bottom');
       else
            txt = text(ax,0.5*sum(getObject(1).XData), 0.5*sum(getObject(1).YData), pointsTags{idx},'FontName','Verdana','VerticalAlignment','bottom');
       end
   end
else
    selectedItem = 'none';
end

if distmin > tol
    gobj = findall(ax,'Type','Line','LineWidth', gOptions.Appearance.LineWidth+2);
    if ~isempty(gobj)
        for i=1:numel(gobj)
            gobj(i).LineWidth = gOptions.Appearance.LineWidth;
            gobj(i).MarkerSize = gOptions.Appearance.MarkerSize;
            gobj(i).MarkerFaceColor = [0,0,1];
            gobj(i).Color = [0,0,1];
        end
    end
    selectedItem = 'none';
end

end

function tol = tolerance(ax)
xlim = get(ax,'XLim');
ylim = get(ax,'YLim');
zlim = get(ax,'ZLim');

dx = xlim(2)-xlim(1); dx = abs(dx);
dy = ylim(2)-ylim(1); dy = abs(dy);
dz = zlim(2)-zlim(1); dz = abs(dz);

gradient = [dx,dy,dz];
maxG = max(gradient);

tol = maxG/100;

end