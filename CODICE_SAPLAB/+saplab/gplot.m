function hh = gplot(m, varargin)
%GPLOT Plot saplab model geometry representation
%   Detailed explanation goes here

%default plot labels
defplotLabels = 'off';

p = inputParser();
addParameter(p,'LineLabels',defplotLabels,@isValidOptionOnOff);
addParameter(p,'PointLabels',defplotLabels,@isValidOptionOnOff);
addParameter(p,'EdgeLabels',defplotLabels,@isValidOptionOnOff);
addParameter(p,'VertexLabels',defplotLabels,@isValidOptionOnOff);
addParameter(p,'FaceLabels',defplotLabels,@isValidOptionOnOff);
addParameter(p,'FRPLabels',defplotLabels,@isValidOptionOnOff);
addParameter(p,'Tag', []);
addParameter(p,'Parent',[],@isValidAxes);
addParameter(p,'View',[],@isnumeric);
parse(p, varargin{:});

%get parser results
pr = p.Results;

ax = pr.Parent;
if isempty(ax)
     ax = gca;
end

if isa(m,'sap.Geometry')
   m = m.ParentModel;
end

if ~strcmpi(pr.Tag,'all')
cla(ax);
end

%validate 'm' input
mustBeA(m,"sap.StructuralModel");

%plot sap.StructuralModel geometry
if isempty(pr.Tag)
 switch m.AnalysisType
     case {'static-planeframe','static-spaceframe'}
         %link canvas for gui
         saplab.ui.linkFrameGeomToCanvas(m);
         %plot geometry
         saplab.graphics.geometry.plotGeometry1D(ax, m);
         %plot constraint
         saplab.graphics.geometry.plotGeometry1D_Constraint(ax, m);
     case {'static-planestress','static-planestrain'}
         %link canvas for gui
         saplab.ui.linkFaceGeomToCanvas(m,m.Geometry.geom,m.Geometry.geomTag);    
         %plot geometry
         saplab.graphics.geometry.plotGeometry2D(ax, m);
         %plot constraint
         saplab.graphics.geometry.plotGeometry2D_Constraint(ax, m);     
     case 'coupled-static-planestress'
         %link canvas for gui    
         saplab.ui.linkFaceGeomToCanvas(m,m.Geometry.geom,m.Geometry.geomTag);   
         %plot geometry
         saplab.graphics.geometry.plotGeometry2DWithFRP(ax, m)    
         %plot constraint
         saplab.graphics.geometry.plotGeometry2D_Constraint(ax, m);  
 end
end


%coumpute bounding box
bbox=saplab.graphics.set_CanvasBoundingBox(ax.XLim,ax.YLim,ax.ZLim);

%avoid axis triad bug

if isprop(m.Geometry,'NumPoints')
    np = m.Geometry.NumPoints;
    if (np == 1)
       ax.XLim = 2*[bbox(1,2)*ax.XLim(1) bbox(1,2)*ax.XLim(2)];
       ax.YLim = 2*[bbox(1,2)*ax.YLim(1) bbox(1,2)*ax.YLim(2)];
       ax.ZLim = 2*[bbox(1,2)*ax.ZLim(1) bbox(1,2)*ax.ZLim(2)];
    end
end

saplab.graphics.plotAxisTriad(ax, m.Graphics.Appearance, bbox);

%plot not imported 2D geometry
m = saplab.graphics.geometry.plotGeometry2DbyTag(ax,m,pr.Tag);

%output
if nargout > 0 && ~strcmpi(pr.Tag, 'all')
hh.LineLabels  = @(OnOff) saplab.graphics.labels.showLineLabels(ax, m, OnOff);
hh.PointLabels = @(OnOff) saplab.graphics.labels.showPointLabels(ax, m, OnOff);
hh.EdgeLabels =  @(OnOff) saplab.graphics.labels.showEdgeLabels(ax, m, OnOff);
hh.FaceLabels =  @(OnOff) saplab.graphics.labels.showFaceLabels(ax, m, OnOff);
hh.VertexLabels =  @(OnOff) saplab.graphics.labels.showVertexLabels(ax, m, OnOff);
hh.ReinforcementLabels = @(OnOff) saplab.graphics.labels.showReiLabels(ax, m, OnOff);
else

end

axis(ax,'equal');
ax.Clipping = 'off';

if ~isempty(pr.View)
     ax.View = pr.View;
end
axis(ax,'tight')
box(ax,'off')


end


%// Helper functions 
function tf = isValidOptionOnOff(opt)
    try
       validatestring(opt,{'on', 'off'}) ;
    catch
       error("Acceptable values are 'on' and 'off'");   
    end
    tf = true;
end

function isValidAxes(ax)
     if ~isa(ax,'matlab.ui.control.UIAxes') && ~isa(ax,'matlab.graphics.axis.Axes')
     error('Invalid axes object');
     end
end


