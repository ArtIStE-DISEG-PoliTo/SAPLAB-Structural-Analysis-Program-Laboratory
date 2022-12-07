function plotFrameConstraint(ax,sm,bbox,gm)

import sap.graphics.*

if isempty(sm.BoundaryConditions)
   return; 
end

bc = findboundaryConditions(sm.BoundaryConditions,'Point',gm);
if isempty(bc)
   return;
else
    fxyz=getPfxyz(sm.Geometry,gm);
    bcType = bc.Constraint;
    if strcmpi(bcType,'Fixed')
        Fixed(ax,bbox,fxyz,sm.Dim);
    elseif strcmpi(bcType,'Pinned')
        Pinned(ax,bbox,fxyz,sm.Dim);
    elseif strcmpi(bcType,'RollerX') || strcmpi(bcType,'Roller X')
        RollerX(ax,bbox,fxyz,sm.Dim);
    elseif strcmpi(bcType,'RollerY') || strcmpi(bcType,'Roller Y')
        RollerY(ax,bbox,fxyz,sm.Dim);     
    elseif strcmpi(bcType,'RollerZ') || strcmpi(bcType,'Roller Z')
        RollerZ(ax,bbox,fxyz,sm.Dim);  
    elseif strcmpi(bcType,'RollerXY') || strcmpi(bcType,'Roller XY')
        RollerXY(ax,bbox,fxyz,sm.Dim);          
    end
end

end

