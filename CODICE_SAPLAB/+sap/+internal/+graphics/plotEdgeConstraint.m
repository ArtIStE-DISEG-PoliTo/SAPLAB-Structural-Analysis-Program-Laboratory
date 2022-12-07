function plotEdgeConstraint(ax,sm,bbox,gm)

import sap.graphics.*

if isempty(sm.BoundaryConditions)
   return; 
end
if isempty(sm.Mesh)
    return;
end
bbox = bbox/2;
bc = findboundaryConditions(sm.BoundaryConditions,'Edge',gm);
if isempty(bc)
   return;
else
    nd = findNodesToEdges(sm.Mesh,'Edge',gm);
    for i = 1:numel(nd)
        fxyz=sm.Mesh.NodesMatrix(nd(i),:);
        bcType = bc.Constraint;
        if strcmpi(bcType,'Fixed') || strcmpi(bcType,'Pinned')
            PinnedX(ax,bbox,fxyz,sm.Dim);
            PinnedY(ax,bbox,fxyz,sm.Dim); 
        elseif strcmpi(bcType,'RollerX') || strcmpi(bcType,'Roller X')
            RollerX(ax,bbox,fxyz,sm.Dim);
        elseif strcmpi(bcType,'RollerY') || strcmpi(bcType,'Roller Y')
            RollerY(ax,bbox,fxyz,sm.Dim); 
        end
    end
end

end

