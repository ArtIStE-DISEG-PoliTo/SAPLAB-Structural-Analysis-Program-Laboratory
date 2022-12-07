function plotGeometry1D_Constraint(ax, m)
%plot constraint function
    bc = m.BoundaryConditions;
    appearance = m.Graphics.Appearance;
    if isempty(bc)
        return;
    end

    bbox=set_CanvasBoundingBoxForConstraint(ax.XLim, ax.YLim, ax.ZLim);
    bcData=bc.readConstraintDataForPlot();
    for i=1:size(bcData,1)
        fun = strcat('saplab.graphics.constraint.',bcData{i,1});
        loc = [bcData{i,2} 0.75*bbox];
        feval(fun,loc,'parent',ax,'color',appearance.ConstraintColor)        
    end
end

function bbox=set_CanvasBoundingBoxForConstraint(xlim,ylim,zlim)
%evaluate bounding box
lim = abs([xlim(1),xlim(2),ylim(1),ylim(2),zlim(1),zlim(2)]); 
maxlim = (max(lim));
minlim = (min(lim));
bbox = (maxlim-minlim)/20;
end