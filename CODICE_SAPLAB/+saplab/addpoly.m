function tag = addpoly(self,x,y)

isValidPolygon(x,y); %check if it is a valid polygon

self.initGeometry();

POLY  = 2; %Polygon ID
sz=length(x);
gd(1,:)           = POLY; %polygon
gd(2,:)           = sz; %number of line segment;
gd(3:2+sz,:)      = x'; %vertices x-data;
gd(3+sz:2*sz+2,:) = y'; %vertices y-data;

status = csgchk(gd);
if status(1)==1
    error('Vertices do not define a closed path.');
end

%generate tag ...
if isempty(self.Geometry.NumPrimitive)
    np = 1;
else
    np = self.Geometry.NumPrimitive+1;
end
if nargin == 3
    tag  = ['P', int2str(np)]; %polygon
end
class = 'Polygon';
[dl,bt,dl1,bt1,msb] = decsg(gd); 
csg=csgtodb(self.Geometry,dl,bt,gd,dl1,bt1,msb,tag,class);

tag = csg.tag;
end

function isValidPolygon(x,y)
sz=length(x);
if length(y)~=sz
  error('Polygon x and y coordinate must have the same size.');
end
end
