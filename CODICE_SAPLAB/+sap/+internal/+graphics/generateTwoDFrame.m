function [xx,yy] = generateTwoDFrame(ax)

import sap.graphics.*

bbox = evalBoundingBox(ax); bbox = bbox/1.25;%evaluate bounding box
[x,y,z] = arrowFcn(bbox); %get the arrow fcn
av = arrowVect(x,y,z);    
xx = rotate3D(av,'X',zeros(1,3),pi/2);
yy = rotate3D(av,'Z',zeros(1,3),pi/2);
end

