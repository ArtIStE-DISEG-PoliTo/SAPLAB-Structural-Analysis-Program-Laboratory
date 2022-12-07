function rplot(m, varargin)
%RPLOT Plot structural results data
%   Detailed explanation goes here
p = inputParser();
if strcmpi(varargin{1},'Deformation')
    plotu = true;
    addRequired(p,'Param')
    addParameter(p,'ColorMap',[]);
    addParameter(p,'Parent',  []);
    parse(p,varargin{1}, varargin{2:end});
else
    plotu=false;
    addParameter(p,'Diagram',  []);
    addParameter(p,'ColorMap',[]);
    addParameter(p,'Parent',  []);
    addParameter(p,'XYData',  []);
    parse(p,varargin{:});
end
pr = p.Results;

if isempty(pr.Parent)
    ax = gca;
else
    ax = pr.Parent;
end

cla(ax);
m.Graphics.Appearance.LineLabelColor = [.5,.5,.5];
m.Graphics.Appearance.EdgeColor = [0.5,.5,.5];
m.Graphics.Appearance.PointColor = 'none';
m.Graphics.Appearance.VertexColor = 'none';
m.Graphics.Appearance.ReinforcementColor = 'none';
m.Graphics.Appearance.LineStyle = ':';
% m.Graphics.Appearance.LineWidth = .5;
xx = m.Mesh.Nodes(1,:);
yy = m.Mesh.Nodes(2,:);

if size(m.Mesh.Nodes,1) == 2, zz = 0*m.Mesh.Nodes(2,:); else, zz = m.Mesh.Nodes(2,:); end  


if isempty(m.Results)
    error('Model has not been solved.')
end
if plotu 
    param = pr.Param;
    switch param
        case 'Deformation'
        deformation = m.Results.NodalSolution;
        if contains(m.AnalysisType, 'frame')
            m.Graphics.Appearance.LineWidth = 0.5; 
           saplab.gplot(m)
           scaleFactor = evalScaleFactorFcn(deformation, [], xx, yy, zz);
           saplab.postprocess.results.plotDeformedShape1(ax, m, scaleFactor);   
        elseif ~contains(m.AnalysisType, 'frame') && ~contains(m.AnalysisType, 'coupled')
             saplab.gplot(m,'Parent',ax);
           scaleFactor = evalScaleFactorFcn(deformation, [], xx, yy, zz);
           saplab.postprocess.results.plotDeformedShape2(ax, m, scaleFactor)
        elseif ~contains(m.AnalysisType, 'frame') && contains(m.AnalysisType, 'coupled')
           saplab.gplot(m,'Parent',ax);
           scaleFactor = evalScaleFactorFcn(deformation, [], xx, yy, zz);
           saplab.postprocess.results.plotDeformedShape2(ax, m, scaleFactor)
        end
    end
else
    diagr = pr.Diagram;
    xydata = pr.XYData;
    if ~isempty(diagr)
        if ~contains(m.AnalysisType, 'frame'), error('Functionality not supported.'); end
        m.Graphics.Appearance.LineStyle = '-';  
        saplab.gplot(m,'Parent',ax);     
        saplab.postprocess.results.plotDiagrams(ax, m, diagr, []);
    end
    if ~isempty(xydata)
       if contains(m.AnalysisType,'frame')
            m.Graphics.Appearance.LineStyle = ':';  
            m.Graphics.Appearance.LineWidth = 0.5; 
            saplab.gplot(m,'Parent',ax);     

           scaleFactor = evalScaleFactorFcn(m.Results.NodalSolution, [], xx, yy, zz);
           saplab.postprocess.results.ContourPlotData1(ax, m, xydata, scaleFactor);
       else
%            m.Graphics.Appearance.LineStyle = ':';  
%            m.Graphics.Appearance.LineWidth = 0.5;            
%            saplab.gplot(m,'Parent',ax);  
           scaleFactor = evalScaleFactorFcn(m.Results.NodalSolution, [], xx, yy, zz);
           saplab.postprocess.results.ContourPlotData(ax, m, xydata, scaleFactor);
       end

    end
end


axis(ax,'equal');
axis(ax,'tight')
box(ax,'off')
ax.Clipping = 'off';


end

function scaleFactor = evalScaleFactorFcn(deformation, scaleFactor, xx, yy, zz)

%compute the bounding box
bbox = [min(xx) max(xx); ...
        min(yy) max(yy); ...
        min(zz) max(zz)];
maxbbox = max(mean(bbox));

if ~isempty(deformation) && isempty(scaleFactor)
     if ~isfield(deformation,'uz')
     MaxDeformationMag = 15*max(sqrt(deformation.ux.^2+deformation.uy.^2));
     else
     MaxDeformationMag = 15*max(sqrt(deformation.ux.^2+deformation.uy.^2+deformation.uz.^2));
     end
     tf = MaxDeformationMag>eps(10);
     if tf
        scaleFactor = 250*max(bbox(:,2) - bbox(:,1))/(maxbbox*MaxDeformationMag); % Based on lowest bounding box dimension
     else
        scaleFactor = 0;
     end
end
end

