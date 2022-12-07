function plotVertexConstraint(ax,sm,bbox,gm)

import sap.graphics.*

if isempty(sm.BoundaryConditions)
   return; 
end
bbox = bbox/2;
bc = findboundaryConditions(sm.BoundaryConditions,'Vertex',gm);
if isempty(bc)
   return;
else
    fxyz=sm.Mesh.NodesMatrix(gm,:);
    bcType = bc.Constraint;
    if strcmpi(bcType,'Fixed') || strcmpi(bcType,'Pinned')
        Fixed(ax,bbox,fxyz,sm.Dim);
    elseif strcmpi(bcType,'RollerX') || strcmpi(bcType,'Roller X')
        RollerX(ax,bbox,fxyz,sm.Dim);
    elseif strcmpi(bcType,'RollerY') || strcmpi(bcType,'Roller Y')
        RollerY(ax,bbox,fxyz,sm.Dim);       
    end
end

end

