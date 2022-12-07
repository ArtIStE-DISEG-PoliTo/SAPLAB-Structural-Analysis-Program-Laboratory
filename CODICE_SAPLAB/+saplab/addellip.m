function tag=addellip(self,center,radius,phi)
%ADDELLIP - Add elliptical surface to model geometry

if nargin == 3
    phi = 0;
end

self.initGeometry();

xc = center(1);
yc = center(2);
rx = radius(1);
ry = radius(2);

if rx == ry
    error('Use saplab.addcirc to create circle surfaces.');
end

isValidEllipse(xc, yc, rx, ry, phi); %check if it is a valid ellipse
ELLIP=4; %ellipse_ID

%create the decomposed matrix
gd(1,:)    = ELLIP; %ellipse
gd(2,:)    = xc; %x center coordinate;
gd(3,:)    = yc; %y center coordinate;
gd(4,:)    = rx; %radius x;
gd(5,:)    = ry; %radius x;
gd(6,:)    = phi; %angle;
gd(7:10,:) = 0;

%generate tag ...
if isempty(self.Geometry.NumPrimitive)
    np = 1;
else
    np = self.Geometry.NumPrimitive+1;
end

if nargin <= 6
    tag  = ['EL', int2str(np)]; %ellipse
end
class = 'Ellipse';
[dl,bt,dl1,bt1,msb] = decsg(gd); 
csg=csgtodb(self.Geometry,dl,bt,gd,dl1,bt1,msb,tag,class);

tag = csg.tag;
end

function isValidEllipse(xc, yc, rx, ry, phi)
if ~(all(size(xc)==1) && all(size(yc)==1) && ...
    all(size(rx)==1) && all(size(ry)==1) && all(size(phi)==1))
    error('Data must be scalar')
end
if ~((rx>0) && (ry>0))
  error('Ellipse semi-axis length must be positive.')
end

end
