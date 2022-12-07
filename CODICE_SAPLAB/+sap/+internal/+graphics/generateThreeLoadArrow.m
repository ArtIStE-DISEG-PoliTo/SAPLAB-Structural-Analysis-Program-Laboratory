function [xx,yy,zz] = generateThreeLoadArrow(bbox)

import sap.graphics.*

[xx,yy,zz] = arrowFcn(bbox); xx = xx-bbox; %get the arrow fcn
av = arrowVect(xx,yy,zz);    
xx = rotate3D(av,'X',zeros(1,3),pi/2);
yy = rotate3D(av,'Z',zeros(1,3),pi/2);
zz = rotate3D(av,'Y',zeros(1,3),-pi/2);
zz = rotate3D(zz,'Z',zeros(1,3),-pi/2);
end

