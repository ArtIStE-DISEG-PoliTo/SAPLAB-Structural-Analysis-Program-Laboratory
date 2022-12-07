function plotDeformedShape(Model,axes,s)

narginchk(1,3);
if isempty(Model), return; end

g = Model;
if nargin == 1, s=[]; end

colorbar(axes,'off')

Model.Graphics.Appearance.LineStyle = ':';
r = g.Results;
canvas.Axes = axes;
canvas.Appearance = Model.Graphics.Appearance;

switch g.Dim
    case 1
        if g.Geometry.SysDim == 3
           plot1DElementsDeShape2(canvas,r,s);
        elseif g.Geometry.SysDim == 6
           plot1DElementsDeShape3(canvas,r,s); 
        end
    case 2
        Model.Graphics.Appearance.LineStyle = ':';
        r = g.Results;
        plot2DElementsDeShape(canvas,r,s);
    otherwise
        return

end
end


function plot1DElementsDeShape2(canvas,r,s)

ndata = r.evaluatedShape();
u = ndata.Diagramvalues.u;
v = ndata.Diagramvalues.v;

xmax = max(abs(canvas.Axes.XLim));
ymax = max(abs(canvas.Axes.YLim));
zmax = max(abs(canvas.Axes.ZLim));

ii=max([xmax,ymax,zmax])/10;

if isempty(s), s = ii/max(abs([cell2mat(u) cell2mat(v)])); end

nr = numel(ndata.RegionID);
XX = [];
YY = [];
DX = [];
DY = [];
dxt= [];
dyt= [];
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

    DX = [DX, d(1,:)];    %#ok
    DY = [DY, -d(2,:)];   %#ok
    XX = [XX, b(1,:)+x];  %#ok
    YY = [YY, -b(2,:)+y]; %#ok
    dxt= [dxt; d(1,1) b(1,1)+x d(1,floor(size(d,2)/2)) b(1,floor(size(d,2)/2))+x d(1,end) b(1,end)+x]; %#ok
    dyt= [dyt;-d(2,1) -b(2,1)+y -d(2,floor(size(d,2)/2)) -b(2,floor(size(d,2)/2))+y -d(2,end) -b(2,end)+y]; %#ok

end

%plot diagrams
plot(canvas.Axes,XX+s*DX,YY+s*DY,'Color','k','Tag','DIAGRAM','LineWidth',1.0,'LineJoin','chamfer');

for i=1:size(dxt,1)
text(canvas.Axes,dxt(i,2)+s*dxt(i,1),dyt(i,2)+s*dyt(i,1),[string(['UX: ',num2str(dxt(i,1))]);string(['UY: ',num2str(dyt(i,1))])])
text(canvas.Axes,dxt(i,4)+s*dxt(i,3),dyt(i,4)+s*dyt(i,3),[string(['UX: ',num2str(dxt(i,3))]);string(['UY: ',num2str(dyt(i,3))])])
text(canvas.Axes,dxt(i,6)+s*dxt(i,5),dyt(i,6)+s*dyt(i,5),[string(['UX: ',num2str(dxt(i,5))]);string(['UY: ',num2str(dyt(i,5))])])
end

end

function plot1DElementsDeShape3(canvas,r,s)

ndata = r.evaluatedShape();
u = ndata.Diagramvalues.u;
v = ndata.Diagramvalues.v;
w = ndata.Diagramvalues.w;

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

%plot diagrams
plot3(canvas.Axes,XX+s*DX,ZZ+s*DZ,YY+s*DY,'Color', canvas.Appearance.DeformedShapeColor,'Tag','DIAGRAM');

end

function plot2DElementsDeShape(canvas,r,s)

elemSol = r.ElementSolution;
ts  = r.Mesh.state.t;
t   = r.Mesh.t;

dx = r.NodalSolution.dx;
dy = r.NodalSolution.dy;

if isempty(s), s = 0.1/max(abs([dx;dy])); end

if isfield(elemSol,'Triangle')

    for i = 1:r.ParentModel.Geometry.NumFaces

        find_Nodes = findMesh(r.Mesh,"Parameter","Node","Face",i);

        u = dx(find_Nodes);
        v = dy(find_Nodes);
        
        x = r.Mesh.Nodes(1,find_Nodes)';
        y = r.Mesh.Nodes(2,find_Nodes)';  
        tt = delaunay([x,y]);

        X=x+s*u;
        Y=y+s*v;
        triplot(tt,X,Y,'Parent',canvas.Axes);
        Xt=X(tt');
        Yt=Y(tt');
        fill(canvas.Axes,Xt,Yt,'c','FaceAlpha',0.75);

    end

end

if isfield(elemSol,'Truss')

    t_rei = r.extractReinf(ts);
    i = find(ismember(ts,[t_rei zeros(size(t_rei,1),2)],'rows'));
    t_rei = t(1:2,i); %#ok
    
    dx = elemSol.Truss.dx;
    dy = elemSol.Truss.dy;

    nodes = [r.Mesh.Nodes(:,t_rei(1,:));r.Mesh.Nodes(:,t_rei(2,:))];
    x = nodes([1,3],:)+s*dx;
    y = nodes([2,4],:)+s*dy;

    plot(canvas.Axes,x,y,'-','LineWidth',1.5,'MarkerSize',2,'Color',canvas.Appearance.ReinforcementColor,'LineJoin','chamfer')
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