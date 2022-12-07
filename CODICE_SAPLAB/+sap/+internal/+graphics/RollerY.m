function RollerY(ax,bbox,fxyz,dim)

if dim == 2
    xx = [0 0 0 -bbox/5 -bbox/3 -bbox/3 -bbox/5 bbox/5 bbox/5+(bbox/3-bbox/5) bbox/5+(bbox/3-bbox/5) bbox/5 0];
    yy = [0 -bbox/2.5 0 0 -bbox/9 -bbox/3.5 -bbox/2.5 -bbox/2.5 -bbox/3.5 -bbox/9 0 0];

    xx = [xx, 0 -bbox/2.5 bbox/2.5];
    yy = [yy, -bbox/2.5 -bbox/2.5 -bbox/2.5];
    plot(ax,-yy+fxyz(1),xx+fxyz(2),'Color',[0 .7 0]);
else
    xxp = [0 0 0 -bbox/3.5 bbox/3.5 0];
    zzp = [0 -bbox/2.5 0 -bbox/2.5 -bbox/2.5 0];
    yyp = 0.*xxp;    
    xxr = [0 0 0 -bbox/5 -bbox/3 -bbox/3 -bbox/5 bbox/5 bbox/5+(bbox/3-bbox/5) bbox/5+(bbox/3-bbox/5) bbox/5 0];
    zzr = [0 -bbox/2.5 0 0 -bbox/9 -bbox/3.5 -bbox/2.5 -bbox/2.5 -bbox/3.5 -bbox/9 0 0];
    
    xxr = [xxr, 0 -bbox/3 bbox/3];
    zzr = [zzr, -bbox/2.5 -bbox/2.5 -bbox/2.5]; 
    yyr = 0.*xxr;
    plot3(ax,yyr+fxyz(1),xxr+fxyz(2),zzr+fxyz(3),'Color',[0 .7 0]);
    hold(ax,'on')
    plot3(ax,xxp+fxyz(1),yyp+fxyz(2),zzp+fxyz(3),'Color',[0 .7 0]);
    

end

