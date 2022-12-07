function plotAxisTriad(self, varargin)
%plotAxisTriad() - This function plots the axis triad in the graphic model.
%   The representation of the axis triad depends on the size of the model
%   which can be 2D or 3D.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%                         Plot Axis Triad                                 %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

narginchk(1,2);
if nargin==1 
    ax = gca;
end

if nargin == 2 && ~isempty(varargin)
    ax = varargin{1};
    if isempty(ax)
        ax=gca;
    end
    mustBeA(ax,["matlab.ui.control.UIAxes","matlab.graphics.axis.Axes"]);
end
set_CanvasAxisLimits(self, ax.XLim, ax.YLim, ax.ZLim);
set_CanvasBoundingBox(self, ax.XLim, ax.YLim, ax.ZLim);

if self.SAPModelSize == 2
    plotAxisTriadTwoD(ax,self.Canvas.BoundingBox,self.Canvas.Appearance);
elseif self.SAPModelSize == 3
    plotAxisTriadThreeD(ax,self.Canvas.BoundingBox,self.Canvas.Appearance);
end

grid(ax,'on');
axis(ax,'equal');
ax.Clipping = 'off';

ax.XLim = self.Canvas.XLim;
ax.YLim = self.Canvas.YLim;
ax.ZLim = self.Canvas.ZLim;
end

function plotAxisTriadTwoD(ax, bbox, cp)
    quiver(ax,0,0,bbox,0,'Color',cp.AxisTriad(1,:),'MaxHeadSize',0.5,'LineWidth',2.5);
    hold(ax,'on');
    quiver(ax,0,0,0,bbox,'Color',cp.AxisTriad(2,:),'MaxHeadSize',0.5,'LineWidth',2.5);
    text(ax,bbox,0,'X','FontSize',14,'FontWeight','normal','Color',cp.AxisTriad(1,:),'FontName','Monospaced');
    text(ax,0,bbox,'Y','FontSize',14,'FontWeight','normal','Color',cp.AxisTriad(2,:),'FontName','Monospaced');
end
function plotAxisTriadThreeD(ax, bbox, cp)
    quiver3(ax,0,0,0,bbox,0,0,'Color',cp.AxisTriad(1,:),'MaxHeadSize',0.5,'LineWidth',2.5);
    hold(ax,'on');
    quiver3(ax,0,0,0,0,bbox,0,'Color',cp.AxisTriad(2,:),'MaxHeadSize',0.5,'LineWidth',2.5);
    hold(ax,'on');
    quiver3(ax,0,0,0,0,0,bbox,'Color',cp.AxisTriad(3,:),'MaxHeadSize',0.5,'LineWidth',2.5);
    text(ax,bbox,0,0,'X','FontSize',14,'FontWeight','normal','Color',cp.AxisTriad(1,:),'FontName','Monospaced');
    text(ax,0,bbox,0,'Y','FontSize',14,'FontWeight','normal','Color',cp.AxisTriad(2,:),'FontName','Monospaced');
    text(ax,0,0,bbox,'Z','FontSize',14,'FontWeight','normal','Color',cp.AxisTriad(3,:),'FontName','Monospaced');
end