function plotTwoDDistributedLoads(ax,sm,t,gm,bbox)

import sap.graphics.*
bbox = bbox/1.5;
g = sm.Geometry;
if isempty(sm.BodyLoads)
    return;
end
bdl = findStructuralBodyLoads(sm.BodyLoads,'Line',gm);
FF=getFollFrame(g,gm);
[fxyz1,fxyz2] = getfxyz(g,gm);
ang=getAngles(g,gm); xy = ang(1); zxy = ang(2);
Len=getLength(g,gm);
[xx,yy] = generateTwoLoadArrow(bbox);
if isempty(bdl)
    return
else
    qx=bdl.qx; signqx = qx/(abs(qx));
    qy=bdl.qy; signqy = qy/(abs(qy));
    if qx~=0
        xx(3,:) = xx(3,:)+0.2*bbox;
    end    
    xxp=linspace(fxyz1(1),fxyz2(1),2+round(Len));
    yyp=linspace(fxyz1(2),fxyz2(2),2+round(Len));   
    xx = rotate3Dmod(xx,zeros(1,3),FF);
    yy = rotate3Dmod(yy,zeros(1,3),FF); 
    if qy~=0
        for k=1:2+round(Len)
        hold(ax,'on');
        if qy < 0
        quiver(ax,xx(2,2)-xx(2,1)+xxp(k),yy(2,2)-yy(2,1)+yyp(k),...
                xx(2,1),yy(2,1),'Color','r','LineWidth',.5,'MaxHeadSize',0.8);               
        else
        quiver(ax,xx(2,2)+xxp(k),yy(2,2)+yyp(k),...
                -xx(2,1),-yy(2,1),'Color','r','LineWidth',.5,'MaxHeadSize',0.8);             
        end
        end
        hold(ax,'on');
        text(ax,0.5*(-xx(2,1)+fxyz1(1)-xx(2,1)+fxyz2(1)),...
            0.5*(-yy(2,1)+fxyz1(2)-yy(2,1)+fxyz2(2)),['q_2 :' num2str(qy)],...
            'Color',udlLoadColor(t),'FontName','Monospac821 BT','FontSize',12,...
            'VerticalAlignment','bottom','HorizontalAlignment','center') 
    end
    
    if qx~=0
        xxp=linspace(fxyz1(1),fxyz2(1),2*round(Len));
        yyp=linspace(fxyz1(2),fxyz2(2),2*round(Len));   

        for k=1:2*round(Len)
        hold(ax,'on');
        if qx < 0
        quiver(ax,xx(1,2)-xx(1,1)+xxp(k),yy(1,2)-yy(1,1)+yyp(k),...
                xx(1,1),yy(1,1),'Color','r','LineWidth',.95,'MaxHeadSize',0.8);               
        else
        quiver(ax,xx(1,2)+xxp(k),yy(1,2)+yyp(k),...
                -xx(1,1),-yy(1,1),'Color','r','LineWidth',.95,'MaxHeadSize',0.8);             
        end             
        end        
        hold(ax,'on');
        text(ax,0.5*(-xx(1,1)+fxyz1(1)-xx(1,1)+fxyz2(1)),...
            0.5*(-yy(1,1)+fxyz1(2)-yy(1,1)+fxyz2(2)),['q_1 :' num2str(qx)],...
            'Color',udlLoadColor(t),'FontName','Monospac821 BT','FontSize',12,...
            'VerticalAlignment','bottom','HorizontalAlignment','center')     
    end
end
end