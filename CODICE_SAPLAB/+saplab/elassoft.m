function mtl = elassoft(fp,up,uf)

x = [-20*uf -uf -up 0 up uf 20*uf];
y = [0 0 -fp 0 fp 0 0];
El = (y(5)-y(4))/(x(5)-x(4));
Et = (y(6)-y(5))/(x(6)-x(5));

mtl=sap.NonLinearMaterialProperties('force',y,'displacement',x);
mtl.E = El;
mtl.Et = Et;
mtl.up = up;
mtl.uf = uf;

end