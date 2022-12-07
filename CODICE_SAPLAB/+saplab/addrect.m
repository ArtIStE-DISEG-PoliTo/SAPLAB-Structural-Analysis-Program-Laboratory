function tag=addrect(self,dim)
%ADDRECT Add rectangle 

%init geometry
self.initGeometry();

isValidRectangle(dim); %check if it is a valid rectangle
RECT = 3; %rectangle ID.

x = [dim(1) dim(2) dim(2) dim(1)];
y = [dim(3) dim(3) dim(4) dim(4)];

%create the decomposed matrix
gd(1,:)    = RECT; %rectangle
gd(2,:)    = 4; %number of line segment;
gd(3:6,:)  = x'; %vertices x-data;
gd(7:10,:) = y'; %vertices y-data;

%generate tag ...
if isempty(self.Geometry.NumPrimitive)
    np = 1;
else
    np = self.Geometry.NumPrimitive+1;
end

if nargin == 2
    if abs(dim(2)-dim(1)) == abs(dim(4)-dim(3))
       tag  = ['SQ', int2str(np)]; %square
       class = 'Square';
    else 
       tag  = ['R', int2str(np)];  %retangle
       class = 'Rectangle';
    end
end

[dl,bt,dl1,bt1,msb] = decsg(gd); 
csgstruct=csgtodb(self.Geometry,dl,bt,gd,dl1,bt1,msb,tag,class);

tag = csgstruct.tag;
end

function isValidRectangle(dim)
%generate error for incorrect input
if (length(dim)~=4)
  error('Input must be a 4x1 vector.')
end
if ~(any(size(dim)==1))
  error('Input data must be vectors.')
end
if ((dim(1)==dim(2)) || (dim(3)==dim(4)))
  error('Rectangle sides must be > 0.')
end
end


