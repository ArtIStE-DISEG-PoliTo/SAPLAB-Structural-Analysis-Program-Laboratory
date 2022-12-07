function [geom, inertia] = evaluateProperties( hh )

narginchk(1,1);
nargoutchk(1,3);
isValidPolygon(hh);

geom = struct('A',[],'P',[],'xg',[],'yg',[]);
inertia = struct('Ivv',[],'Iww',[],'Ivw',[],'Ixx',[],'Iyy',[],'Ixy',[],...
                 'Ip',[],'I11',[],'I22',[],'theta11',[],'theta22',[]);

xm = mean(hh(:,1));
ym = mean(hh(:,2));
x = hh(:,1)-xm;
y = hh(:,2)-ym;
xsum = x([2:end 1]);
ysum = y([2:end 1]);
dx = xsum - x;
dy = ysum - y;
da = x.*ysum-xsum.*y;
a = sum(da)/2;
p = sum(sqrt(dx.*dx +dy.*dy));
xg = sum((x+xsum).*da)/6/a;
yg = sum((y+ysum).*da)/6/a;
Ixx = sum((y.*y +y.*ysum + ysum.*ysum).*da)/12;
Iyy = sum((x.*x +x.*xsum + xsum.*xsum).*da)/12;
Ixy = sum((x.*ysum +2*x.*y +2*xsum.*ysum + xsum.*y).*da)/24;
if a < 0
  a = -a;
  Ixx = -Ixx;
  Iyy = -Iyy;
  Ixy = -Ixy;
end

% compute centroid moments (Axis are // to global X,Y)
Ivv = Ixx - a*yg^2;
Iww = Iyy - a*xg^2;
Ivw = Ixy - a*xg*yg;
Ip = Ivv + Iww;
xg = xg + xm;
yg = yg + ym;
% compute global moments (Global X,Y)
Ixx = Ivv + a*yg^2;
Iyy = Iww + a*xg^2;
Ixy = Ivw + a*xg*yg;
%evaluate principal moments and orientation.
Imat = [ Ivv  -Ivw ; -Ivw   Iww ];
[eig_vec,eig_val] = eig(Imat);
I11 = eig_val(1,1);
I22 = eig_val(2,2);
theta11 = atan2d(eig_vec(2,1),eig_vec(1,1));
theta22 = atan2d(eig_vec(2,2),eig_vec(1,2));

geom.A = a;
geom.P = p;
geom.xg = xg;
geom.yg = yg;

inertia.Ivv = Ivv;
inertia.Iww = Iww;
inertia.Ivw = Ivw;
inertia.Ixx = Ixx;
inertia.Iyy = Iyy;
inertia.Ixy = Ixy;
inertia.Ip = Ip;
inertia.I11 = I11;
inertia.I22 = I22;
inertia.theta11 = theta11;
inertia.theta22 = theta22;

end

function isValidPolygon(hh)
if size(hh,2)>2
 error(['Invalid polygon coordinates matrix.' ...
        'Specify polygon''s coordinates as da nx2 matrix.']); 
elseif size(hh,1)<3         
 error('Insufficient number of vertices.');                   
end
if ~isequal( size(hh(:,1)), size(hh(:,2)) )
  error( 'X and Y must be the same size');
end  
end