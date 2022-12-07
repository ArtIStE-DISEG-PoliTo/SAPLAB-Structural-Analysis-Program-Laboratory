function [cx,cy,theta,inv1,inv2]=normToEdge(self,numEdge)
%DECOMPPRESSUREFROMEDGES(...) - this function decompose the pressure applied on a
%boundary edge into forces applied along the global reference system 
%to the nodes of the edge.

arguments
    self (1,1) sap.StructuralModel
    numEdge (1,1) double
end

femodel = self;

ne = findboundaryConditions(femodel.BoundaryConditions,"Edge",numEdge);

if ~isempty(ne)
    edgeid = ne.RegionID;
    querynds = findNodesToEdges(femodel.Mesh,"Edge",edgeid);
    if numel(querynds) == 1
        error(sap.message.EdgeWithNullLength)
    end
else
   return 
end
%get x and y nodes coordinates.
x = zeros(1,numel(querynds));
y = zeros(1,numel(querynds));

for k = 1:numel(querynds)
    x(k) = femodel.Mesh.Nodes(querynds(k)).Position(1);
    y(k) = femodel.Mesh.Nodes(querynds(k)).Position(2);
end

ndp = [x;y]';
a = [x(1) y(1)]; b = [x(2) y(2)]; c = [x(3) y(3)]; d = [x(4) y(4)];
[sopt, inv1] = flipSortMethod(a,b);
[~, inv2] = flipSortMethod(c,d);
ndps = sortrows(ndp,sopt); %sort the nodes position.

snid = zeros(size(querynds));%sort the nodes id.
msh = get(femodel.Mesh,'sapmesh');
for k = 1:numel(querynds)
   snid(k)=findNodes(msh,'nearest',ndps(k,:)'); 
end

theta = zeros(1,size(ndps,1)-1);
cx = zeros(1,size(ndps,1)-1);
cy = zeros(1,size(ndps,1)-1);

if numel(querynds)>2
    for j = 2:numel(theta)+1
        dx = ndps(j,1)-ndps(j-1,1);
        dy = ndps(j,2)-ndps(j-1,2);
        cx(j) = 0.5*(ndps(j,1)+ndps(j-1,1));
        cy(j) = 0.5*(ndps(j,2)+ndps(j-1,2));
        theta(j) = 3*pi/2+atan2(dy,dx);
    end
    cx(1) =[];
    cy(1) =[];
    theta(1) =[];
else
    %case with one element per edge
    dx  = ndps(2,1)-ndps(1,1);
    dy  = ndps(2,2)-ndps(1,2);
    cx = 0.5*(ndps(2,1)+ndps(1,1));
    cy = 0.5*(ndps(2,2)+ndps(1,2));
    theta = 3*pi/2+atan2(dy,dx);
end

end

function [sort,inv] = flipSortMethod(p1,p2)

    x1 = p1(1); x2 = p2(1);
    y1 = p1(2); y2 = p2(2);            

    inv = 1;
    if isequal(x1,x2) && abs(y2)<abs(y1)
        inv=-1;
    end
    if isequal(y1,y2) && abs(x2)<abs(x1) 
        inv=-1;
    end      
    if ~isequal(x1,x2) && abs(y1)<abs(y2)
        inv=-1;
    end            
    if inv
        sort = 'ascend';
    else
        sort = 'descend';
    end
end 
