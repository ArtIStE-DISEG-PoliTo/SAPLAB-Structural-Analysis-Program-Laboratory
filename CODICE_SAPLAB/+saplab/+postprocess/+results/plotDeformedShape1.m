function plotDeformedShape1(ax, m, scaleFactor)

if ~contains(m.AnalysisType, 'frame')
    return;
end

switch m.Dim
    case 1
        if m.Geometry.SysDim == 3
           plotPlaneFrameDeformation(m.Results,ax,scaleFactor)
        else
           plotSpaceFrameDeformation(m.Results,ax,scaleFactor)
        end
end

end

function plotPlaneFrameDeformation(R,ax,scaleFactor)

deformation = R.evaluatedShape();
u = deformation.Diagramvalues.u;
v = deformation.Diagramvalues.v;

nr = numel(deformation.RegionID);
XX = [];
YY = [];
ux = [];
uy = [];
NODAL_LABEL= [];

for i = 1:nr

    [ne,xx,yy,zz]=getLineRegionParameters(R,deformation,i);

    %formulate tensors to plot
    lx = linspace(xx(1),xx(2),ne+1);
    ly = linspace(yy(1),yy(2),ne+1);
    lz = linspace(zz(1),zz(2),ne+1);
    uu = u{i};
    vv = v{i};
    ww = zeros(size(uu));
    uv = [uu;vv;ww];
    b = [lx;ly;lz];
    ux = [ux, NaN, uv(1,:)];    %#ok
    uy = [uy, NaN, uv(2,:)];   %#ok
    XX = [XX, NaN, b(1,:)];    %#ok
    YY = [YY, NaN, b(2,:)];    %#ok
    NODAL_LABEL = [NODAL_LABEL; uv(1,1) uv(2,1) b(1,1) b(2,1)];        %#ok
    NODAL_LABEL = [NODAL_LABEL; uv(1,end) uv(2,end) b(1,end) b(2,end)];%#ok

end

[~,ia,~] = unique(NODAL_LABEL(:,3:4),'rows','stable');
NODAL_LABEL = NODAL_LABEL(ia,:);

%plot diagrams
plot(ax,XX+scaleFactor*ux,YY+scaleFactor*uy,'Color','b','Tag','DIAGRAM','LineWidth',1,'LineJoin','chamfer');
for i=1:size(NODAL_LABEL,1)
     ux = NODAL_LABEL(i,1);
     uy = NODAL_LABEL(i,2);
     text(ax,NODAL_LABEL(i,3)+scaleFactor*ux,NODAL_LABEL(i,4)+scaleFactor*uy,([string(['ux: ', num2str(ux,'%.2E')]);string(['uy: ', num2str(uy,'%.2E')])]),'FontSmoothing','off','HorizontalAlignment','center');
end


end

function plotSpaceFrameDeformation(R,ax,scaleFactor)

deformation = R.evaluatedShape();

u = deformation.Diagramvalues.u;
v = deformation.Diagramvalues.v;
w = deformation.Diagramvalues.w;


if isempty(scaleFactor), scaleFactor = 1/max(abs([cell2mat(u) cell2mat(v) cell2mat(w)])); end

nr = numel(deformation.RegionID);
XX=[];
YY=[];
ZZ=[];
ux=[];
uy=[];
uz=[];
NODAL_LABEL = [];
for i = 1:nr

    [ne,xx,yy,zz,~]=getLineRegionParameters(R,deformation,i);

    %formulate tensors to plot
    lx = linspace(xx(1),xx(2),ne+1);
    ly = linspace(yy(1),yy(2),ne+1);
    lz = linspace(zz(1),zz(2),ne+1);

    uu = u{i};
    vv = v{i};
    ww = w{i};
    
    b = [lx;ly;lz];
    uvw = [uu;ww;vv];

    XX=[XX,NaN,b(1,:)];  %#ok
    YY=[YY,NaN,b(2,:)];  %#ok
    ZZ=[ZZ,NaN,b(3,:)];  %#ok
    ux=[ux,NaN,uvw(1,:)];  %#ok
    uy=[uy,NaN,uvw(2,:)];  %#ok
    uz=[uz,NaN,uvw(3,:)];  %#ok

    NODAL_LABEL = [NODAL_LABEL; uvw(1,1) uvw(2,1) uvw(3,1) b(1,1) b(2,1) b(3,1)];            %#ok
    NODAL_LABEL = [NODAL_LABEL; uvw(1,end) uvw(2,end) uvw(3,end) b(1,end) b(2,end) b(3,end)];%#ok

end

[~,ia,~] = unique(NODAL_LABEL(:,4:6),'rows','stable');
NODAL_LABEL = NODAL_LABEL(ia,:);
%plot diagrams
plot3(ax,XX+scaleFactor*ux,YY+scaleFactor*uz,ZZ+scaleFactor*uy,'Color', 'b','Tag','DIAGRAM','LineWidth',1);
% for i=1:size(NODAL_LABEL,1)
%      ux = NODAL_LABEL(i,1);
%      uy = NODAL_LABEL(i,2);
%      uz = NODAL_LABEL(i,3);
%      text(ax,NODAL_LABEL(i,4)+scaleFactor*ux,NODAL_LABEL(i,5)+scaleFactor*uz,NODAL_LABEL(i,6)+scaleFactor*uy,([string(['ux: ', num2str(ux,'%.2E')]);string(['uy: ', num2str(uz,'%.2E')]);string(['uz: ', num2str(uy,'%.2E')])]),'FontSmoothing','off','HorizontalAlignment','center');
% end

end


function [ne,xx,yy,zz,state]=getLineRegionParameters(R,n,i)
    e  = n.Elements{i};
    ne = numel(e);
    elems = R.Mesh.Elements(:,e);
    state = R.Mesh.state.p';
    nodes = R.Mesh.Nodes(:,elems);
    xx = [nodes(1,1) nodes(1,end)];
    yy = [nodes(2,1) nodes(2,end)];
    zz = [nodes(3,1) nodes(3,end)];
end
