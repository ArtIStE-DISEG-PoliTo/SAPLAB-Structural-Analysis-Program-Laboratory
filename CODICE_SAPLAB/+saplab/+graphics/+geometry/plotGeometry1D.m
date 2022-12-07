function plotGeometry1D(ax, m)
%%%Plot Frame Truss Geometry.

%get input
geometry = m.Geometry;
appearance = m.Graphics.Appearance;

if isempty(m.Geometry)
    return
end

narginchk(2,2);

if contains(m.AnalysisType,'plane')
plotTwoDFrameTrussInternal(geometry, 'appearance', appearance, 'parent', ax);
elseif contains(m.AnalysisType,'space')
plotThreeDFrameTrussInternal(geometry, 'appearance', appearance, 'parent', ax);
end

axis(ax,'equal');

end

function plotTwoDFrameTrussInternal(g, varargin)
%Plot TwoD Truss or Frame Geometry

p = inputParser();
p.addParameter('appearance',[]);
p.addParameter('parent',[]);
p.parse(varargin{:});

appearance = p.Results.appearance;
ax = p.Results.parent;

gdms = g.GeometricDomain;
gbds = g.GeometricBoundaries;

if ~isempty(gdms)
    gdms(1,18)
    for i = 1:size(gdms,1)
    X = gdms(i,5:6);
    Y = gdms(i,7:8);
    if ~gdms(i,18) && ~gdms(i,19)
    plot(ax,X,Y,"Color",appearance.LineColor, 'LineWidth', appearance.LineWidth,'Tag', g.CanvasTag.GeometricDomain{i},'LineStyle',appearance.LineStyle);
    hold(ax,'on');
    elseif gdms(i,18) && ~gdms(i,19)

    linX = linspace(X(1),X(2),20);
    linY = linspace(Y(1),Y(2),20);
    Xrel = linX([4,end]);
    Yrel = linY([4,end]);
    plot(ax,Xrel,Yrel,"Color",appearance.LineColor, 'LineWidth', appearance.LineWidth,'Tag', g.CanvasTag.GeometricDomain{i},'LineStyle',appearance.LineStyle);
    hold(ax,'on');   
    plot(ax,Xrel(1),Yrel(1),"Color",appearance.ReleaseColor, 'MarkerFaceColor',appearance.ReleaseColor,'Marker', 'o','MarkerSize',4);
    elseif ~gdms(i,18) && gdms(i,19)
    linX = linspace(X(1),X(2),20);
    linY = linspace(Y(1),Y(2),20);
    Xrel = linX([1,end-3]);
    Yrel = linY([1,end-3]);
    plot(ax,Xrel,Yrel,"Color",appearance.LineColor, 'LineWidth', appearance.LineWidth,'Tag', g.CanvasTag.GeometricDomain{i},'LineStyle',appearance.LineStyle);
    hold(ax,'on'); 
    plot(ax,Xrel(end),Yrel(end),"Color",appearance.ReleaseColor, 'MarkerFaceColor',appearance.ReleaseColor,'Marker', 'o','MarkerSize',4);
    else
    linX = linspace(X(1),X(2),20);
    linY = linspace(Y(1),Y(2),20);
    Xrel = linX([4,end-3]);
    Yrel = linY([4,end-3]);
    plot(ax,Xrel,Yrel,"Color",appearance.LineColor, 'LineWidth', appearance.LineWidth,'Tag', g.CanvasTag.GeometricDomain{i},'LineStyle',appearance.LineStyle);
    hold(ax,'on');  
    plot(ax,Xrel(1),Yrel(1),"Color",appearance.ReleaseColor, 'MarkerFaceColor',appearance.ReleaseColor,'Marker', 'o','MarkerSize',4);
    plot(ax,Xrel(end),Yrel(end),"Color",appearance.ReleaseColor, 'MarkerFaceColor',appearance.ReleaseColor,'Marker', 'o','MarkerSize',4);
    end
    end
end

if ~isempty(gbds)
    for i = 1:g.NumPoints
    X = gbds(i,1);
    Y = gbds(i,2);
    plot(ax,X,Y,"Color",appearance.PointColor,'MarkerFaceColor',appearance.PointColor,'Marker', 'o', 'MarkerSize', appearance.MarkerSize, 'LineWidth', appearance.LineWidth, 'Tag', g.CanvasTag.GeometricBoundaries{i});        
    hold(ax,'on');
    end
end

end

function plotThreeDFrameTrussInternal(g, varargin)
%Plot ThreeD Truss or Frame Geometry

p = inputParser();
p.addParameter('appearance',[]);
p.addParameter('parent',[]);
p.parse(varargin{:});

appearance = p.Results.appearance;
ax = p.Results.parent;

gdms = g.GeometricDomain;
gbds = g.GeometricBoundaries;
if ~isempty(gdms)

    for i = 1:size(gdms,1)
    X = gdms(i,5:6);
    Y = gdms(i,7:8);    
    Z = gdms(i,9:10); 
    if ~gdms(i,18) && ~gdms(i,19)
    plot3(ax,X,Y,Z,"Color",appearance.LineColor, 'LineWidth', appearance.LineWidth,'Tag', g.CanvasTag.GeometricDomain{i},'LineStyle',appearance.LineStyle)
    hold(ax,'on');
    elseif gdms(i,18) && ~gdms(i,19)
    linX = linspace(X(1),X(2),20);
    linY = linspace(Y(1),Y(2),20);
    linZ = linspace(Z(1),Z(2),20);
    Xrel = linX([4,end]);
    Yrel = linY([4,end]);
    Zrel = linZ([4,end]);
    plot3(ax,Xrel,Yrel,Zrel,"Color",appearance.LineColor, 'LineWidth', appearance.LineWidth,'Tag', g.CanvasTag.GeometricDomain{i},'LineStyle',appearance.LineStyle);
    hold(ax,'on');   
    plot3(ax,Xrel(1),Yrel(1),Zrel(1),"Color",appearance.ReleaseColor, 'MarkerFaceColor',appearance.ReleaseColor,'Marker', 'o','MarkerSize',4);
    elseif ~gdms(i,18) && gdms(i,19)
    linX = linspace(X(1),X(2),20);
    linY = linspace(Y(1),Y(2),20);
    linZ = linspace(Z(1),Z(2),20);
    Xrel = linX([1,end-3]);
    Yrel = linY([1,end-3]);
    Zrel = linZ([1,end-3]);
    plot3(ax,Xrel,Yrel,Zrel,"Color",appearance.LineColor, 'LineWidth', appearance.LineWidth,'Tag', g.CanvasTag.GeometricDomain{i},'LineStyle',appearance.LineStyle);
    hold(ax,'on');   
    plot3(ax,Xrel(end),Yrel(end),Zrel(end),"Color",appearance.ReleaseColor, 'MarkerFaceColor',appearance.ReleaseColor,'Marker', 'o','MarkerSize',4);
    elseif gdms(i,18) && gdms(i,19)
    linX = linspace(X(1),X(2),20);
    linY = linspace(Y(1),Y(2),20);
    linZ = linspace(Z(1),Z(2),20);
    Xrel = linX([4,end-3]);
    Yrel = linY([4,end-3]);
    Zrel = linZ([4,end-3]);
    plot3(ax,Xrel,Yrel,Zrel,"Color",appearance.LineColor, 'LineWidth', appearance.LineWidth,'Tag', g.CanvasTag.GeometricDomain{i},'LineStyle',appearance.LineStyle);
    hold(ax,'on');   
    plot3(ax,Xrel(1),Yrel(1),Zrel(1),"Color",appearance.ReleaseColor, 'MarkerFaceColor',appearance.ReleaseColor,'Marker', 'o','MarkerSize',4); 
    plot3(ax,Xrel(end),Yrel(end),Zrel(end),"Color",appearance.ReleaseColor, 'MarkerFaceColor',appearance.ReleaseColor,'Marker', 'o','MarkerSize',4);
    end
    end
end

if ~isempty(gbds)
    for i = 1:g.NumPoints
    X = gbds(i,1);
    Y = gbds(i,2);
    Z = gbds(i,3);

    plot3(ax,X,Y,Z,"Color",appearance.PointColor,'MarkerFaceColor',appearance.PointColor,'Marker', 'o', 'MarkerSize', appearance.MarkerSize, 'LineWidth', appearance.LineWidth, 'Tag', g.CanvasTag.GeometricBoundaries{i});    
    hold(ax,'on');

    end
end

end