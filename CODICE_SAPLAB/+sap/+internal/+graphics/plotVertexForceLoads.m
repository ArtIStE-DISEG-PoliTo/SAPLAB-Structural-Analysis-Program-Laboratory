function plotVertexForceLoads(ax,sm,t,gm,bbox)

import sap.graphics.*

bbox = bbox/1.5;

if isempty(sm.BoundaryConditions)
    return;
end
bc = findboundaryConditions(sm.BoundaryConditions,'Vertex',gm);

if isempty(bc)
    return
else
    fxyz = sm.Geometry.Vertices(bc.RegionID,:);
    fx = bc.XForce;
    fy = bc.YForce;
    [xx,yy] = generateTwoLoadArrow(bbox);
    if fx ~=0
        signFx = fx/abs(fx);
        hold(ax,'on');
        pp=plot(ax,signFx*xx(1,:)+fxyz(1),signFx*xx(3,:)+fxyz(2),...
            'Color','g','LineWidth',0.5);
        text(ax,signFx*xx(1,1)+fxyz(1),signFx*xx(3,1)+fxyz(2),num2str(fx),'Color','g',...
                'FontName','Monospac821 BT','FontSize',9,'VerticalAlignment','top',...
                'HorizontalAlignment','center')         
    elseif fy~=0
        signFy = fy/abs(fy);
        hold(ax,'on');
        pp=plot(ax,signFy*yy(1,:)+fxyz(1),signFy*yy(2,:)+fxyz(2),...
            'Color','g','LineWidth',0.5);          
        text(ax,signFy*yy(1,1)+fxyz(1),signFy*yy(2,1)+fxyz(2),num2str(fy),'Color','g',...
                'FontName','Monospac821 BT','FontSize',9,'VerticalAlignment',...
            'top','HorizontalAlignment','left')                 
    else
        return;
    end
    uistack(pp,'top');
end
end