function plotStress(Model,Axes,Field,ScaleFactor)

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
            case 'SXX'
            plot2DElementsStress(canvas,R,Field,ScaleFactor);
            case 'SXY'
            plot2DElementsStress(canvas,R,Field,ScaleFactor);   
            case 'SYY'
            plot2DElementsStress(canvas,R,Field,ScaleFactor);    
            case 'S11'
            plot2DVonMisesStress(canvas,R,Field,ScaleFactor);   
            case 'S12'
            plot2DVonMisesStress(canvas,R,Field,ScaleFactor);    
            case 'S22'
            plot2DVonMisesStress(canvas,R,Field,ScaleFactor);    


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

function plot2DElementsStress(canvas,r,f,s)

sigma = r.evalStressAtNodal();
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

sxx = sigma.sxx(t_tri);
sxy = sigma.sxy(t_tri);
syy = sigma.syy(t_tri);

dx = elemSol.Triangle.dx;
dy = elemSol.Triangle.dy;

x = nodes(1:2:end,:)+s*dx;
y = nodes(2:2:end,:)+s*dy;

switch f
    case 'SXX'
        c = sxx;
    case 'SXY'
        c = sxy;
    case 'SYY'
        c = syy;
end
% plot(canvas.Axes,x,y,'-','Color',canvas.Appearance.GenericTextColor)
fill(canvas.Axes,x,y,c,'EdgeColor','none','FaceAlpha',1)

end

function plot2DVonMisesStress(canvas,r,f,s)

sigma = r.evalVonMisesStress();
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

s11 = sigma.s11(t_tri);
s12 = sigma.s12(t_tri);
s22 = sigma.s22(t_tri);

dx = elemSol.Triangle.dx;
dy = elemSol.Triangle.dy;

x = nodes(1:2:end,:)+s*dx;
y = nodes(2:2:end,:)+s*dy;

switch f
    case 'S11'
        c = s11;
    case 'S12'
        c = s12;
    case 'S22'
        c = s22;
end
% plot(canvas.Axes,x,y,'-','Color',canvas.Appearance.GenericTextColor)
fill(canvas.Axes,x,y,c,'EdgeColor','none','FaceAlpha',1)

end