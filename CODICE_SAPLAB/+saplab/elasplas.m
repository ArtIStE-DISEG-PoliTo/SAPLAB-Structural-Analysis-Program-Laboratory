function mtl = elasplas(fp,up,uf)

x = [-uf -up 0 up uf];
y = [-fp -fp 0 fp fp];

El = fp/up;
Et = 0;

mtl=sap.NonLinearMaterialProperties('force',y,'displacement',x);
mtl.E = El;
mtl.Et = Et;
mtl.up = up;
mtl.uf = uf;

end