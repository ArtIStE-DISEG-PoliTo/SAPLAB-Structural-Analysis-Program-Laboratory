function plotTwoDForceLoads(ax,sm,t,gm,bbox)

import sap.graphics.*

bbox = bbox/1.5;

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
    mz = bc.ZMoment;
    if fx ~=0
        c1=1
        [xx,yy] = generateTwoLoadArrow(bbox);
        hold(ax,'on');
        signFx = fx/abs(fx);
        if fx<0
        quiver(ax,yy(2,2)+fxyz(1),xx(2,2)+fxyz(2),yy(2,1),xx(2,1),'Color','k','LineWidth',0.75,'MaxHeadSize',0.75);         

        text(ax,-signFx*xx(1,1)+fxyz(1),-signFx*xx(2,1)+fxyz(2),['Fx: ' num2str(fx)],'Color',LineColor(t),...
                'FontName','Monospac821 BT','FontSize',12,'VerticalAlignment','top','HorizontalAlignment','center');
        else
        quiver(ax,-yy(2,2)+fxyz(1),-xx(2,2)+fxyz(2),-yy(2,1),-xx(2,1),'Color','k','LineWidth',0.75,'MaxHeadSize',0.75);         
        text(ax,-signFx*xx(1,1)+fxyz(1),-signFx*xx(2,1)+fxyz(2),['Fx: ' num2str(fx)],'Color',LineColor(t),...
                'FontName','Monospac821 BT','FontSize',12,'VerticalAlignment','bottom','HorizontalAlignment','center');            
        end
    end
    if fy~=0

        [xx,yy] = generateTwoLoadArrow(bbox);
        hold(ax,'on');        
        signFy = fy/abs(fy);
        if fy<0
        quiver(ax,xx(2,2)+fxyz(1),yy(2,2)+fxyz(2),xx(2,1),yy(2,1),'Color','k','LineWidth',0.75,'MaxHeadSize',0.75);         

        text(ax,-signFy*yy(1,1)+fxyz(1),-signFy*yy(2,1)+fxyz(2),['Fy: ' num2str(fy)],'Color',LineColor(t),...
                'FontName','Monospac821 BT','FontSize',12,'VerticalAlignment','top','HorizontalAlignment','center');
        else
        quiver(ax,-xx(2,2)+fxyz(1),-yy(2,2)+fxyz(2),-xx(2,1),-yy(2,1),'Color','k','LineWidth',0.75,'MaxHeadSize',0.75);         
        text(ax,-signFy*yy(1,1)+fxyz(1),-signFy*yy(2,1)+fxyz(2),['Fy: ' num2str(fy)],'Color',LineColor(t),...
                'FontName','Monospac821 BT','FontSize',12,'VerticalAlignment','bottom','HorizontalAlignment','center');      
        end  
    end
    if mz~=0
        bbox = bbox/2;
        hold(ax,'on'); 
        if mz>0
            [xx,yy,~] = NegArrowFcn(bbox);
            plot(ax,xx+fxyz(1),yy+fxyz(2),...
                'Color','k','LineWidth',0.75);               
        else
            [xx,yy,~] = PosArrowFcn(bbox);
            plot(ax,xx+fxyz(1),yy+fxyz(2),...
                'Color','k','LineWidth',0.75);               
        end
        if mz < 0
            text(ax,xx(end)+fxyz(1),yy(end)+fxyz(2),['mz: ', num2str(mz)],'Color',LineColor(t),...
                'FontName','Monospac821 BT','FontSize',12,'VerticalAlignment','bottom','HorizontalAlignment','left')    
        else
            text(ax,xx(1)+fxyz(1),yy(1)+fxyz(2),['mz: ', num2str(mz)],'Color',LineColor(t),...
                'FontName','Monospac821 BT','FontSize',12,'VerticalAlignment','top','HorizontalAlignment','center')                
        end
    end
end
end