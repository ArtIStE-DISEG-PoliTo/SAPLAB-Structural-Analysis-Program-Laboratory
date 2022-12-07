function plotInertialFrame2(ax,t)
    
import sap.graphics.*

bbox = evalBoundingBox(ax); %evaluate bounding box
bbox=bbox;
[x,y,z] = arrowFcn(bbox); %get the arrow fcn
av = arrowVect(x,y,z);

xx = rotate3D(av,'X',zeros(1,3),pi/2);
yy = rotate3D(av,'Z',zeros(1,3),pi/2);
quiver(ax,x(1,1),y(1,1),bbox,0,'Color',[0.07 0.12 0.32],'MaxHeadSize',.65,'Linewidth',1);
hold(ax,'on');
quiver(ax,x(1,1),y(1,1),0,bbox,'Color',[0.07 0.12 0.32],'MaxHeadSize',.65,'Linewidth',1);

text(ax,xx(1,2),xx(3,2),'X','VerticalAlignment','middle',...
    'HorizontalAlignment','left','FontName','Monospac821 BT','Color',[0.07 0.12 0.32],'FontSize',15,'FontWeight','normal');
text(ax,yy(1,2),yy(2,2),'Y','VerticalAlignment','bottom',...
    'HorizontalAlignment','center','FontName','Monospac821 BT','Color',[0.07 0.12 0.32],'FontSize',15,'FontWeight','normal');

end

