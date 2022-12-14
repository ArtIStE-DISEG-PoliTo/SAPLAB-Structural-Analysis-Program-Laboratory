function ContourPlotData(ax, m, value, scaleFactor)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

r = m.Results;
eSol = r.ElementSolution;
deformation = r.NodalSolution;

%extract triangles
[~,i] = r.extractTriangles(r.Mesh.state.t);
t_tri = r.Mesh.t(:,i);
p1 = r.Mesh.Nodes(:,t_tri(1,:));
p2 = r.Mesh.Nodes(:,t_tri(2,:));
p3 = r.Mesh.Nodes(:,t_tri(3,:));

pointsArray = [p1;p2;p3];
value = value(t_tri);

%compute scale factor
if isempty(scaleFactor)
scaleFactor = max(max(pointsArray))/(6*max(sqrt(r.NodalSolution.ux.^2+r.NodalSolution.uy.^2)));
end

x = eSol.Triangle.ux;
y = eSol.Triangle.uy;

xx = pointsArray(1:2:end,:)+scaleFactor*x;
yy = pointsArray(2:2:end,:)+scaleFactor*y;
cmap = cmapInternal();
fill(ax,xx,yy,value,'EdgeColor','none','FaceAlpha',1);
hold(ax,'on')
colormap(ax,cmapInternal);
colorbar(ax,"southoutside");

ux = deformation.ux;
uy = deformation.uy;

pdeMesh = r.Mesh.PDEMesh;
pdeElements = pdeMesh.Elements;
n1 = min(min(pdeElements));
n2 = max(max(pdeElements));
queryNodes = n1:n2;
x = ux(queryNodes);
y = uy(queryNodes);
xx = r.Mesh.Nodes(1,queryNodes);
yy = r.Mesh.Nodes(2,queryNodes);
x = x(:);
y = y(:);
xx = xx(:);
yy = yy(:);
PP = [xx+scaleFactor*x,yy+scaleFactor*y];
TR = triangulation(pdeElements',PP);
POLYOUT = boundaryshape(TR);
plot(POLYOUT,'Parent',ax,'EdgeColor','k','FaceColor','none')

end


function cmap = cmapInternal()

% c = 255;
% cmap = [0,c/c,c/c;...
%         0,213/c,c/c;...
%         0,170/c,c/c;...
%         0,128/c,c/c;...
%         0,85/c,c/c;...
%         0,42/c,c/c;...
%         0,0,c/c;...
%         64/c,0,c/c;...
%         128/c,0,c/c;...
%         192/c,0,c/c; ...
%         c/c,0,c/c; ...
%         c/c,0,192/c;...
%         c/c,0,128/c;...
%         c/c,0,64/c;...
%         c/c,0,0; ...
%         c/c,51/c,0;...
%         c/c,102/c,0;...
%         c/c,153/c,0;...
%         c/c,204/c,0;...
%         c/c,c/c,0];

cmap = [0    0   1;  ...
        0   .15  1
        0   0.5  1; ...
        0   .85  1
        0    1   1; ...
        0    1   .85; ...
        0    1.0 .7; ...
        0    1.0 .4; ...
        0   1.0  0; ...
        .15  1.0  0; ...
        0.5  1   0; ...
        0.85 1   0; ...
        1    1   0; ...
        1   0.85   0; ...
        1   0.5   0; ...
        1   0.15  0; ...
        1    0    0; ...
        0.85 0  0];
end