function [xx,yy,zz] = generateThreeLoadArrow(bbox)

import Tesla.internal.*

[xx,yy,zz] = arrowFcn(bbox); xx = xx-bbox; %get the arrow fcn
av = arrowVect(xx,yy,zz);    
xx = rotate3D_o(av,'X',zeros(1,3),pi/2);
yy = rotate3D_o(av,'Z',zeros(1,3),pi/2);
zz = rotate3D_o(av,'Y',zeros(1,3),-pi/2);
zz = rotate3D_o(zz,'Z',zeros(1,3),-pi/2);
end

