function plotThreeDDistributedMoments(ax,sm,t,gm,bbox)

import sap.graphics.*

bbox = bbox/1.25;

g = sm.Geometry;
if isempty(sm.BodyLoads)
    return;
end

bdl = findStructuralBodyLoads(sm.BodyLoads,'Line',gm);
Len=getLength(g,gm);
[fxyz1,fxyz2] = getfxyz(g,gm); ang=getAngles(g,gm); xy = ang(1); zxy = ang(2);
if isempty(bdl)
    return
else
    mx = bdl.mx;
    my = bdl.my;
    mz = bdl.mz;
    if mz ~=0
       xxp=linspace(fxyz1(1),fxyz2(1),1+round(Len));
       yyp=linspace(fxyz1(2),fxyz2(2),1+round(Len));   
       zzp=linspace(fxyz1(3),fxyz2(3),1+round(Len));     
       if mz<0
           [xx,yy,zz] = PosArrowFcn(bbox); av = [xx;yy;zz];
           av = rotate3D(av,'X',zeros(1,3),pi/2);
           av = rotate3D(av,'Z',zeros(1,3),xy*pi/180);          
           for k=1:1+round(Len)
            hold(ax,'on');
            plot3(ax,av(1,:)+xxp(k),av(2,:)+yyp(k),av(3,:)+zzp(k),...
                'Color','r','LineWidth',1);                
           end     
        
       elseif mz>0
           [xx,yy,zz] = NegArrowFcn(bbox);
           av = [xx;yy;zz];
           av = rotate3D(av,'X',zeros(1,3),pi/2);
           av = rotate3D(av,'Z',zeros(1,3),xy*pi/180);           
           for k=1:1+round(Len)
            hold(ax,'on');
            plot3(ax,av(1,:)+xxp(k),av(2,:)+yyp(k),av(3,:)+zzp(k),...
                'Color','r','LineWidth',1);                 
           end  
       else
           return;
       end
            text(ax,0.5*(fxyz1(1)+fxyz2(1)),...
                0.5*(fxyz1(2)+fxyz2(2)), ...
                0.5*(fxyz1(3)+fxyz2(3))+bbox,['m3: ' num2str(mz)],...
                'Color',LineColor(t),'FontName','Monospac821 BT','FontSize',12,...
                'VerticalAlignment','bottom','HorizontalAlignment','center')            
    end
    if mx ~=0
       xxp=linspace(fxyz1(1),fxyz2(1),1+round(Len));
       yyp=linspace(fxyz1(2),fxyz2(2),1+round(Len));   
       zzp=linspace(fxyz1(3),fxyz2(3),1+round(Len));     
       if mx<0
           [xx,yy,zz] = PosArrowFcn(bbox); av = [xx;yy;zz];
           av = rotate3D(av,'Y',zeros(1,3),zxy*pi/180); 
           av = rotate3D(av,'Z',zeros(1,3),-xy*pi/180+pi/2);
           
           for k=1:1+round(Len)
            hold(ax,'on');
            plot3(ax,av(3,:)+xxp(k),av(2,:)+yyp(k),av(1,:)+zzp(k),...
                'Color','r','LineWidth',1);             
           end     
        
       elseif mx>0
           [xx,yy,zz] = NegArrowFcn(bbox); av = [xx;yy;zz];
           av = rotate3D(av,'Y',zeros(1,3),zxy*pi/180); 
           av = rotate3D(av,'Z',zeros(1,3),-xy*pi/180+pi/2);           
           for k=1:1+round(Len)
            hold(ax,'on');
            plot3(ax,av(3,:)+xxp(k),av(2,:)+yyp(k),av(1,:)+zzp(k),...
                'Color','r','LineWidth',1);              
           end  
       else
           return;
       end
            text(ax,0.5*(fxyz1(1)+fxyz2(1)),...
                0.5*(fxyz1(2)+fxyz2(2)), ...
                0.5*(fxyz1(3)+fxyz2(3))+bbox,['m1: ' num2str(mx)],...
                'Color',LineColor(t),'FontName','Monospac821 BT','FontSize',12,...
                'VerticalAlignment','bottom','HorizontalAlignment','center')         
    end    
    if my ~=0
       xxp=linspace(fxyz1(1),fxyz2(1),1+round(Len));
       yyp=linspace(fxyz1(2),fxyz2(2),1+round(Len));   
       zzp=linspace(fxyz1(3),fxyz2(3),1+round(Len));     
       if my<0
           [xx,yy,zz] = PosArrowFcn(bbox);
           for k=1:1+round(Len)
            hold(ax,'on');
            plot3(ax,xx+xxp(k),yy+yyp(k),zz+zzp(k),...
                'Color','r','LineWidth',1);                
           end     
        
       elseif my>0
           [xx,yy,zz] = NegArrowFcn(bbox);
           for k=1:1+round(Len)
            hold(ax,'on');
            plot3(ax,xx+xxp(k),yy+yyp(k),zz+zzp(k),...
                'Color','r','LineWidth',1);                
           end  
       else
           return;
       end
            text(ax,0.5*(fxyz1(1)+fxyz2(1)),...
                0.5*(fxyz1(2)+fxyz2(2)), ...
                0.5*(fxyz1(3)+fxyz2(3))+bbox,['m2: ' num2str(my)],...
                'Color',LineColor(t),'FontName','Monospac821 BT','FontSize',12,...
                'VerticalAlignment','bottom','HorizontalAlignment','center')       
    end      
end
end