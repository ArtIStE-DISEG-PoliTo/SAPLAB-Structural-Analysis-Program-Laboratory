function plotThreeDDistributedMoments(ax,sm,t,gm,bbox)

import sap.graphics.*

bbox = bbox/1.1;

g = sm.Geometry;
if isempty(sm.BodyLoads)
    return;
end
bdl = findStructuralBodyLoads(sm.BodyLoads,'Line',gm);
Len=getLength(g,gm);
[fxyz1,fxyz2] = getfxyz(g,gm);
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
           [xx,yy,zz] = PosArrowFcn(bbox);
           for k=1:1+round(Len)
            hold(ax,'on');
            plot3(ax,xx+xxp(k),zz+yyp(k),yy+zzp(k),...
                'Color',LineColor(t),'LineWidth',.5);                
           end     
        
       elseif mz>0
           [xx,yy,zz] = NegArrowFcn(bbox);
           for k=1:1+round(Len)
            hold(ax,'on');
            plot3(ax,xx+xxp(k),zz+yyp(k),yy+zzp(k),...
                'Color',LineColor(t),'LineWidth',.5);                
           end  
       else
           return;
       end
            text(ax,0.5*(fxyz1(1)+fxyz2(1)),...
                0.5*(fxyz1(2)+fxyz2(2)), ...
                0.5*(fxyz1(3)+fxyz2(3))+bbox,num2str(mz),...
                'Color',LineColor(t),'FontName','Monospac821 BT','FontSize',9,...
                'VerticalAlignment','bottom','HorizontalAlignment','center')            
    end
    if mx ~=0
       xxp=linspace(fxyz1(1),fxyz2(1),1+round(Len));
       yyp=linspace(fxyz1(2),fxyz2(2),1+round(Len));   
       zzp=linspace(fxyz1(3),fxyz2(3),1+round(Len));     
       if mx<0
           [xx,yy,zz] = PosArrowFcn(bbox);
           for k=1:1+round(Len)
            hold(ax,'on');
            plot3(ax,zz+xxp(k),xx+yyp(k),yy+zzp(k),...
                'Color',LineColor(t),'LineWidth',.5);                
           end     
        
       elseif mx>0
           [xx,yy,zz] = NegArrowFcn(bbox);
           for k=1:1+round(Len)
            hold(ax,'on');
            plot3(ax,zz+xxp(k),xx+yyp(k),yy+zzp(k),...
                'Color',LineColor(t),'LineWidth',.5);              
           end  
       else
           return;
       end
            text(ax,0.5*(fxyz1(1)+fxyz2(1)),...
                0.5*(fxyz1(2)+fxyz2(2)), ...
                0.5*(fxyz1(3)+fxyz2(3))+bbox,num2str(mx),...
                'Color',LineColor(t),'FontName','Monospac821 BT','FontSize',9,...
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
                'Color',LineColor(t),'LineWidth',.5);                
           end     
        
       elseif my>0
           [xx,yy,zz] = NegArrowFcn(bbox);
           for k=1:1+round(Len)
            hold(ax,'on');
            plot3(ax,xx+xxp(k),yy+yyp(k),zz+zzp(k),...
                'Color',LineColor(t),'LineWidth',.5);                
           end  
       else
           return;
       end
            text(ax,0.5*(fxyz1(1)+fxyz2(1)),...
                0.5*(fxyz1(2)+fxyz2(2)), ...
                0.5*(fxyz1(3)+fxyz2(3))+0.75*bbox,num2str(my),...
                'Color',LineColor(t),'FontName','Monospac821 BT','FontSize',9,...
                'VerticalAlignment','bottom','HorizontalAlignment','center')        
    end      
end
end