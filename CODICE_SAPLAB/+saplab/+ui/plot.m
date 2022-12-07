function plot(M,varargin)

defplotLabels='off';

p = inputParser();
p.addParameter('LineLabels',defplotLabels,@isValidOptionOnOff);
p.addParameter('PointLabels',defplotLabels,@isValidOptionOnOff);
p.addParameter('EdgeLabels',defplotLabels,@isValidOptionOnOff);
p.addParameter('VertexLabels',defplotLabels,@isValidOptionOnOff);
p.addParameter('FaceLabels',defplotLabels,@isValidOptionOnOff);
p.addParameter('ReinforcementLabels',defplotLabels,@isValidOptionOnOff);
p.addParameter('Constraint',defplotLabels,@isValidOptionOnOff);
p.addParameter('TagLabels',defplotLabels,@isValidOptionOnOff);
p.addParameter('PlotAll',defplotLabels,@isValidOptionOnOff);
p.addParameter('PlotDeformedShape',defplotLabels,@isValidOptionOnOff);
p.addParameter('PlotDistributedLoads',defplotLabels,@isValidOptionOnOff);
p.addParameter('PlotBoundaryForces',defplotLabels,@isValidOptionOnOff);
p.addParameter('PlotThermalLoads',defplotLabels,@isValidOptionOnOff);
p.addParameter('PlotGravitationalLoads',defplotLabels,@isValidOptionOnOff);
p.addParameter('PlotConstraints',defplotLabels,@isValidOptionOnOff);
p.addParameter('PlotDisplacements',defplotLabels,@isValidOptionOnOff);
p.addParameter('Field',"",@(x) mustBeMember(x,["","UX","UY","UZ"]));
p.addParameter('ForcesAndMoments',"",@(x) mustBeMember(x,["","NX","FY","FZ","MX","MY","MZ"]));
p.addParameter('Stress',"",@(x) mustBeMember(x,["","SXX","SXY","SYY","S11","S12","S22"]));
p.addParameter('Strain',"",@(x) mustBeMember(x,["","EXX","EXY","EYY"]));
p.addParameter('ScaleFactor',[]);
p.addParameter('Canvas',[]);
p.parse(varargin{:})

if isa(M,'saplab.ui.Dashboard')
    M = M.MODEL;
    Graphics = M.Graphics;
end
Rei = [];
if isa(M,'sap.StructuralModel')
    G = M.Geometry;
    Graphics = M.Graphics;
    if isprop(M,'StructuralReinforcement')
        Rei = M.StructuralReinforcement;
    end
end

if isa(M, 'sap.Geometry')
    G = M;
    if isprop(G.ParentModel,'StructuralReinforcement')
        Rei = G.ParentModel.StructuralReinforcement;
    end
    Graphics = M.ParentModel.Graphics;
end

if isnumeric(M)
    G = M;
    flagModel = createsap("AnalysisAttribute","static-planeframe");
    Graphics = saplab.ui.GraphicOptions(flagModel);
    Tag = ''; %#ok
end

if isempty(G)
    return
end

%evaluate axis dim
cdim = 2;
if ~isnumeric(G)
    cdim = 2;
    if G.Dim == 1 && G.SysDim == 6
        cdim = 3;
    end
end

Appearance = Graphics.Appearance;
Axis       = p.Results.Canvas;
Geometry   = G;
Dimension  = Graphics.Dim;
Cdimension = cdim;

%reset canvas before plotting
if strcmpi(p.Results.PlotAll,'off')
    delete(Axis.Children)
end
Tag = [];

if isa(Geometry,'sap.Geometry')
%     M.ParentModel.Graphics.Appearance.LineStyle = '-';
    if Dimension == 1
        saplab.ui.linkFrameGeomToCanvas(Geometry.ParentModel);
        saplab.ui.internal.plotTrussFrameGeometry(Geometry,Axis,Appearance,Cdimension);
        
        if ~isempty(Geometry.ParentModel.BoundaryConditions) 
            plotFrameAnalysisConstraint(Geometry.ParentModel.BoundaryConditions,Axis,Appearance);
        end

        if ~isempty(Geometry.ParentModel.BoundaryConditions) && strcmpi(p.Results.PlotBoundaryForces,'on')
            plotForceBC(Geometry.ParentModel.BoundaryConditions,Axis,Appearance);
        end
        
        if ~isempty(Geometry.ParentModel.DistributedLoads) && strcmpi(p.Results.PlotDistributedLoads,'on')
            plotDistributedForces(Geometry.ParentModel.DistributedLoads,Axis,Appearance)
        end

        if ~isempty(Geometry.ParentModel.BodyLoads) && strcmpi(p.Results.PlotThermalLoads,'on')
            plotThermalForcesLabel(Geometry.ParentModel.BodyLoads,Axis);
        end
    else
        Tag=Geometry.geomTag;
        saplab.ui.linkFaceGeomToCanvas(Geometry.ParentModel,Geometry.geom,Tag);
        saplab.ui.internal.plotPlaneSurfaceGeometry(Geometry,Axis,Tag,Appearance,Rei)
        if ~isempty(Geometry.ParentModel.BoundaryConditions)
            plotPlaneAnalysisConstraint(Geometry.ParentModel.BoundaryConditions,Axis,Appearance)       
            plotBCPressure(Geometry.ParentModel.BoundaryConditions,Axis,Appearance)
        end

        if ~isempty(Geometry.ParentModel.BoundaryConditions) && strcmpi(p.Results.PlotBoundaryForces,'on')
            plotForceBC(Geometry.ParentModel.BoundaryConditions,Axis,Appearance);
        end
        
        if ~isempty(Geometry.ParentModel.BodyLoads) && strcmpi(p.Results.PlotThermalLoads,'on')
            plotThermalForcesLabel(Geometry.ParentModel.BodyLoads,Axis);
        end

    end
end

if isnumeric(Geometry)
    saplab.ui.internal.plotPlaneSurfaceGeometry(Geometry,Axis,Tag,Appearance,Rei)
end

forcesAndMoments = p.Results.ForcesAndMoments;
stresses = p.Results.Stress;
strains = p.Results.Strain;

plotLineLabel  = strcmp(p.Results.LineLabels, 'on');
plotPointLabel = strcmp(p.Results.PointLabels, 'on');
plotEdgeLabel = strcmp(p.Results.EdgeLabels, 'on');
plotVertexLabel = strcmp(p.Results.VertexLabels, 'on');
plotFaceLabel = strcmp(p.Results.FaceLabels, 'on');
plotReiLabel = strcmp(p.Results.ReinforcementLabels, 'on');
plotDeformedShape = strcmp(p.Results.PlotDeformedShape,'on');
plotDisplacements = strcmp(p.Results.PlotDisplacements,'on');
plotForcesAndMoments = ~strcmp(forcesAndMoments,"");
plotStress = ~strcmp(stresses, "");
plotStrain = ~strcmp(strains, "");
if plotLineLabel,  plotLineLabels(Geometry,Axis,Appearance); end
if plotPointLabel, plotPointLabels(Geometry,Axis,Appearance); end
if plotEdgeLabel, plotEdgeLabels(Geometry,Axis,Appearance); end
if plotVertexLabel, plotVertexLabels(Geometry,Axis,Appearance); end
if plotFaceLabel, plotFaceLabels(Geometry,Axis,Appearance); end
if plotReiLabel, plotReinforcementLabels(Rei,Tag,Axis,Appearance); end
if plotDeformedShape, forcesAndMoments=""; plotForcesAndMoments=false; saplab.ui.internal.plotDeformedShape(M,p.Results.Canvas,p.Results.ScaleFactor); end
if plotDisplacements, forcesAndMoments=""; plotForcesAndMoments=false; saplab.ui.internal.plotDisplacements(M,p.Results.Canvas,p.Results.Field,p.Results.ScaleFactor); end

%forces and moments
if plotForcesAndMoments && contains(M.AnalysisType, 'frame')
    if plotDeformedShape || plotDisplacements
        error('Invalid use of Tplot function.');
    end        
    if strcmpi(forcesAndMoments,"NX")
        saplab.ui.internal.plotAxialForces(M,p.Results.Canvas,p.Results.ScaleFactor)
    end
    if strcmpi(forcesAndMoments,"FY")
        saplab.ui.internal.plotShearForces(M,p.Results.Canvas,'FY',p.Results.ScaleFactor)
    end
    if strcmpi(forcesAndMoments,"FZ")
        saplab.ui.internal.plotShearForces(M,p.Results.Canvas,'FZ',p.Results.ScaleFactor)
    end
    if strcmpi(forcesAndMoments,"MX")
        saplab.ui.internal.plotTorqueMoment(M,p.Results.Canvas,p.Results.ScaleFactor)
    end
    if strcmpi(forcesAndMoments,"MY")
        saplab.ui.internal.plotBendingMoment(M,p.Results.Canvas,'MY',p.Results.ScaleFactor)
    end
    if strcmpi(forcesAndMoments,"MZ")
        saplab.ui.internal.plotBendingMoment(M,p.Results.Canvas,'MZ',p.Results.ScaleFactor)
    end
end

if plotStress && ~contains(M.AnalysisType, 'frame')
    if plotDeformedShape || plotDisplacements || plotForcesAndMoments
        error('Invalid use of Tplot function.');
    end     
    if strcmpi(stresses,"SXX")
        saplab.ui.internal.plotStress(M,p.Results.Canvas,'SXX',p.Results.ScaleFactor);
    end
    if strcmpi(stresses,"SXY")
        saplab.ui.internal.plotStress(M,p.Results.Canvas,'SXY',p.Results.ScaleFactor);
    end
    if strcmpi(stresses,"SYY")
        saplab.ui.internal.plotStress(M,p.Results.Canvas,'SYY',p.Results.ScaleFactor);
    end
    if strcmpi(stresses,"S11")
        saplab.ui.internal.plotStress(M,p.Results.Canvas,'S11',p.Results.ScaleFactor);
    end
    if strcmpi(stresses,"S12")
        saplab.ui.internal.plotStress(M,p.Results.Canvas,'S12',p.Results.ScaleFactor);
    end
    if strcmpi(stresses,"S22")
        saplab.ui.internal.plotStress(M,p.Results.Canvas,'S22',p.Results.ScaleFactor);
    end
end

if plotStrain
    if plotDeformedShape || plotDisplacements || plotForcesAndMoments || plotStress
        error('Invalid use of Tplot function.');
    end   
    if ~contains(M.AnalysisType, 'frame')
        if strcmpi(strains,"EXX")
            saplab.ui.internal.plotTriStrain(M,p.Results.Canvas,'EXX',p.Results.ScaleFactor);
        end
        if strcmpi(strains,"EYY")
            saplab.ui.internal.plotTriStrain(M,p.Results.Canvas,'EYY',p.Results.ScaleFactor);
        end
        if strcmpi(strains,"EXY")
            saplab.ui.internal.plotTriStrain(M,p.Results.Canvas,'EXY',p.Results.ScaleFactor);
        end

    end
end

%plot axis triad
bbox=set_CanvasBoundingBox(Axis.XLim,Axis.YLim,Axis.ZLim);
saplab.ui.internal.plotAxisTriad(Axis,Cdimension,Appearance,bbox)
axis(Axis,'equal');
% axis(Axis,'off');
Axis.Clipping = 'off';
end

function plotPointLabels(geometry,axes,appearance)

if isnumeric(geometry) 
    return
end

if geometry.Dim == 2
    return
end

fxyz = geometry.GeometricBoundaries;
fxyz(fxyz(:,5)==1,:) = [];

xyzloc = unique(fxyz(:,1:3), "rows", "stable");
labels = string(1:size(xyzloc,1)); 
labels = cellstr(labels'); 

text(axes,xyzloc(:,1),xyzloc(:,2),xyzloc(:,3),labels,'HorizontalAlignment','left','VerticalAlignment','bottom',...
    'Color',appearance.PointLabelColor,'FontName',appearance.FontName,'FontSize',10,'FontWeight','normal','Tag','POINTLABELS','EdgeColor','r');

end


function plotLineLabels(geometry,axes,appearance)

fxyz = geometry.GeometricDomain;
xyzloc = unique(fxyz(:,11:13), "rows","stable");
labels = string(1:size(xyzloc,1)); 
labels = cellstr(labels'); 

text(axes,xyzloc(:,1),xyzloc(:,2),xyzloc(:,3),labels,'HorizontalAlignment','center','VerticalAlignment','bottom',...
    'Color',appearance.LineLabelColor,'FontName',appearance.FontName,'Tag','LINELABELS','EdgeColor','k');
end

function tf = isValidOptionOnOff(opt)
    try
       validatestring(opt,{'on', 'off'}) ;
    catch
       error("Acceptable values are 'on' and 'off'");   
    end
    tf = true;
end

function plotEdgeLabels(Geometry,Axes,Appearance)

if isa(Geometry,'sap.Geometry')
    Geometry = Geometry.geom;
end

%get the label string text
fig = figure('Visible','off'); 
pdegplot(Geometry, 'EdgeLabels', 'on');
EdgeLabels = findall(gca, 'Type', 'Text');
for ii =1:numel(EdgeLabels)
    EdgeLabels(ii).String = erase(EdgeLabels(ii).String,'E');
    EdgeLabels(ii).FontSize = 9;
    EdgeLabels(ii).FontName = Appearance.FontName;
    EdgeLabels(ii).FontWeight = 'normal';
    EdgeLabels(ii).Color = Appearance.EdgeLabelColor;
    EdgeLabels(ii).EdgeColor = 'k';
    EdgeLabels(ii).Tag = 'EDGELABELS';
end
copyobj(EdgeLabels, Axes);
delete(fig);

end

function plotFaceLabels(Geometry,Axes,Appearance)

nargoutchk(0,1);

if isa(Geometry,'sap.Geometry')
    Geometry = Geometry.geom;
end

%get the label string text
fig = figure('Visible','off'); 
pdegplot(Geometry, 'FaceLabels', 'on');

FaceLabels = findall(gca, 'Type', 'Text'); 

for ii =1:numel(FaceLabels)
    FaceLabels(ii).FontSize = 10;
    FaceLabels(ii).FontName = Appearance.FontName;
    FaceLabels(ii).FontWeight = 'normal';
    FaceLabels(ii).Color = Appearance.FaceLabelColor;
    FaceLabels(ii).Tag = 'FACELABELS';
end

copyobj(FaceLabels, Axes);
delete(fig);

end

function plotVertexLabels(Geometry,Axes,Appearance)

if isa(Geometry,'sap.Geometry')
    Geometry = Geometry.geom;
end

%get the label string text
fig = figure('Visible','off'); 
pdegplot(Geometry, 'VertexLabels', 'on');
VertexLabels = findall(gca, 'Type', 'Text');
for ii =1:numel(VertexLabels)
    VertexLabels(ii).String = erase(VertexLabels(ii).String,'V');
    VertexLabels(ii).FontSize = 9;
    VertexLabels(ii).FontName = Appearance.FontName;
    VertexLabels(ii).FontWeight = 'normal';
    VertexLabels(ii).Color = Appearance.VertexLabelColor;
    VertexLabels(ii).Tag = 'VERTEXLABELS';
    VertexLabels(ii).EdgeColor = 'r';
    VertexLabels(ii).HorizontalAlignment = 'left';
end
copyobj(VertexLabels, Axes);
delete(fig);

end

function plotReinforcementLabels(Rei,GeomTag,Axes,Appearance)
    if isempty(Rei)
        return
    end
    for i = 1:numel(Rei.StructuralReinforcementAssignments)
        ThisRei = Rei.StructuralReinforcementAssignments(i);
        EdgeID  = ThisRei.RegionID;
        gObject = findobj(Axes,'Tag', [GeomTag, ' - Edge ' num2str(EdgeID)]);
        Data    = [gObject.XData; gObject.YData];
        numData = size(Data,2);
        pos     = ceil(.75*numData);
        x       = Data(1,pos);
        y       = Data(2,pos);
        text(Axes,x,y,['R', num2str(i)],'HorizontalAlignment','center','VerticalAlignment','bottom',...
            'Color',[0,0.3,0],'FontName',Appearance.FontName,'Tag','REINFORCEMENTLABELS','EdgeColor',[0 .3 0]);
    end
end

function plotFrameAnalysisConstraint(bc,Axes,Appearance)
    if isempty(bc)
        return;
    end
    bbox=set_CanvasBoundingBoxForConstraint(Axes.XLim, Axes.YLim, Axes.ZLim);
    bcData=bc.readConstraintDataForPlot();
    for i=1:size(bcData,1)
        fun = strcat('sap.GraphicModel.',bcData{i,1});
        loc = [bcData{i,2} 0.6*bbox];
        feval(fun,loc,'parent',Axes,'color',Appearance.ConstraintColor)        
    end
end

function plotPlaneAnalysisConstraint(bc,Axes,Appearance)
    if isempty(bc)
        return;
    end
    bbox=set_CanvasBoundingBoxForConstraint(Axes.XLim, Axes.YLim, Axes.ZLim);
    bcData=bc.readConstraintDataForPlot();
    for i = 1:size(bcData,1)
        fun = strcat('sap.GraphicModel.',bcData{i,1});
        if isnumeric(bcData{i,2})
            loc = [bcData{i,2} 0 0.5*bbox];
        else
            loc = {bcData{i,2} 0.5*bbox};
        end
        feval(fun,loc,'parent',Axes,'color',Appearance.ConstraintColor);
    end

end

function plotForceBC(bc,Axes,Appearance)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

if isempty(bc), return; end

bcData=bc.readForceDataToPlot();
if isempty(bcData)
    return
end
bbox=set_CanvasBoundingBoxForConstraint(Axes.XLim, Axes.YLim, Axes.ZLim);
for i = 1:size(bcData,1)
    value = bcData{i,2};
    loc = bcData{i,3};
    uvw = bbox*(value/abs(value));
    
    if numel(loc) == 2
        location = [loc,0];
    else
        location = loc;
    end

    switch cell2mat(bcData{i,1})
        case 'XForce'
        quiver3(location(1),location(2),location(3),uvw,0,0,'Parent',Axes,'Color',Appearance.ForceColor,'MaxHeadSize',.5);
        text(location(1)+uvw,location(2),location(3),num2str(value),'Parent',Axes,'Color',Appearance.ForceColor);
        case 'YForce'
        quiver3(location(1),location(2),location(3),0,uvw,0,'Parent',Axes,'Color',Appearance.ForceColor,'MaxHeadSize',.5);
        text(location(1),location(2)+uvw,location(3),num2str(value),'Parent',Axes,'Color',Appearance.ForceColor)
        case 'ZForce'
        quiver3(location(1),location(2),location(3),0,0,uvw,'Parent',Axes,'Color',Appearance.ForceColor,'MaxHeadSize',.5);
        text(location(1),location(2)+uvw,location(3),num2str(value),'Parent',Axes,'Color',Appearance.ForceColor)
        case 'XMoment'
        text(location(1),location(2)+uvw,location(3),['Mx: ', num2str(value)],'Parent',Axes,'Color',Appearance.ForceColor);
        case 'YMoment'
        text(location(1),location(2)+uvw,location(3),['My: ', num2str(value)],'Parent',Axes,'Color',Appearance.ForceColor);
        case 'ZMoment'
        text(location(1),location(2),location(3),['Mz: ', num2str(value)],'Parent',Axes,'Color',Appearance.ForceColor);
    end
end

end

function plotBCPressure(bc,Axes,Appearance)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

if isempty(bc), return; end

bcData = bc.readBCPressureDataToPlot();
if isempty(bcData)
    return
end

bbox=set_CanvasBoundingBoxForConstraint(Axes.XLim, Axes.YLim, Axes.ZLim);

dl = bc.ParentModel.Geometry.geom;

for i = 1:size(bcData,1)

    tn = bcData{i,2};
    nr = bcData{i,3};
    br = bcData{i,4};

    for j=1:size(br,2)
        sx = 1;
        sy = 1;
        if tn(1,j) < 0
            sx = -1;
        end
        if tn(2,j) < 0
            sy = -1;
        end

        quiver(mean(br([1,3],j))-sx*bbox*nr(1,j),mean(br([2,4],j))-sy*bbox*nr(2,j),sx*bbox*nr(1,j),sy*bbox*nr(2,j),'Parent',Axes,'Color','r','MaxHeadSize',.55)
    end

end

function dirFactor = evaluateDirectionFactor(dl)
dirFactor = 1;
leftMinimalRegion = dl(6);
rightMinimalRegion = dl(7);
if (leftMinimalRegion == 0 && ~rightMinimalRegion == 0)
    dirFactor = -dirFactor;
end

end
end


function plotThermalForcesLabel(bloads,Axes)
if isempty(bloads), return; end

gm = bloads.ParentModel.Geometry;

if contains(bloads.ParentModel.AnalysisType, 'frame')
    d  = gm.GeometricDomain;
    for i=1:numel(bloads.BodyLoadsAssignments)
        bdli=bloads.BodyLoadsAssignments;
        nRegion = bdli.RegionID;
        fRegion = find(d(:,1)==nRegion);
        middlePoints = d(fRegion(1),11:13);
        text(Axes,middlePoints(1),middlePoints(2),middlePoints(3),['ΔT = ' num2str(bdli.Temperature-bloads.ParentModel.ReferenceTemperature)],'Color','r');
    end
else

%get the label string text
fig = figure('Visible','off'); 
pdegplot(gm.geom, 'FaceLabels', 'on');
for i=1:numel(bloads.BodyLoadsAssignments)
    bdli=bloads.BodyLoadsAssignments;
    obj = findobj(gca,'String', ['F',num2str(bdli.RegionID)]);
    text(Axes,obj.Position(1),obj.Position(2),['ΔT = ' num2str(bdli.Temperature-bloads.ParentModel.ReferenceTemperature)],'Color','r')
end

delete(fig);

end
end

function plotGravitationalLabel(bloads,Axes)
if isempty(bloads), return; end

gm = bloads.ParentModel.Geometry;

if contains(bloads.ParentModel.AnalysisType, 'frame')
    d  = gm.GeometricDomain;
    for i=1:numel(bloads.BodyLoadsAssignments)
        bdli=bloads.BodyLoadsAssignments;
        nRegion = bdli.RegionID;
        fRegion = find(d(:,1)==nRegion);
        middlePoints = d(fRegion(1),11:13);
        text(Axes,middlePoints(1),middlePoints(2),middlePoints(3),['Gravity = ' num2str(bdli.GravitationalAcceleration)],'Color','r');
    end
else

%get the label string text
fig = figure('Visible','off'); 
pdegplot(gm.geom, 'FaceLabels', 'on');
for i=1:numel(bloads.BodyLoadsAssignments)
    bdli=bloads.BodyLoadsAssignments;
    obj = findobj(gca,'String', ['F',num2str(bdli.RegionID)]);
    text(Axes,obj.Position(1),obj.Position(2),['Gravity = ' num2str(bdli.GravitationalAcceleration)],'Color','r')
end

delete(fig);

end
end

function plotDistributedForces(dis,Axes,Appearance)

import saplab.ui.internal.*;

distAss = dis.DistributedLoadsAssignments;
gm =dis.ParentModel.Geometry;

for i=1:numel(distAss)
    lineID = distAss(i).RegionID;
    segmentID = 1;
    if ~isscalar(lineID)
        lineID = lineID(1);
        segmentID = lineID(2);
    end
    findRegion = find(and(gm.GeometricDomain(:,1)==lineID,gm.GeometricDomain(:,2)==segmentID));
    x1 = gm.GeometricDomain(findRegion(1),5);
    x2 = gm.GeometricDomain(findRegion(end),6);
    y1 = gm.GeometricDomain(findRegion(1),7);
    y2 = gm.GeometricDomain(findRegion(end),8);
    z1 = gm.GeometricDomain(findRegion(1),9);
    z2 = gm.GeometricDomain(findRegion(end),10);    
    
    Rmat = gm.evalTrasformationMatrix(lineID,'components');

    xxp = linspace(x1,x2,14);
    yyp = linspace(y1,y2,14);
    zzp = linspace(z1,z2,14);


    bbox=set_CanvasBoundingBoxForConstraint(Axes.XLim, Axes.YLim, Axes.ZLim);
    [xx,yy,zz] = generateThreeLoadArrow(bbox);
    xx = rotate3D(xx,Rmat,[0,0,0]);
    yy = rotate3D(yy,Rmat,[0,0,0]);
    zz = rotate3D(zz,Rmat,[0,0,0]);

    qx = distAss(i).XForce;
    qy = distAss(i).YForce;
    qz = distAss(i).ZForce;

    if qy~=0
        if qy < 0
        for k=1:numel(xxp)
        quiver3(Axes,xx(2,2)-xx(2,1)+xxp(k),yy(2,2)-yy(2,1)+yyp(k),zz(2,2)-zz(2,1)+zzp(k),...
                xx(2,1),yy(2,1),zz(2,1),'Color','r','LineWidth',.5,'MaxHeadSize',0.8);   
        end
        xb = [xx(2,2)-xx(2,1)+xxp(1) xx(2,2)-xx(2,1)+xxp(end)];
        yb = [yy(2,2)-yy(2,1)+yyp(1) yy(2,2)-yy(2,1)+yyp(end)];
        zb = [zz(2,2)-zz(2,1)+zzp(1) zz(2,2)-zz(2,1)+zzp(end)];
        plot3(Axes,xb,yb,zb,'r')
        elseif qy>0
        for k=1:numel(xxp)
        quiver3(Axes,xx(2,2)+xx(2,1)+xxp(k),yy(2,2)+yy(2,1)+yyp(k),zz(2,2)+zz(2,1)+zzp(k),...
                -xx(2,1),-yy(2,1),-zz(2,1),'Color','r','LineWidth',.5,'MaxHeadSize',0.8);        
        end
        xb = [xx(2,2)+xx(2,1)+xxp(1) xx(2,2)+xx(2,1)+xxp(end)];
        yb = [yy(2,2)+yy(2,1)+yyp(1) yy(2,2)+yy(2,1)+yyp(end)];
        zb = [zz(2,2)+zz(2,1)+zzp(1) zz(2,2)+zz(2,1)+zzp(end)];
        plot3(Axes,xb,yb,zb,'r')
        end
    end

    if qz~=0
        if qz < 0
        for k=1:numel(xxp)
        quiver3(Axes,xx(3,2)-xx(3,1)+xxp(k),yy(3,2)-yy(3,1)+yyp(k),zz(3,2)-zz(3,1)+zzp(k),...
                xx(3,1),yy(3,1),zz(3,1),'Color','r','LineWidth',.5,'MaxHeadSize',0.8);   
        end
        xb = [xx(3,2)-xx(3,1)+xxp(1) xx(3,2)-xx(3,1)+xxp(end)];
        yb = [yy(3,2)-yy(3,1)+yyp(1) yy(3,2)-yy(3,1)+yyp(end)];
        zb = [zz(3,2)-zz(3,1)+zzp(1) zz(3,2)-zz(3,1)+zzp(end)];
        plot3(Axes,xb,yb,zb,'r')
        elseif qz>0
        for k=1:numel(xxp)
        quiver3(Axes,xx(3,2)+xxp(k),yy(3,2)+yyp(k),zz(3,2)+zzp(k),...
                -xx(3,1),-yy(3,1),-zz(3,1),'Color','r','LineWidth',.5,'MaxHeadSize',0.8);            
        end
        xb = [xx(3,2)+xx(3,1)+xxp(1) xx(3,2)+xx(3,1)+xxp(end)];
        yb = [yy(3,2)+yy(3,1)+yyp(1) yy(3,2)+yy(3,1)+yyp(end)];
        zb = [zz(3,2)+zz(3,1)+zzp(1) zz(3,2)+zz(3,1)+zzp(end)];
        plot3(Axes,xb,yb,zb,'r')
        end
    end
    
    
    if qx~=0
        xxp(end) = [];
        yyp(end) = [];
        zzp(end) = [];
        if qx < 0
        for k=1:numel(xxp)
        quiver3(Axes,xx(1,2)-xx(1,1)+xxp(k),yy(1,2)-yy(1,1)+yyp(k),zz(1,2)-zz(1,1)+zzp(k),...
                xx(1,1),yy(1,1),zz(1,1),'Color','r','LineWidth',.95,'MaxHeadSize',0.6);       
        end
        elseif qx>0
        for k=1:numel(xxp)
        quiver3(Axes,xx(1,2)+xxp(k),yy(1,2)+yyp(k),zz(1,2)+zzp(k),...
                -xx(1,1),-yy(1,1),-zz(1,1),'Color','r','LineWidth',.95,'MaxHeadSize',0.6);         
        end
        end
    end

end
end

function plotDistributedForce(dis,Axes,Appearance)

disData=dis.readDistrDataToPlot();
if isempty(disData)
    return
end    

bbox=set_CanvasBoundingBoxForConstraint(Axes.XLim, Axes.YLim, Axes.ZLim);

for i=1:size(disData,1)
    if strcmpi(disData{i,1}, 'XForce')
        if dis.ParentModel.Geometry.SysDim == 3
        value = disData{i,2};
        location = disData{i,4};
        sign = value/abs(value);
        
        if sign > 0
            for j=2:size(location,2)
                xl = [location(1,j-1);location(1,j)-location(1,j-1)];
                yl = [location(2,j-1);location(2,j)-location(2,j-1)];
                quiver(xl(1),yl(1),xl(2),yl(2),'Color','r','Parent',Axes);
            end
        else
            for j=size(location,2):-1:2
                xl = [location(1,j);location(1,j-1)-location(1,j)];
                yl = [location(2,j);location(2,j-1)-location(2,j)];
                quiver(xl(1),yl(1),xl(2),yl(2),'Color','r','Parent',Axes);
            end

        end

        xl = [location(1,1) location(1,end)];
        yl = [location(2,1) location(2,end)];

        text(Axes,0.5*sum(xl),0.5*sum(yl),num2str(value),'Color','r')


        else
            value = disData{i,2};
            location = disData{i,4};
            sign = value/abs(value);
            
            if sign > 0
                for j=2:size(location,2)
                    xl = [location(1,j-1);location(1,j)-location(1,j-1)];
                    yl = [location(2,j-1);location(2,j)-location(2,j-1)];
                    zl = [location(3,j-1);location(3,j)-location(3,j-1)];
                    quiver3(xl(1),yl(1),zl(1),xl(2),yl(2),zl(2),'Color','r','Parent',Axes,'LineWidth',.65);
                end
            else
                for j=size(location,2):-1:2
                    xl = [location(1,j);location(1,j-1)-location(1,j)];
                    yl = [location(2,j);location(2,j-1)-location(2,j)];
                    zl = [location(3,j);location(3,j-1)-location(3,j)];
                    quiver3(xl(1),yl(1),zl(1),xl(2),yl(2),zl(2),'Color','r','Parent',Axes,'LineWidth',.65);
                end
            end
            xl = [location(1,1) location(1,end)];
            yl = [location(2,1) location(2,end)];
            zl = [location(3,1) location(3,end)];
            text(Axes,0.5*sum(xl),0.5*sum(yl),0.5*sum(zl),num2str(value),'Color','r')
        end

    elseif strcmpi(disData{i,1},'YForce')
        if dis.ParentModel.Geometry.SysDim == 3
            value = disData{i,2};
            load  = disData{i,3}; %normal
            location = disData{i,4};
            sign = value/abs(value);
            rValue = bbox*sign;
            for j =1:size(load,2)
            dlx=rValue*load(1,j);
            dly=rValue*load(2,j);
            dlz=0*load(2,j);
            quiver3(location(1,j)-dlx,location(2,j)-dly,location(3,j)-dlz,rValue*load(1,j),rValue*load(2,j),0*load(2,j),'Parent',Axes,'Color',Appearance.ForceColor,'MaxHeadSize',.55)
            end
            xl = [location(1,1)-rValue*load(1,1) location(1,end)-rValue*load(1,end)];
            yl = [location(2,1)-rValue*load(2,1) location(2,end)-rValue*load(2,end)];
            zl = [location(3,1)-0*rValue*load(2,1) location(3,end)-0*rValue*load(2,end)];
            plot3(Axes,xl,yl,zl,'Color',Appearance.ForceColor);
            text(Axes,0.5*sum(xl),0.5*sum(yl),num2str(value),'Color','r')
        else
            value = disData{i,2};
            load  = disData{i,3}; %normal
            location = disData{i,4};
            sign = value/abs(value);
            rValue = 0.75*bbox*sign;
            for j =1:size(load,2)
            dlx=rValue*load(1,j);
            dly=rValue*load(2,j);
            dlz=0*load(2,j);
            quiver3(location(1,j)-dlx,location(3,j)-dlz,location(2,j)-dly,rValue*load(1,j),0*load(2,j),rValue*load(2,j),'Parent',Axes,'Color',Appearance.ForceColor,'MaxHeadSize',.45)
            end
            xl = [location(1,1)-rValue*load(1,1) location(1,end)-rValue*load(1,end)];
            yl = [location(2,1)-rValue*load(2,1) location(2,end)-rValue*load(2,end)];
            zl = [location(3,1)-0*rValue*load(2,1) location(3,end)-0*rValue*load(2,end)];
            plot3(Axes,xl,zl,yl,'Color',Appearance.ForceColor);
            text(Axes,0.5*sum(xl),0.5*sum(zl),0.5*sum(yl),num2str(value),'Color','r')
        end
    elseif strcmpi(disData{i,1},'ZForce')
        value = disData{i,2};
        load  = disData{i,3}; %normal
        location = disData{i,4};
        sign = value/abs(value);
        rValue = bbox*sign;
        for j =1:size(load,2)
        dlx=rValue*load(1,j);
        dly=rValue*load(2,j);
        dlz=0*load(2,j);
        quiver3(location(1,j)-dlx,location(3,j)-dlz,location(2,j)-dly,rValue*load(1,j),0*load(2,j),rValue*load(2,j),'Parent',Axes,'Color',Appearance.ForceColor,'MaxHeadSize',.55)
        end
        xl = [location(1,1)-rValue*load(1,1) location(1,end)-rValue*load(1,end)];
        yl = [location(2,1)-rValue*load(2,1) location(2,end)-rValue*load(2,end)];
        zl = [location(3,1)-0*rValue*load(2,1) location(3,end)-0*rValue*load(2,end)];
        plot3(Axes,xl,yl,zl,'Color',Appearance.ForceColor);
        text(Axes,0.5*sum(xl),0.5*sum(yl),0.5*sum(zl),num2str(value),'Color','r')        
    elseif strcmpi(disData{i,1},'XMoment') || strcmpi(disData{i,1},'YMoment') || strcmpi(disData{i,1},'ZMoment')
        value = disData{i,2};
        location = disData{i,4};
        xl = [location(1,1) location(1,end)];
        yl = [location(2,1) location(2,end)];
        zl = [location(3,1) location(3,end)];
        
        if strcmpi(disData{i,1},'XMoment')
            tag = 'mx';
        elseif strcmpi(disData{i,1},'YMoment')
            tag = 'my';
        else
            tag = 'mz';
        end

        text(Axes,0.5*sum(xl),0.5*sum(yl),0.5*sum(zl),[tag, ': ', num2str(value)],'Color','r')
    end    
end
end

function bbox=set_CanvasBoundingBoxForConstraint(xlim,ylim,zlim)
%evaluate bounding box
lim = abs([xlim(1),xlim(2),ylim(1),ylim(2),zlim(1),zlim(2)]); 
maxlim = (max(lim));
minlim = (min(lim));
bbox = (maxlim-minlim)/20;
end

function bbox=set_CanvasBoundingBox(xlim,ylim,zlim)
%evaluate bounding box
bbox(1,1) = xlim(1);
bbox(1,2) = xlim(2);
bbox(2,1) = ylim(1);
bbox(2,2) = ylim(2);
bbox(3,1) = zlim(1);
bbox(3,2) = zlim(2);
% lim = abs([xlim(1),xlim(2),ylim(1),ylim(2),zlim(1),zlim(2)]); 
% gradients = (max(lim));
% bbox = gradients/20;
end