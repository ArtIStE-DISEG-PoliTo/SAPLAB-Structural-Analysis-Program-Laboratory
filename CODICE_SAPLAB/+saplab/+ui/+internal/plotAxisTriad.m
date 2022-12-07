function plotAxisTriad(ax, dim, appearOpt, bbox)
%plotAxisTriad() - This function plots the axis triad in the graphic model.
%   The representation of the axis triad depends on the size of the model
%   which can be 2D or 3D.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%                         Plot Axis Triad                                 %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
axChildren = ax.Children;
% 
maxdim = max([abs(bbox(1,1)-bbox(1,2)), abs(bbox(2,1)-bbox(2,2)), abs(bbox(3,1)-bbox(3,2))]);
vMag = .05*maxdim;
vec = vMag*eye(3);
quiver3(zeros(3,1),zeros(3,1),zeros(3,1),vec(:,1),vec(:,2),vec(:,3), 'Color', 'red','Parent',ax,'MaxHeadSize',0.75,'LineWidth',1.5);
text(ax,vMag,0,'x-axis','FontWeight','normal','Color',appearOpt.AxisTriad(1,:),'FontName','Monospac821 BT','FontSmoothing','off','FontSize',10);
text(ax,0,vMag,'y-axis','FontWeight','normal','Color',appearOpt.AxisTriad(2,:),'FontName','Monospac821 BT','FontSmoothing','off','FontSize',10);
text(ax,0,0,vMag,'z-axis','FontWeight','normal','Color',appearOpt.AxisTriad(3,:),'FontName','Monospac821 BT','FontSmoothing','off','FontSize',10);
% if dim == 2
%     plotAxisTriadTwoD(ax,appearOpt,bbox);
% elseif dim == 3
%     plotAxisTriadThreeD(ax,appearOpt,bbox);
% end

if (isempty(axChildren))
if dim == 3
    view(ax,[0,0])
end
end

end

function plotAxisTriadTwoD(ax, appearOpt, bbox)

    %plot X global axis
    plot(ax,[0 bbox/1.3],[0 0],'Color',appearOpt.AxisTriad(1,:),'LineWidth',1,'Tag','AXISTRIAD'); hold(ax,'on');

    %plot Y global axis
    plot(ax,[0 0],[0 bbox/1.3],'Color',appearOpt.AxisTriad(2,:),'LineWidth',1,'Tag','AXISTRIAD'); hold(ax,'on');

    text(ax,bbox/1.3,0,'X','FontSize',14,'FontWeight','normal','Color',appearOpt.AxisTriad(1,:),'FontName','Monospac821 BT');
    text(ax,0,bbox/1.3,'Y','FontSize',14,'FontWeight','normal','Color',appearOpt.AxisTriad(2,:),'FontName','Monospac821 BT');

end

function plotAxisTriadThreeD(ax, appearOpt, bbox)

    %plot X global axis
    plot3(ax,[0 bbox/1.3],[0 0],[0 0],'Color',appearOpt.AxisTriad(1,:),'LineWidth',1,'Tag','AXISTRIAD'); hold(ax,'on');

    %plot Y global axis
    plot3(ax,[0 0],[0 bbox/1.3],[0 0],'Color',appearOpt.AxisTriad(2,:),'LineWidth',1,'Tag','AXISTRIAD'); hold(ax,'on');

    %plot Z global axis
    plot3(ax,[0 0],[0 0],[0 bbox/2],'Color',appearOpt.AxisTriad(3,:),'LineWidth',3,'Tag','AXISTRIAD'); hold(ax,'on');
    plot3(ax,[0 0],[0 0],[0 bbox/1.3],'Color',appearOpt.AxisTriad(3,:),'LineWidth',1,'Tag','AXISTRIAD'); hold(ax,'on');

    text(ax,bbox/1.3,0,0,'X','FontSize',14,'FontWeight','normal','Color',appearOpt.AxisTriad(1,:),'FontName','Monospac821 BT');
    text(ax,0,bbox/1.3,0,'Y','FontSize',14,'FontWeight','normal','Color',appearOpt.AxisTriad(2,:),'FontName','Monospac821 BT');
    text(ax,0,0,bbox/1.3,'Z','FontSize',14,'FontWeight','normal','Color',appearOpt.AxisTriad(3,:),'FontName','Monospac821 BT');
end