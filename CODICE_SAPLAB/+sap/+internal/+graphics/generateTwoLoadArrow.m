function [xx,yy] = generateTwoLoadArrow(bbox)

import sap.graphics.*

[x,y,z] = arrowFcn(bbox); x = x-bbox; %get the arrow fcn
av = arrowVect(x,y,z);    
xx = rotate3D(av,'X',zeros(1,3),pi/2);
yy = rotate3D(av,'Z',zeros(1,3),pi/2);

end

