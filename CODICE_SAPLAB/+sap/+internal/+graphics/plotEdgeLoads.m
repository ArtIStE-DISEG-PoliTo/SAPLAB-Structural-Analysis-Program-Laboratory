function plotEdgeLoads(ax,sm,t,gm,bbox)

import sap.graphics.*

if isempty(sm.BoundaryConditions)
    return;
end
bbox = bbox/1.75;
bc = findboundaryConditions(sm.BoundaryConditions,'Edge',gm);

if isempty(bc) || bc.Pressure == 0
    return
else
    [cx,cy,theta,~,inv2]=normToEdge(sm,gm);
    p = bc.Pressure;
    sp = -p/abs(p); 
    if p~=0
       for k=1:numel(cx)
           [~,yy,~] = generateEdgeLoadArrow(bbox,sp);
           yy = rotate3D(yy,'Z',zeros(1,3),pi/2+theta(k));
           hold(ax,'on')
           plot(ax,sp*inv2*yy(1,:)+cx(k),sp*inv2*yy(2,:)+cy(k),'Color',LineColor(t));
           if k == round(numel(cx)/2)
            if p>0
                text(ax,sp*inv2*yy(1,2)+cx(k),sp*inv2*yy(2,2)+cy(k),num2str(p),'Color','r','Color',LineColor(t),...
                'FontName','Monospaced','FontSize',10,'HorizontalAlignment','right','VerticalAlignment','top')          
            else
                text(ax,sp*inv2*yy(1,1)+cx(k),sp*inv2*yy(2,1)+cy(k),num2str(p),'Color','r','Color',LineColor(t),...
                'FontName','Monospaced','FontSize',10,'HorizontalAlignment','left','VerticalAlignment','top')                 
            end
           end
           clear yy
           
       end
    end
end
end