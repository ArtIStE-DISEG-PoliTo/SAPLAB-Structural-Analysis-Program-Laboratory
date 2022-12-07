function plotTriStrain(Model,Axes,Field,ScaleFactor)

narginchk(1,4);
if isempty(Model), return; end

g = Model;
switch g.Dim
    case 1
    %do nothing
    case 2
        Model.Graphics.Appearance.LineStyle = ':';
        Model.Graphics.Appearance.EdgeColor = 'none'; 
        Model.Graphics.Appearance.VertexColor = 'none';
        R = g.Results;
        canvas.Axes = Axes;
        canvas.Appearance = Model.Graphics.Appearance;
        switch Field
            case 'EXX'
            plot2DElementsStrain(canvas,R,Field,ScaleFactor);
            case 'EXY'
            plot2DElementsStrain(canvas,R,Field,ScaleFactor);   
            case 'EYY'
            plot2DElementsStrain(canvas,R,Field,ScaleFactor);    

        end
end

cmap = [0    0   1;  ...
        0   .15  1
        0   0.5  1; ...
        0   .85  1
        0    1   1; ...
        0    1   .85; ...
        0    1.0 .5; ...
        0    1.0 .15; ...
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

%set the colormap
colormap(Axes,cmap);
colorbar(Axes,"southoutside")
end

function plot2DElementsStrain(canvas,r,f,s)

eps = r.evalStrainAtNodal();
elemSol = r.ElementSolution;

if isempty(s)
s = 0.1/max(abs([r.NodalSolution.dx;r.NodalSolution.dy]));
end
%extract triangles
[~,i] = r.extractTriangles(r.Mesh.state.t);
t_tri = r.Mesh.t(:,i);

p1 = r.Mesh.Nodes(:,t_tri(1,:));
p2 = r.Mesh.Nodes(:,t_tri(2,:));
p3 = r.Mesh.Nodes(:,t_tri(3,:));

nodes = [p1;p2;p3];

exx = eps.exx(t_tri);
exy = eps.exy(t_tri);
eyy = eps.eyy(t_tri);

dx = elemSol.Triangle.dx;
dy = elemSol.Triangle.dy;

x = nodes(1:2:end,:)+s*dx;
y = nodes(2:2:end,:)+s*dy;

switch f
    case 'EXX'
        c = exx;
    case 'EXY'
        c = exy;
    case 'EYY'
        c = eyy;
end
% plot(canvas.Axes,x,y,'-','Color',canvas.Appearance.GenericTextColor)
fill(canvas.Axes,x,y,c,'EdgeColor','none','FaceAlpha',1)

end
