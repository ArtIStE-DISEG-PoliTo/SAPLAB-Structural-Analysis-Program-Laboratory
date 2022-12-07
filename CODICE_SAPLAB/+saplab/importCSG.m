function gm = importCSG(DL)
%IMPORTCSG import 2-D constructive solid geometry

narginchk(1,1)
nargoutchk(1,1);

m = saplab.create('Attributes','static-planestress');
m.initGeometry();

gm = impCSG(m.Geometry,DL);

end