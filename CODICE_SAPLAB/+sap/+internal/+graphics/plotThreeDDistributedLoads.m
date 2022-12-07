function plotThreeDDistributedLoads(ax,sm,t,gm,bbox)

import sap.graphics.*

g = sm.Geometry;
if isempty(sm.BodyLoads)
    return;
end
bbox = bbox/1.5;
bdl = findStructuralBodyLoads(sm.BodyLoads,'Line',gm);
[fxyz1,fxyz2] = getfxyz(g,gm);
FF=getFollFrame(g,gm);
% ang=getAngles(g,gm); xy = ang(1); zxy = ang(2);
Len=getLength(g,gm);
[xx,yy,zz] = generateThreeLoadArrow(bbox);
if isempty(bdl)
    return
else
    qx=bdl.qx;
    qy=bdl.qy; 
    qz=bdl.qz; 

    xxp=linspace(fxyz2(1),fxyz1(1),2+round(Len));
    yyp=linspace(fxyz2(2),fxyz1(2),2+round(Len));   
    zzp=linspace(fxyz2(3),fxyz1(3),2+round(Len));
    xx = rotate3Dmod(xx,zeros(1,3),FF);
    yy = rotate3Dmod(yy,zeros(1,3),FF);
    zz = rotate3Dmod(zz,zeros(1,3),FF);    
 
    if qy~=0
        for k=1:2+round(Len)
        hold(ax,'on');
        if qy < 0
        quiver3(ax,xx(2,2)-xx(2,1)+xxp(k),yy(2,2)-yy(2,1)+yyp(k),zz(2,2)-zz(2,1)+zzp(k),...
                xx(2,1),yy(2,1),zz(2,1),'Color','r','LineWidth',.5,'MaxHeadSize',0.6);               
        else
        quiver3(ax,xx(2,2)+xxp(k),yy(2,2)+yyp(k),zz(2,2)+zzp(k),...
                -xx(2,1),-yy(2,1),-zz(2,1),'Color','r','LineWidth',.5,'MaxHeadSize',0.6);             
        end
        end
        hold(ax,'on');
        text(ax,0.5*(-xx(2,1)+fxyz1(1)-xx(2,1)+fxyz2(1)),...
            0.5*(-yy(2,1)+fxyz1(2)-yy(2,1)+fxyz2(2)), ...
            0.5*(-zz(2,1)+fxyz1(3)-zz(2,1)+fxyz2(3)),['q_2 :' num2str(qy)],...
            'Color',udlLoadColor(t),'FontName','Monospac821 BT','FontSize',12,...
            'VerticalAlignment','bottom','HorizontalAlignment','center') 
    end
    if qz~=0
        for k=1:2+round(Len)
        if qz < 0
        quiver3(ax,xx(3,2)-xx(3,1)+xxp(k),yy(3,2)-yy(3,1)+yyp(k),zz(3,2)-zz(3,1)+zzp(k),...
                xx(3,1),yy(3,1),zz(3,1),'Color','r','LineWidth',.5,'MaxHeadSize',0.6);               
        else
        quiver3(ax,xx(3,2)+xxp(k),yy(3,2)+yyp(k),zz(3,2)+zzp(k),...
                -xx(3,1),-yy(3,1),-zz(3,1),'Color','r','LineWidth',.5,'MaxHeadSize',0.6);             
        end      
        end
        hold(ax,'on');
        text(ax,0.5*(-xx(3,1)+fxyz1(1)-xx(3,1)+fxyz2(1)),...
            0.5*(-yy(3,1)+fxyz1(2)-yy(3,1)+fxyz2(2)), ...
            0.5*(-zz(3,1)+fxyz1(3)-zz(3,1)+fxyz2(3)),['q_3 :' num2str(qz)],...
            'Color',udlLoadColor(t),'FontName','Monospac821 BT','FontSize',12,...
            'VerticalAlignment','bottom','HorizontalAlignment','center') 
    end    
    if qx~=0
        xxp=linspace(fxyz1(1),fxyz2(1),1+2*round(Len));
        yyp=linspace(fxyz1(2),fxyz2(2),1+2*round(Len)); 
        zzp=linspace(fxyz1(3),fxyz2(3),1+2*round(Len));
%         if qx < 0
%             xxp(1) = [];
%             yyp(1) = [];
%             zzp(1) = [];
%         else
%             xxp(end) = [];
%             yyp(end) = [];            
%             zzp(end) = [];
%         end
        for k=1:1+2*round(Len)
        hold(ax,'on');
        if qx < 0
        quiver3(ax,xx(1,2)-xx(1,1)+xxp(k),yy(1,2)-yy(1,1)+yyp(k),zz(1,2)-zz(1,1)+zzp(k),...
                xx(1,1),yy(1,1),zz(1,1),'Color','r','LineWidth',.95,'MaxHeadSize',0.6);               
        else
        quiver3(ax,xx(1,2)+xxp(k),yy(1,2)+yyp(k),zz(1,2)+zzp(k),...
                -xx(1,1),-yy(1,1),-zz(1,1),'Color','r','LineWidth',.95,'MaxHeadSize',0.6);             
        end             
        end        
        hold(ax,'on');
        text(ax,0.5*(-xx(1,1)+fxyz1(1)-xx(1,1)+fxyz2(1)),...
            0.5*(-yy(1,1)+fxyz1(2)-yy(1,1)+fxyz2(2)), ...
            0.5*(-zz(1,1)+fxyz1(3)-zz(1,1)+fxyz2(3)),['q_1 :' num2str(qx)],...
            'Color',udlLoadColor(t),'FontName','Monospac821 BT','FontSize',12,...
            'VerticalAlignment','bottom','HorizontalAlignment','center')          
    end
end
end