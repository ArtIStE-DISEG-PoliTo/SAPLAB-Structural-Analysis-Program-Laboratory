function plotTwoDDistributedMoments(ax,sm,t,gm,bbox)

import sap.graphics.*

bbox = bbox/4;

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
    mz = bdl.mz;
    if mz ~=0
       xxp=linspace(fxyz1(1),fxyz2(1),2+round(Len));
       yyp=linspace(fxyz1(2),fxyz2(2),2+round(Len));          
       if mz>0
           [xx,yy,~] = PosArrowFcn(bbox);
           for k=1:2+round(Len)
            hold(ax,'on');
            plot(ax,xx+xxp(k),yy+yyp(k),...
                'Color','r','LineWidth',1);                
           end     
        
       elseif mz<0
           [xx,yy,~] = NegArrowFcn(bbox);
           for k=1:2+round(Len)
            hold(ax,'on');
            plot(ax,xx+xxp(k),yy+yyp(k),...
                'Color','r','LineWidth',1);                
           end  
       else
           return;
       end
            text(ax,0.5*(fxyz1(1)+fxyz2(1)),...
                0.5*(fxyz1(2)+fxyz2(2)),['m3: ' num2str(mz)],...
                'Color',LineColor(t),'FontName','Monospac821 BT','FontSize',11,...
                'VerticalAlignment','top','HorizontalAlignment','left')         
    end
end
end