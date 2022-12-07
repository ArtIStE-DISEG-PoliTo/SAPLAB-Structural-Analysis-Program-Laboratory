function [xx,yy,zz] = generateThreeDFrame(ax,bbox)

import sap.graphics.*


[x,y,z] = arrowFcn(bbox); %get the arrow fcn
av = arrowVect(x,y,z);    
xx = rotate3D(av,'X',zeros(1,3),pi/2);
yy = rotate3D(av,'Z',zeros(1,3),pi/2);
zz = rotate3D(av,'Y',zeros(1,3),-pi/2);
zz = rotate3D(zz,'Z',zeros(1,3),-pi/2);
end

