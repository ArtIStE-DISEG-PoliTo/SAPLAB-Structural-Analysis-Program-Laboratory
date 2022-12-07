function PinnedX(ax,bbox,fxyz,dim)

if dim == 2
    xx = [0 0 0 -bbox/3.5 bbox/3.5 0];
    yy = [0 -bbox/2.5 0 -bbox/2.5 -bbox/2.5 0];
    hold(ax,'on')
    plot(ax,yy+fxyz(1),xx+fxyz(2),'Color',[0 .7 0]);

end

end

