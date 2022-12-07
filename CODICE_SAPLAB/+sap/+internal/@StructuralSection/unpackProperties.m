function unpackProperties( sectionPropertiesToolBox, hh, g, i )

%geometric properties
sectionPropertiesToolBox.Data.Area = g.A;
sectionPropertiesToolBox.Data.Perimeter = g.P;
sectionPropertiesToolBox.Data.Xg = g.xg;
sectionPropertiesToolBox.Data.Yg = g.yg;
sectionPropertiesToolBox.Data.V = hh;

%inertia properties
sectionPropertiesToolBox.Data.Ixx = i.Ixx;
sectionPropertiesToolBox.Data.Iyy = i.Iyy;
sectionPropertiesToolBox.Data.Ixy = i.Ixy;
sectionPropertiesToolBox.Data.Ivv = i.Ivv;
sectionPropertiesToolBox.Data.Ivw = i.Ivw;
sectionPropertiesToolBox.Data.Iww = i.Iww;
sectionPropertiesToolBox.Data.I11 = i.I11;
sectionPropertiesToolBox.Data.I22 = i.I22;
sectionPropertiesToolBox.Data.Theta11 = i.theta11;
sectionPropertiesToolBox.Data.Theta22 = i.theta22;
end