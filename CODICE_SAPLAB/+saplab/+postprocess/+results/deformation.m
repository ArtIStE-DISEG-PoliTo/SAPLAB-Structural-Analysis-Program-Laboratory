function hh = deformation(m, varargin) %deformation(m, 'ScaleFactor', sf, 'Parent', ax)
%DEFORMATION Plot the deformation of the structural model

p = inputParser();
addParameter(p,'scaleFactor',[],@(x) isnumeric(x) && isscalar(x) && x>0)
addParameter(p,'Parent', [], @validateParent);
parse(p, varargin{:})

ax = p.Results.Parent;
scaleFactor = p.Results.scaleFactor;
if isempty(ax)
    ax = gca;
end

%plot the geometry
hh=saplab.gplot(m,'Parent', ax);

%check if model has been solved
if isempty(m.Results)
     warning('Structural model with no results.'); return;
end

%get mesh points 
tt = m.Mesh.t;
pp = m.Mesh.p;

switch m.AnalysisType
    case {'static-planeframe','static-spaceframe'}

    case {'static-planestress','static-planestrain'}

        %compute the bounding box
        bbox = [min(pp(1,:)) max(pp(1,:)); ...
                min(pp(2,:)) max(pp(2,:))];        

        %get the results
        nodalSolution = m.Results.NodalSolution;
        dx = nodalSolution.dx;
        dy = nodalSolution.dy;

        if isempty(scaleFactor)
           MaxDeformationMag = max(sqrt(nodalSolution.dx.^2+nodalSolution.dy.^2));
           scaleFactor = min(abs(bbox(:,2) - bbox(:,1)))/MaxDeformationMag;
        end
     
        pp = pp+scaleFactor*[dx';dy'];
        triplot(m.Mesh.Elements',pp(1,:),pp(2,:),'Parent',ax)

    otherwise

        %compute the bounding box
        bbox = [min(pp(1,:)) max(pp(1,:)); ...
                min(pp(2,:)) max(pp(2,:))];      
        
        %get the results
        nodalSolution = m.Results.NodalSolution;
        dx = nodalSolution.dx;
        dy = nodalSolution.dy;

        if isempty(scaleFactor)
           MaxDeformationMag = max(sqrt(nodalSolution.dx.^2+nodalSolution.dy.^2));
           if MaxDeformationMag>eps(10)
               scaleFactor = min(bbox(:,2) - bbox(:,1))/MaxDeformationMag;
           else
               scaleFactor = 0;
           end
        end

        pp(1,:)=pp(1,:)+scaleFactor*dx';
        pp(2,:)=pp(2,:)+scaleFactor*dy';

        plot(ax,pp(1,:),pp(2,:),'ob')

end
end

function validateParent(ax)
     if ~isa(ax,'matlab.ui.control.UIAxes') && ~isa(ax,'matlab.graphics.axis.Axes')
     error('Invalid axes object');
     end
end