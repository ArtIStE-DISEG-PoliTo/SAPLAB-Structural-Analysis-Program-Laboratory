function plotAxisTriad(ax, dim, appearOpt)
%plotAxisTriad() - This function plots the axis triad in the graphic model.
%   The representation of the axis triad depends on the size of the model
%   which can be 2D or 3D.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%                         Plot Axis Triad                                 %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

axChildren = ax.Children;
bbox=set_CanvasBoundingBox(ax.XLim, ax.YLim, ax.ZLim);

xlim = ax.XLim;
ylim = ax.YLim;
zlim = ax.ZLim;

if dim == 2
    plotAxisTriadTwoD(ax,appearOpt,bbox);
elseif dim == 3
    plotAxisTriadThreeD(ax,appearOpt,bbox);
end

if (isempty(axChildren))
ax.XLim = [-xlim(2)/2 xlim(2)/2];
ax.YLim = [-ylim(2)/2 zlim(2)/2];
ax.ZLim = [-zlim(2)/2 zlim(2)/2];
if dim == 3
    view(ax,[0,0])
end
end

axis(ax,'equal');

end

function bbox=set_CanvasBoundingBox(~,xlim,ylim,zlim)
%evaluate bounding box
lim = abs([xlim(1),xlim(2),ylim(1),ylim(2),zlim(1),zlim(2)]); 
gradients = (max(lim));
bbox = gradients/20;
end

function plotAxisTriadTwoD(ax, appearOpt, bbox)

    %plot X global axis
    plot(ax,[0 bbox/2],[0 0],'Color',appearOpt.AxisTriad(1,:),'LineWidth',3,'Tag','AXISTRIAD'); hold(ax,'on');
    plot(ax,[0 bbox/1.3],[0 0],'Color',appearOpt.AxisTriad(1,:),'LineWidth',1,'Tag','AXISTRIAD'); hold(ax,'on');

    %plot Y global axis
    plot(ax,[0 0],[0 bbox/2],'Color',appearOpt.AxisTriad(2,:),'LineWidth',3,'Tag','AXISTRIAD'); hold(ax,'on');
    plot(ax,[0 0],[0 bbox/1.3],'Color',appearOpt.AxisTriad(2,:),'LineWidth',1,'Tag','AXISTRIAD'); hold(ax,'on');

    text(ax,bbox/1.3,0,'X','FontSize',14,'FontWeight','normal','Color',appearOpt.AxisTriad(1,:),'FontName','Monospac821 BT');
    text(ax,0,bbox/1.3,'Y','FontSize',14,'FontWeight','normal','Color',appearOpt.AxisTriad(2,:),'FontName','Monospac821 BT');

end

function plotAxisTriadThreeD(ax, appearOpt, bbox)

    %plot X global axis
    plot3(ax,[0 bbox/2],[0 0],[0 0],'Color',appearOpt.AxisTriad(1,:),'LineWidth',3,'Tag','AXISTRIAD'); hold(ax,'on');
    plot3(ax,[0 bbox/1.3],[0 0],[0 0],'Color',appearOpt.AxisTriad(1,:),'LineWidth',1,'Tag','AXISTRIAD'); hold(ax,'on');

    %plot Y global axis
    plot3(ax,[0 0],[0 bbox/2],[0 0],'Color',appearOpt.AxisTriad(2,:),'LineWidth',3,'Tag','AXISTRIAD'); hold(ax,'on');
    plot3(ax,[0 0],[0 bbox/1.3],[0 0],'Color',appearOpt.AxisTriad(2,:),'LineWidth',1,'Tag','AXISTRIAD'); hold(ax,'on');

    %plot Z global axis
    plot3(ax,[0 0],[0 0],[0 bbox/2],'Color',appearOpt.AxisTriad(3,:),'LineWidth',3,'Tag','AXISTRIAD'); hold(ax,'on');
    plot3(ax,[0 0],[0 0],[0 bbox/1.3],'Color',appearOpt.AxisTriad(3,:),'LineWidth',1,'Tag','AXISTRIAD'); hold(ax,'on');

    text(ax,bbox/1.3,0,0,'X','FontSize',14,'FontWeight','normal','Color',appearOpt.AxisTriad(1,:),'FontName','Monospac821 BT');
    text(ax,0,bbox/1.3,0,'Y','FontSize',14,'FontWeight','normal','Color',appearOpt.AxisTriad(2,:),'FontName','Monospac821 BT');
    text(ax,0,0,bbox/1.3,'Z','FontSize',14,'FontWeight','normal','Color',appearOpt.AxisTriad(3,:),'FontName','Monospac821 BT');
end