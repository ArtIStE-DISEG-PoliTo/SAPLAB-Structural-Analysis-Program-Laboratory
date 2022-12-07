function plotThreeDForceLoads(ax,sm,t,gm,bbox)

import sap.graphics.*

bbox = bbox/2;

g = sm.Geometry;
if isempty(sm.BoundaryConditions)
    return;
end
bc = findboundaryConditions(sm.BoundaryConditions,'Point',gm);
fxyz = getPfxyz(g,gm);
if isempty(bc)
    return
else
    fx = bc.XForce;
    fy = bc.YForce;
    fz = bc.ZForce;
    mx = bc.XMoment;
    my = bc.YMoment;
    mz = bc.ZMoment;
    [xx,yy,zz] = generateThreeLoadArrow(bbox);
    if fx ~=0
        signFx = fx/abs(fx);
        if fx<0
        quiver3(ax,yy(2,2)+fxyz(1),xx(2,2)+fxyz(2),zz(2,2)+fxyz(3),yy(2,1),xx(2,1),zz(2,1),'Color','r','LineWidth',1,'MaxHeadSize',0.8);         

        text(ax,-signFx*xx(1,1)+fxyz(1),-signFx*xx(2,1)+fxyz(2),-signFx*xx(3,1)+fxyz(3),['Fx: ' num2str(fx)],'Color',LineColor(t),...
                'FontName','Monospac821 BT','FontSize',12,'VerticalAlignment','top','HorizontalAlignment','center');
        else
        quiver3(ax,-yy(2,2)+fxyz(1),-xx(2,2)+fxyz(2),-zz(2,2)+fxyz(3),-yy(2,1),-xx(2,1),-zz(2,1),'Color','r','LineWidth',1,'MaxHeadSize',0.8);         
        text(ax,-signFx*xx(1,1)+fxyz(1),-signFx*xx(2,1)+fxyz(2),-signFx*xx(3,1)+fxyz(3),['Fx: ' num2str(fx)],'Color',LineColor(t),...
                'FontName','Monospac821 BT','FontSize',12,'VerticalAlignment','bottom','HorizontalAlignment','center');            
        end
    end
    if fy~=0
        signFy = fy/abs(fy);
        hold(ax,'on');
        if fy<0
        quiver3(ax,xx(2,2)+fxyz(1),yy(2,2)+fxyz(2),zz(2,2)+fxyz(3),xx(2,1),yy(2,1),zz(2,1),'Color','r','LineWidth',1,'MaxHeadSize',0.8);         

        text(ax,-signFy*yy(1,1)+fxyz(1),-signFy*yy(2,1)+fxyz(2),-signFy*yy(3,1)+fxyz(3),['Fy: ' num2str(fy)],'Color',LineColor(t),...
                'FontName','Monospac821 BT','FontSize',12,'VerticalAlignment','top','HorizontalAlignment','center');
        else
        quiver3(ax,-xx(2,2)+fxyz(1),-yy(2,2)+fxyz(2),-zz(2,2)+fxyz(3),-xx(2,1),-yy(2,1),-zz(2,1),'Color','r','LineWidth',1,'MaxHeadSize',0.8);         
        text(ax,-signFy*yy(1,1)+fxyz(1),-signFy*yy(2,1)+fxyz(2),-signFy*yy(3,1)+fxyz(3),['Fy: ' num2str(fy)],'Color',LineColor(t),...
                'FontName','Monospac821 BT','FontSize',12,'VerticalAlignment','bottom','HorizontalAlignment','center');            
        end
    end
    if fz~=0
        signFz = fz/abs(fz);
        hold(ax,'on');
        if fz<0
        quiver3(ax,zz(2,2)+fxyz(1),xx(2,2)+fxyz(2),yy(2,2)+fxyz(3),zz(2,1),xx(2,1),yy(2,1),'Color','r','LineWidth',1,'MaxHeadSize',0.8);         

        text(ax,-signFz*zz(1,1)+fxyz(1),-signFz*zz(2,1)+fxyz(2),-signFz*zz(3,1)+fxyz(3),['Fz: ' num2str(fz)],'Color',LineColor(t),...
                'FontName','Monospac821 BT','FontSize',12,'VerticalAlignment','top','HorizontalAlignment','center');
        else
        quiver3(ax,-zz(2,2)+fxyz(1),-xx(2,2)+fxyz(2),-yy(2,2)+fxyz(3),-zz(2,1),-xx(2,1),-yy(2,1),'Color','r','LineWidth',1,'MaxHeadSize',0.8);         
        text(ax,-signFz*zz(1,1)+fxyz(1),-signFz*zz(2,1)+fxyz(2),-signFz*zz(3,1)+fxyz(3),['Fz: ' num2str(fz)],'Color',LineColor(t),...
                'FontName','Monospac821 BT','FontSize',12,'VerticalAlignment','bottom','HorizontalAlignment','center');            
        end
    end
    if mx~=0
        bbox = bbox/2;
        if mx<0
            [xx,yy,zz] = PosArrowFcn(bbox);
            hold(ax,'on');
            plot3(ax,zz+fxyz(1),xx+fxyz(2),yy+fxyz(3),...
                'Color','r','LineWidth',.5);               
        else
            [xx,yy,zz] = NegArrowFcn(bbox);
            hold(ax,'on');
            plot3(ax,zz+fxyz(1),xx+fxyz(2),yy+fxyz(3),......
                'Color','r','LineWidth',.5);               
        end
            text(ax,zz(1)+fxyz(1),xx(1)+fxyz(2),yy(1)+fxyz(3),num2str(mx),'Color',LineColor(t),...
                'FontName','Monospac821 BT','FontSize',11,'VerticalAlignment','top','HorizontalAlignment','left')    
    end
    if my~=0
        bbox = bbox/2;
        if my<0
            [xx,yy,zz] = PosArrowFcn(bbox);
            hold(ax,'on');
            plot3(ax,xx+fxyz(1),zz+fxyz(2),yy+fxyz(3),...
                'Color','r','LineWidth',.5);               
        else
            [xx,yy,zz] = NegArrowFcn(bbox);
            hold(ax,'on');
            plot3(ax,xx+fxyz(1),zz+fxyz(2),yy+fxyz(3),......
                'Color','r','LineWidth',.5);               
        end
            text(ax,xx(1)+fxyz(1),zz(1)+fxyz(2),yy(1)+fxyz(3),num2str(my),'Color',LineColor(t),...
                'FontName','Monospac821 BT','FontSize',11,'VerticalAlignment','top','HorizontalAlignment','left')        
    end
    if mz~=0
        bbox = bbox/2;
        if mz<0
            [xx,yy,zz] = PosArrowFcn(bbox);
            hold(ax,'on');
            plot3(ax,xx+fxyz(1),yy+fxyz(2),zz+fxyz(3),...
                'Color','r','LineWidth',.5);               
        else
            [xx,yy,zz] = NegArrowFcn(bbox);
            hold(ax,'on');
            plot3(ax,xx+fxyz(1),yy+fxyz(2),zz+fxyz(3),......
                'Color','r','LineWidth',.5);               
        end
            text(ax,xx(1)+fxyz(1),yy(1)+fxyz(2),zz(1)+fxyz(3),num2str(mz),'Color',LineColor(t),...
                'FontName','Monospac821 BT','FontSize',11,'VerticalAlignment','top','HorizontalAlignment','left')                              
    end
end
end