function ContourPlotData1(ax, m, field,scaleFactor)

if ~contains(m.AnalysisType, 'frame')
    return;
end

switch m.Dim
    case 1
        if m.Geometry.SysDim == 3
           plotPlaneFrameDeformation(m.Results,ax,field,scaleFactor)
        else
           plotSpaceFrameDeformation(m.Results,ax,field,scaleFactor)
        end
end

end

function plotPlaneFrameDeformation(R,ax,field,scaleFactor)

deformation = R.evaluatedShape();
u = deformation.Diagramvalues.u;
v = deformation.Diagramvalues.v;
ElemSol = R.ElementSolution;
EL = R.Mesh.Elements;
XData = [R.Mesh.Nodes(1,EL(1,:)); R.Mesh.Nodes(1,EL(2,:))];
YData = [R.Mesh.Nodes(2,EL(1,:)); R.Mesh.Nodes(2,EL(2,:))];
field = field(R.Mesh.Elements);
X_Data = [];
Y_Data = [];
Field  = [];
for i = 1:R.ParentModel.Geometry.NumLines
    line_i = saplab.findElementsInMesh(R.Mesh,'Line',i);
    X = XData(:,line_i)+scaleFactor*ElemSol.ux(:,line_i);
    Y = YData(:,line_i)+scaleFactor*ElemSol.uy(:,line_i);
    F = field(:,line_i);

    X_Data = [X_Data, X(:,1) X X(:,end)]; %#ok
    Y_Data = [Y_Data, Y(:,1) Y Y(:,end)]; %#ok
    Y_Data(:,end) = NaN;

    Field  = [Field, F(:,1) F F(:,end)];  %#ok
    
end
contourl(ax,X_Data,Y_Data,0.*Y_Data,(Field),'Tag','DIAGRAM','LineWidth',2);
colormap(ax,cmapInternal);
colorbar(ax,"southoutside");


end

function plotSpaceFrameDeformation(R,ax,field,scaleFactor)

deformation = R.evaluatedShape();
u = deformation.Diagramvalues.u;
v = deformation.Diagramvalues.v;
ElemSol = R.ElementSolution;
EL = R.Mesh.Elements;
XData = [R.Mesh.Nodes(1,EL(1,:)); R.Mesh.Nodes(1,EL(2,:))];
YData = [R.Mesh.Nodes(2,EL(1,:)); R.Mesh.Nodes(2,EL(2,:))];
ZData = [R.Mesh.Nodes(3,EL(1,:)); R.Mesh.Nodes(3,EL(2,:))];
X_Data = [];
Y_Data = [];
Z_Data = [];
Field  = [];
isNum = false;
if isnumeric(field)
    isNum = true;
    field = field(R.Mesh.Elements);
end
for i = 1:R.ParentModel.Geometry.NumLines
    line_i = saplab.findElementsInMesh(R.Mesh,'Line',i);
    X = XData(:,line_i)+0*ElemSol.ux(:,line_i);
    Y = YData(:,line_i)+0*ElemSol.uy(:,line_i);
    Z = ZData(:,line_i)+0*ElemSol.uz(:,line_i);
    if ~isNum
        F = field{i};
        F = F(1:end-1);
    else
        F = field(:,line_i);
    end

    X_Data = [X_Data, X(:,1) X X(:,end)]; %#ok
    Y_Data = [Y_Data, Y(:,1) Y Y(:,end)]; %#ok
    Z_Data = [Z_Data, Z(:,1) Z Z(:,end)]; %#ok
    Y_Data(:,end) = NaN;
    Field  = [Field, F(:,1) F F(:,end)];  %#ok
    
end
contourl(ax,X_Data,Y_Data,Z_Data,(Field),'Tag','DIAGRAM','LineWidth',2);
colormap(ax,cmapInternal);
colorbar(ax,"westoutside");


end


function [ne,xx,yy,zz,state]=getLineRegionParameters(R,n,i)
    e  = n.Elements{i};
    ne = numel(e);
    elems = R.Mesh.Elements(:,e);
    state = R.Mesh.state.p';
    nodes = R.Mesh.Nodes(:,elems);
    xx = [nodes(1,:) nodes(1,end)];
    yy = [nodes(2,1) nodes(2,end)];
    zz = [nodes(3,1) nodes(3,end)];
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