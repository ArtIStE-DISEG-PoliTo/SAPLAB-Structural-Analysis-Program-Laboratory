function RollerZ(ax,bbox,fxyz,dim)

if dim == 3
   
    xxr = [0 0 0 -bbox/5 -bbox/3 -bbox/3 -bbox/5 bbox/5 bbox/5+(bbox/3-bbox/5) bbox/5+(bbox/3-bbox/5) bbox/5 0];
    zzr = [0 -bbox/2.5 0 0 -bbox/9 -bbox/3.5 -bbox/2.5 -bbox/2.5 -bbox/3.5 -bbox/9 0 0];
    
    xxr = [xxr, 0 -bbox/3 bbox/3];
    zzr = [zzr, -bbox/2.5 -bbox/2.5 -bbox/2.5]; 
    yyr = 0.*xxr;
    plot3(ax,-zzr+fxyz(1),yyr+fxyz(2),xxr+fxyz(3),'Color',[0 .7 0]);

end

