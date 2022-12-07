function plot1DElementGeometry(~, g, varargin)
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
    plot(ax,X,Y,"Color",canvas.Appearance.LineColor, 'LineWidth', canvas.Appearance.LineWidth,'Tag', g.CanvasTag.GeometricDomain{i},'LineStyle',canvas.Appearance.LineStyle);
    hold(ax,'on');
    elseif gdms(i,18) && ~gdms(i,19)
    linX = linspace(X(1),X(2),5*round(gdms(i,14)));
    linY = linspace(Y(1),Y(2),5*round(gdms(i,14)));
    Xrel = linX([4,end]);
    Yrel = linY([4,end]);
    plot(ax,Xrel,Yrel,"Color",canvas.Appearance.LineColor, 'LineWidth', canvas.Appearance.LineWidth,'Tag', g.CanvasTag.GeometricDomain{i},'LineStyle',canvas.Appearance.LineStyle);
    hold(ax,'on');   
    plot(ax,Xrel(1),Yrel(1),"Color",canvas.Appearance.ReleaseColor, 'MarkerFaceColor',canvas.Appearance.ReleaseColor,'Marker', 'o','MarkerSize',2);
    elseif ~gdms(i,18) && gdms(i,19)
    linX = linspace(X(1),X(2),5*round(gdms(i,14)));
    linY = linspace(Y(1),Y(2),5*round(gdms(i,14)));
    Xrel = linX([1,end-3]);
    Yrel = linY([1,end-3]);
    plot(ax,Xrel,Yrel,"Color",canvas.Appearance.LineColor, 'LineWidth', canvas.Appearance.LineWidth,'Tag', g.CanvasTag.GeometricDomain{i},'LineStyle',canvas.Appearance.LineStyle);
    hold(ax,'on'); 
    plot(ax,Xrel(end),Yrel(end),"Color",canvas.Appearance.ReleaseColor, 'MarkerFaceColor',canvas.Appearance.ReleaseColor,'Marker', 'o','MarkerSize',2);
    else
    linX = linspace(X(1),X(2),5*round(gdms(i,14)));
    linY = linspace(Y(1),Y(2),5*round(gdms(i,14)));
    Xrel = linX([4,end-3]);
    Yrel = linY([4,end-3]);
    plot(ax,Xrel,Yrel,"Color",canvas.Appearance.LineColor, 'LineWidth', canvas.Appearance.LineWidth,'Tag', g.CanvasTag.GeometricDomain{i},'LineStyle',canvas.Appearance.LineStyle);
    hold(ax,'on');  
    plot(ax,Xrel(1),Yrel(1),"Color",canvas.Appearance.ReleaseColor, 'MarkerFaceColor',canvas.Appearance.ReleaseColor,'Marker', 'o','MarkerSize',2);
    plot(ax,Xrel(end),Yrel(end),"Color",canvas.Appearance.ReleaseColor, 'MarkerFaceColor',canvas.Appearance.ReleaseColor,'Marker', 'o','MarkerSize',2);
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
    plot3(ax,X,Y,Z,"Color",canvas.Appearance.LineColor, 'LineWidth', canvas.Appearance.LineWidth,'Tag', g.CanvasTag.GeometricDomain{i},'LineStyle',canvas.Appearance.LineStyle)
    hold(ax,'on');
    elseif gdms(i,18) && ~gdms(i,19)
    linX = linspace(X(1),X(2),5*round(gdms(i,14)));
    linY = linspace(Y(1),Y(2),5*round(gdms(i,14)));
    linZ = linspace(Z(1),Z(2),5*round(gdms(i,14)));
    Xrel = linX([4,end]);
    Yrel = linY([4,end]);
    Zrel = linZ([4,end]);
    plot3(ax,Xrel,Yrel,Zrel,"Color",canvas.Appearance.LineColor, 'LineWidth', canvas.Appearance.LineWidth,'Tag', g.CanvasTag.GeometricDomain{i},'LineStyle',canvas.Appearance.LineStyle);
    hold(ax,'on');   
    plot3(ax,Xrel(1),Yrel(1),Zrel(1),"Color",canvas.Appearance.ReleaseColor, 'MarkerFaceColor',canvas.Appearance.ReleaseColor,'Marker', 'o','MarkerSize',2);
    elseif ~gdms(i,18) && gdms(i,19)
    linX = linspace(X(1),X(2),5*round(gdms(i,14)));
    linY = linspace(Y(1),Y(2),5*round(gdms(i,14)));
    linZ = linspace(Z(1),Z(2),5*round(gdms(i,14)));
    Xrel = linX([1,end-3]);
    Yrel = linY([1,end-3]);
    Zrel = linZ([1,end-3]);
    plot3(ax,Xrel,Yrel,Zrel,"Color",canvas.Appearance.LineColor, 'LineWidth', canvas.Appearance.LineWidth,'Tag', g.CanvasTag.GeometricDomain{i},'LineStyle',canvas.Appearance.LineStyle);
    hold(ax,'on');   
    plot3(ax,Xrel(end),Yrel(end),Zrel(end),"Color",canvas.Appearance.ReleaseColor, 'MarkerFaceColor',canvas.Appearance.ReleaseColor,'Marker', 'o','MarkerSize',2);
    elseif gdms(i,18) && gdms(i,19)
    linX = linspace(X(1),X(2),5*round(gdms(i,14)));
    linY = linspace(Y(1),Y(2),5*round(gdms(i,14)));
    linZ = linspace(Z(1),Z(2),5*round(gdms(i,14)));
    Xrel = linX([4,end-3]);
    Yrel = linY([4,end-3]);
    Zrel = linZ([4,end-3]);
    plot3(ax,Xrel,Yrel,Zrel,"Color",canvas.Appearance.LineColor, 'LineWidth', canvas.Appearance.LineWidth,'Tag', g.CanvasTag.GeometricDomain{i},'LineStyle',canvas.Appearance.LineStyle);
    hold(ax,'on');   
    plot3(ax,Xrel(1),Yrel(1),Zrel(1),"Color",canvas.Appearance.ReleaseColor, 'MarkerFaceColor',canvas.Appearance.ReleaseColor,'Marker', 'o','MarkerSize',2); 
    plot3(ax,Xrel(end),Yrel(end),Zrel(end),"Color",canvas.Appearance.ReleaseColor, 'MarkerFaceColor',canvas.Appearance.ReleaseColor,'Marker', 'o','MarkerSize',2);
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