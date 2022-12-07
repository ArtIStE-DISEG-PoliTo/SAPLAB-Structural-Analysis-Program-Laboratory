function plotDisplacements(Model,axes,field,s)

narginchk(1,4);
g = Model;
colorbar(axes,'off')

%set the colormap

switch g.Dim
    case 1
        Model.Graphics.Appearance.LineStyle = ':';
        canvas.Axes = axes;
        canvas.Appearance = Model.Graphics.Appearance;
        if g.Geometry.SysDim < 6
            switch field
                case 'UX'
                %plot displacements
                r = g.Results;
                plot1DElementsDisplacements2(canvas,r,field,s)
                case 'UY'
                r = g.Results;
                plot1DElementsDisplacements2(canvas,r,field,s)
            end
        else
        Model.Graphics.Appearance.LineStyle = 'none';
        canvas.Axes = axes;
        canvas.Appearance = Model.Graphics.Appearance;

            switch field
                case 'UX'
                %plot displacements
                r = g.Results;
                plot1DElementsDisplacements3(canvas,r,field,s)
                case 'UY'
                r = g.Results;
                plot1DElementsDisplacements3(canvas,r,field,s)
                case 'UZ'
                r = g.Results;
                plot1DElementsDisplacements3(canvas,r,field,s)
            end
        end
    case 2
        
        canvas.Appearance.LineStyle = ':';
        canvas.Axes = axes;
        canvas.Appearance = Model.Graphics.Appearance;
        r = g.Results;
        
        switch field
            case 'UX'
            plot2DElementsDisplacements(canvas,r,field,s);
            case 'UY'
            plot2DElementsDisplacements(canvas,r,field,s);    
        end
end
cmap = [0   0   1;  ...
        0  .15  1
        0  0.5  1; ...
        0  .85  1
        0   1   1; ...
        0   1 .85; ...
        0  1.0 .5; ...
        0  1.0 .15; ...
        0  1.0  0; ...
        .15  1.0  0; ...
        0.5  1   0; ...
        0.85 1   0; ...
        1   1   0; ...
        1  0.85   0; ...
        1  0.5   0; ...
        1  0.15  0; ...
        1   0   0; ...
        0.85 0  0];
colormap(canvas.Axes,cmap);
colorbar(canvas.Axes,'southoutside')

end

function plot1DElementsDisplacements2(canvas,r,f)

ndata = r.evaluatedShape();
u = ndata.Diagramvalues.u;
v = ndata.Diagramvalues.v;
xmax = max(abs(canvas.Axes.XLim));
ymax = max(abs(canvas.Axes.YLim));
zmax = max(abs(canvas.Axes.ZLim));

ii=max([xmax,ymax,zmax])/10;
s=[];
if isempty(s), s = ii/max(abs([cell2mat(u) cell2mat(v)])); end

nr = numel(ndata.RegionID);
XX = [];
YY = [];
DX = [];
DY = [];

for i = 1:nr

    [ne,x,y,~,L]=extractRegionData(ndata,r,i);

    %formulate tensors to plot
    lx = linspace(0,L,ne+1);
    ly = zeros(size(lx));
    lz = zeros(size(lx));

    uu = u{i};
    vv = v{i};
    ww = zeros(size(uu));

    R = r.ParentModel.Geometry.evalTrasformationMatrix(i,'components');
    
    d = [uu;-vv;ww];
    b = rotate3D([lx;ly;lz],R,[0,0,0]); 
    g = rotate3D([uu;-vv;ww],R,[0,0,0]); 

    DX = [DX, d(1,:)];    %#ok
    DY = [DY, -d(2,:)];   %#ok
    XX = [XX, b(1,:)+x];  %#ok
    YY = [YY, -b(2,:)+y]; %#ok

end
switch f
    case 'UX'
        c = DX;
    case 'UY'
        c = DY;
end
%plot diagrams
contourl(canvas.Axes,XX+s*DX,YY+s*DY,0.*YY,-c,'Tag','DIAGRAM','LineWidth',2);

end

function plot1DElementsDisplacements3(canvas,r,f)

ndata = r.evaluatedShape();
u = ndata.Diagramvalues.u;
v = ndata.Diagramvalues.v;
w = ndata.Diagramvalues.w;

s=[];
if isempty(s), s = 1/max(abs([cell2mat(u) cell2mat(v) cell2mat(w)])); end

nr = numel(ndata.RegionID);
XX=[];
YY=[];
ZZ=[];
DX=[];
DY=[];
DZ=[];

for i = 1:nr

    [ne,x,y,z,L]=extractRegionData(ndata,r,i);

    %formulate tensors to plot
    lx = linspace(0,L,ne+1);
    ly = zeros(size(lx));
    lz = zeros(size(lx));

    uu = u{i};
    vv = v{i};
    ww = w{i};

    R = r.ParentModel.Geometry.evalTrasformationMatrix(i,'components');
    
    b = rotate3D([lx;ly;lz],R,[0,0,0]);
    d = [uu;-ww;vv];

    XX=[XX,b(1,:)+x]; %#ok
    YY=[YY,-b(2,:)+z];%#ok
    ZZ=[ZZ,b(3,:)+y]; %#ok
    DX=[DX,d(1,:)];   %#ok
    DY=[DY,-d(2,:)];  %#ok
    DZ=[DZ,d(3,:)];   %#ok

end

switch f
    case 'UX'
        c = DX;
    case 'UY'
        c = DY;
    case 'UZ'
        c = DZ;        
end
%plot diagrams
contourl(canvas.Axes,XX+s*DX,ZZ+s*DZ,YY+s*DY,-c,'Tag','DIAGRAM','LineWidth',2);
%plot diagrams
% plot3(canvas.Axes,XX+s*DX,ZZ+s*DZ,YY+s*DY,'Color', canvas.Appearance.DeformedShapeColor,'Tag','DIAGRAM');

end


function plot2DElementsDisplacements(canvas,r,f,s)

elemSol = r.ElementSolution;
ts  = r.Mesh.state.t;
t   = r.Mesh.t;
r.NodalSolution

if isempty(s)
s = 0.1/max(abs([r.NodalSolution.dx;r.NodalSolution.dy]));
end


if isfield(elemSol,'Triangle')

    %extract triangles
    [~,i] = r.extractTriangles(ts);
    
    t_tri = t(:,i);
    p1 = r.Mesh.Nodes(:,t_tri(1,:));
    p2 = r.Mesh.Nodes(:,t_tri(2,:));
    p3 = r.Mesh.Nodes(:,t_tri(3,:));
    
    nodes = [p1;p2;p3];
    elemSol.Triangle
    UX = elemSol.Triangle.dx;
    UY = elemSol.Triangle.dy;

    x = nodes(1:2:end,:)+s*UX;
    y = nodes(2:2:end,:)+s*UY;

    switch f
        case 'UX'
            c = UX;
        case 'UY'
            c = UY;
    end

    fill(canvas.Axes,x,y,-c,'EdgeColor','none','FaceAlpha',1);
end
end


function [ne,x,y,z,L]=extractRegionData(n,r,i)
    e  = n.Elements{i};
    ne = numel(e);
    n = r.Mesh.Elements(1,e(1));
    x = r.Mesh.Nodes(1,n);
    y = r.Mesh.Nodes(2,n);
    z = r.Mesh.Nodes(3,n);    
    L = r.Mesh.h(e);
    L = sum(L);
end