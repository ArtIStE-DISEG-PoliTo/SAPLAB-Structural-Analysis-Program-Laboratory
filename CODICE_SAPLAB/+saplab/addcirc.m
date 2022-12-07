function tag=addcirc(self,c,r)

if isempty(self.Geometry)
    initGeometry(self);
end

xc=c(1);
yc=c(2);

isValidCircle(xc, yc, r); %check if it is a valid circle
CIRC = 1; %circle ID.

%create the decomposed matrix
gd(1,:)    = CIRC; %circle
gd(2,:)    = xc; %x center coordinate;
gd(3,:)    = yc; %y center coordinate;
gd(4,:)    = r; %radius;

%generate tag ...
if isempty(self.Geometry.NumPrimitive)
    np = 1;
else
    np = self.Geometry.NumPrimitive+1;
end

tag  = ['C', int2str(np)]; 
class = 'Circle';
[dl,bt,dl1,bt1,msb] = decsg(gd); 
csg=csgtodb(self.Geometry,dl,bt,gd,dl1,bt1,msb,tag,class);

tag = csg.tag;

end

function isValidCircle(xc, yc, r)
    if ~(all(size(xc)==1) && all(size(yc)==1) && all(size(r)==1))
      error('Data must be scalar')
    end
    if r<=0
      error('Radius must be positive')
    end
end
