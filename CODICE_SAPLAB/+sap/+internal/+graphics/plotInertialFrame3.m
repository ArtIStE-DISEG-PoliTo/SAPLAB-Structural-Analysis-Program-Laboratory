function plotInertialFrame3(ax,t)
    
import sap.graphics.*

bbox = evalBoundingBox(ax); %evaluate bounding box
[x,y,z] = arrowFcn(bbox); %get the arrow fcn
av = arrowVect(x,y,z);

xx = rotate3D(av,'X',zeros(1,3),pi/2);
yy = rotate3D(av,'Z',zeros(1,3),pi/2);
yy = rotate3D(yy,'Y',zeros(1,3),pi/2);
zz = rotate3D(av,'Y',zeros(1,3),-pi/2);
zz = rotate3D(zz,'Z',zeros(1,3),-pi/2);

quiver3(ax,x(1,1),y(1,1),z(1,1),bbox,0,0,'Color',[.7 0 0],'MaxHeadSize',.7,'Linewidth',1);
hold(ax,'on');
quiver3(ax,x(1,1),y(1,1),z(1,1),0,bbox,0,'Color',[0 0.7 0],'MaxHeadSize',.7,'Linewidth',1);
hold(ax,'on');
quiver3(ax,x(1,1),y(1,1),z(1,1),0,0,bbox,'Color',[0 0 .7],'MaxHeadSize',.7,'Linewidth',1);

text(ax,xx(1,2),xx(2,2),xx(3,2),'X','VerticalAlignment','middle',...
    'HorizontalAlignment','left','FontName','Monospac821 BT','Color',[.7 0 0],'FontSize',17,'FontWeight','bold');
text(ax,yy(1,2),yy(2,2),yy(3,2),'Y','VerticalAlignment','bottom',...
    'HorizontalAlignment','center','FontName','Monospac821 BT','Color',[0 0.7 0],'FontSize',17,'FontWeight','bold');
text(ax,zz(1,2),zz(2,2),zz(3,2),'Z','VerticalAlignment','bottom',...
    'HorizontalAlignment','center','FontName','Monospac821 BT','Color',[0 0 .7],'FontSize',17,'FontWeight','bold');end

