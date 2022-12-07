function rc=showReferenceSystem(ax,m,i)
%showReferenceSystem plot local reference system
%   

vect   = eye(3);
for j = 1:numel(i)
    rc = m.Geometry.evalTrasformationMatrix(i(j),'components');
    rv = saplab.graphics.rotate3(vect, [0,0,0], rc);
    
    ii = find(m.Geometry.GeometricDomain(:,1)==i(j));
    mid = m.Geometry.GeometricDomain(ii(1),11:13);
    
    bbox=saplab.graphics.set_CanvasBoundingBox(ax.XLim,ax.YLim,ax.ZLim);
    scale = 0.3*mean(mean(bbox));
    quiver3(mid(1),mid(2),mid(3),scale*rv(1,1),scale*rv(1,2),scale*rv(1,3),'-r','Parent',ax,'MaxHeadSize',0.6,'LineWidth',2)
    quiver3(mid(1),mid(2),mid(3),scale*rv(2,1),scale*rv(2,2),scale*rv(2,3),'-g','Parent',ax,'MaxHeadSize',0.6,'LineWidth',2)
    quiver3(mid(1),mid(2),mid(3),scale*rv(3,1),scale*rv(3,2),scale*rv(3,3),'-b','Parent',ax,'MaxHeadSize',0.6,'LineWidth',2)
    
    text(ax,scale*rv(1,1)+mid(1),scale*rv(1,2)+mid(2),scale*rv(1,3)+mid(3),'x','FontSmoothing','on');
    text(ax,scale*rv(2,1)+mid(1),scale*rv(2,2)+mid(2),scale*rv(2,3)+mid(3),'y','FontSmoothing','on');
    text(ax,scale*rv(3,1)+mid(1),scale*rv(3,2)+mid(2),scale*rv(3,3)+mid(3),'z','FontSmoothing','on');
end
end