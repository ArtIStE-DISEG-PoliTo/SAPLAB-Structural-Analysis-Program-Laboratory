function FixedEdge(ax,bbox,fxyz,dim)

if dim == 2
    xx = [0 0 -bbox/2.5 -bbox/2.5 bbox/2.5 bbox/2.5 -bbox/2.5 0 0];
    yy = [0 -bbox/12 -bbox/12 -bbox/2.5 -bbox/2.5 -bbox/12 -bbox/12 -bbox/12 -bbox/2.5];
    hold(ax,'on')
    pp=plot(ax,xx+fxyz(1),yy+fxyz(2),'Color',[0 .7 0]); %#ok
else
    xx = [0 0 -bbox/2.5 -bbox/2.5 bbox/2.5 bbox/2.5 -bbox/2.5 0 0];
    zz = [0 -bbox/12 -bbox/12 -bbox/2.5 -bbox/2.5 -bbox/12 -bbox/12 -bbox/12 -bbox/2.5]; 
    yy = 0.*xx;
    hold(ax,'on')
    pp1=plot3(ax,xx+fxyz(1),yy+fxyz(2),zz+fxyz(3),'Color',[0 .7 0]); %#ok
    hold(ax,'on')
    pp2=plot3(ax,yy+fxyz(1),xx+fxyz(2),zz+fxyz(3),'Color',[0 .7 0]); %#ok 

end



end

