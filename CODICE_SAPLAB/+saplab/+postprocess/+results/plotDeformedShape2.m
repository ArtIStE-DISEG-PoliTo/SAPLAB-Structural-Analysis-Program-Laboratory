function plotDeformedShape2(ax, m, scaleFactor)


if contains(m.AnalysisType, 'frame')
    return;
end

switch m.Dim
    case 2
       plotTwoDDeformedShape(m.Results,ax,scaleFactor)
end

end

function plotTwoDDeformedShape(R,ax,scaleFactor)

deformation = R.NodalSolution;
ux = deformation.ux;
uy = deformation.uy;

pdeMesh = R.Mesh.PDEMesh;
pdeElements = pdeMesh.Elements;
n1 = min(min(pdeElements));
n2 = max(max(pdeElements));
queryNodes = n1:n2;
x = ux(queryNodes);
y = uy(queryNodes);
xx = R.Mesh.Nodes(1,queryNodes);
yy = R.Mesh.Nodes(2,queryNodes);
x = x(:);
y = y(:);
xx = xx(:);
yy = yy(:);
PP = [xx+scaleFactor*x,yy+scaleFactor*y];
TR = triangulation(pdeElements',PP);
POLYOUT = boundaryshape(TR);
plot(POLYOUT,'Parent',ax,'EdgeColor','b','FaceColor','c','FaceAlpha',.5,'LineWidth',1)

for i=1:R.ParentModel.Geometry.NumVertices
     querynodes = saplab.findNodesInMesh(R.Mesh,'Vertex',i);
     x = ux(querynodes);
     y = uy(querynodes);
     xx = R.Mesh.Nodes(1,querynodes);
     yy = R.Mesh.Nodes(2,querynodes);
     x = x(:);
     y = y(:);
     xx = xx(:);
     yy = yy(:);
     PP = [xx+scaleFactor*x,yy+scaleFactor*y];
%      text(ax,PP(:,1),PP(:,2),([string(['ux: ', num2str(x,'%.2E')]);string(['uy: ', num2str(y,'%.2E')])]),'FontSmoothing','off','HorizontalAlignment','center')
end

if ~isprop(R.ParentModel,'StructuralReinforcement')
    return
else
    if isempty(R.ParentModel.StructuralReinforcement)
        return
    else
        elemSol = R.ElementSolution;   
        if isfield(elemSol,'Truss')
            ts  = R.Mesh.state.t;
            t   = R.Mesh.t;
                 
            t_rei = R.extractReinf(ts);
            i = find(ismember(ts,[t_rei zeros(size(t_rei,1),2)],'rows'));
            t_rei = t(1:2,i); %#ok
            
            dx = -elemSol.Truss.ux;
            dy = elemSol.Truss.uy;
        
            nodes = [R.Mesh.Nodes(:,t_rei(1,:));R.Mesh.Nodes(:,t_rei(2,:))];
            x = nodes([1,3],:)+scaleFactor*dx;
            y = nodes([2,4],:)+scaleFactor*dy;
        
            plot(ax,x,y,'-','LineWidth',2.5,'MarkerSize',3,'Color','m','LineJoin','chamfer')
        end
    end
end

end