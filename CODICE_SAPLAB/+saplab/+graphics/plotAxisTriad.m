function plotAxisTriad(ax, appearOpt, bbox)
%plotAxisTriad() - This function plots the axis triad in the graphic model.
%   The representation of the axis triad depends on the size of the model
%   which can be 2D or 3D.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%                         Plot Axis Triad                                 %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

maxdim = max([abs(bbox(1,1)-bbox(1,2)), abs(bbox(2,1)-bbox(2,2)), abs(bbox(3,1)-bbox(3,2))]);
vMag = .07*maxdim;
vec = vMag*eye(3);
quiver3(zeros(3,1),zeros(3,1),zeros(3,1),vec(:,1),vec(:,2),vec(:,3), 'Color', 'red','Parent',ax,'MaxHeadSize',0.75,'LineWidth',1.5);
text(ax,vMag,0,'X','FontWeight','bold','Color',appearOpt.AxisTriad(1,:),'FontSize',12);
text(ax,0,vMag,'Y','FontWeight','bold','Color',appearOpt.AxisTriad(2,:),'FontSize',12);
text(ax,0,0,vMag,'Z','FontWeight','bold','Color',appearOpt.AxisTriad(3,:),'FontSize',12);

end
