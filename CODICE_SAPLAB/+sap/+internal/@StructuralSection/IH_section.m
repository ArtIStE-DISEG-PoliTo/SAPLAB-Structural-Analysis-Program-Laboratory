function [dl, IH] = IH_section(b, h, tf, tw, r, roll)

narginchk(5,6);
nargoutchk(1,2);

warning off;

x = linspace(0,2*pi);
xc = r*cos(x);
yc = r*sin(x);

botWing = polyshape([0 b b 0],[0 0 tw tw]);
topWing = polyshape([0 b b 0],[h-tw h-tw h h]);
flange  = polyshape(.5*[b-tf b+tf b+tf b-tf],[tw tw h-tw h-tw]);

square1 = polyshape([b/2-tf/2 b/2-tf/2 b/2-tf/2-r b/2-tf/2-r],[tw tw+r tw+r tw]);
square2 = polyshape([b/2+tf/2 b/2+tf/2 b/2+tf/2+r b/2+tf/2+r],[tw tw+r tw+r tw]);
square3 = polyshape([b/2+tf/2 b/2+tf/2 b/2+tf/2+r b/2+tf/2+r],[h-tw h-tw-r h-tw-r h-tw]);
square4 = polyshape([b/2-tf/2 b/2-tf/2 b/2-tf/2-r b/2+tf/2-r],[h-tw-r h-tw h-tw h-tw-r]);
circle1 = polyshape(xc+b/2-tf/2-r,yc+tw+r); 
circle1 = subtract(square1,circle1);
circle2 = polyshape(xc+b/2+tf/2+r,yc+tw+r); 
circle2 = subtract(square2,circle2);
circle3 = polyshape(xc+b/2+tf/2+r,yc+h-tw-r); 
circle3 = subtract(square3,circle3);
circle4 = polyshape(xc+b/2-tf/2-r,yc+h-tw-r); 
circle4 = subtract(square4,circle4);

polyvect = [botWing; topWing; flange; circle1; circle2; circle3; circle4];
IH = union(polyvect);
if ~isempty(roll)
   IH = rotate(IH,roll); 
end
dl = IH.Vertices;

end

