function plotTrussFrameGeometryInternal(~, g, varargin)
%%%Plot Frame Truss Geometry.

ax = varargin{1};
dim = varargin{2};
canvas = varargin{3};

if dim == 2
plotTwoDFrameTrussInternal(g, 'canvas', canvas, 'parent', ax);
elseif dim == 3
plotThreeDFrameTrussInternal(g, 'canvas', canvas, 'parent', ax);
end

end

function plotTwoDFrameTrussInternal(g, varargin)
%Plot TwoD Truss or Frame Geometry

p = inputParser();
p.addParameter('canvas',[]);
p.addParameter('parent',[]);
p.parse(varargin{:});

canvas = p.Results.canvas;
ax = p.Results.parent;

gdms = g.GeometricDomain;
gbds = g.GeometricBoundaries;
if ~isempty(gdms)
    for i = 1:size(gdms,1)
    X = gdms(i,5:6);
    Y = gdms(i,7:8);    
    if ~gdms(i,18) && ~gdms(i,19)
    plot(ax,X,Y,"Color",canvas.Appearance.LineColor, 'LineWidth', canvas.Appearance.LineWidth,'Tag', g.CanvasTag.GeometricDomain{i})
    hold(ax,'on');
    end
    end
end

if ~isempty(gbds)
    for i = 1:g.NumPoints
    X = gbds(i,1);
    Y = gbds(i,2);
    if ~gbds(i,4)
    plot(ax,X,Y,"Color",canvas.Appearance.PointColor,'MarkerFaceColor',canvas.Appearance.PointColor,'Marker', 'o', 'MarkerSize', canvas.Appearance.MarkerSize, 'LineWidth', canvas.Appearance.LineWidth, 'Tag', g.CanvasTag.GeometricBoundaries{i});    
    hold(ax,'on');
    else
    plot(ax,X,Y,"Color",canvas.Appearance.PointColor,'MarkerFaceColor',canvas.Appearance.PointColor,'Marker', 'o', 'MarkerSize', canvas.Appearance.MarkerSize, 'LineWidth', canvas.Appearance.LineWidth, 'Tag', g.CanvasTag.GeometricBoundaries{i});        
    hold(ax,'on');
    end
    end
end

end

function plotThreeDFrameTrussInternal(g, varargin)
%Plot ThreeD Truss or Frame Geometry

p = inputParser();
p.addParameter('canvas',[]);
p.addParameter('parent',[]);
p.parse(varargin{:});

canvas = p.Results.canvas;
ax = p.Results.parent;

gdms = g.GeometricDomain;
gbds = g.GeometricBoundaries;
if ~isempty(gdms)
    for i = 1:size(gdms,1)
    X = gdms(i,5:6);
    Y = gdms(i,7:8);    
    Z = gdms(i,9:10); 
    if ~gdms(i,18) && ~gdms(i,19)
    plot3(ax,X,Y,Z,"Color",canvas.Appearance.LineColor, 'LineWidth', canvas.Appearance.LineWidth,'Tag', g.CanvasTag.GeometricDomain{i})
    hold(ax,'on');
    end
    end
end

if ~isempty(gbds)
    for i = 1:g.NumPoints
    X = gbds(i,1);
    Y = gbds(i,2);
    Z = gbds(i,3);
    if ~gbds(i,4)
    plot3(ax,X,Y,Z,"Color",canvas.Appearance.PointColor,'MarkerFaceColor',canvas.Appearance.PointColor,'Marker', 'o', 'MarkerSize', canvas.Appearance.MarkerSize, 'LineWidth', canvas.Appearance.LineWidth, 'Tag', g.CanvasTag.GeometricBoundaries{i});    
    hold(ax,'on');
    else
    plot3(ax,X,Y,Z,"Color",canvas.Appearance.PointColor,'MarkerFaceColor',canvas.Appearance.PointColor,'Marker', 'o', 'MarkerSize', canvas.Appearance.MarkerSize, 'LineWidth', canvas.Appearance.LineWidth, 'Tag', g.CanvasTag.GeometricBoundaries{i});        
    hold(ax,'on');
    end
    end
end

end