function bc = setBoundaryCondition(m, varargin)
%setBoundaryCondition - Apply boundary conditions to model
%   bc = setBoundaryCondition(structuralmodel,'REGIONTYPE',REGIONID,'Name',Value)
%   applies a structural boundary condition to a structural model. BC
%   is applied on a region of the boundary defined by REGIONTYPE and
%   REGIONID. Here, REGIONTYPE for a 1-D model is 'Point'.
%   REGIONTYPE for a 2-D model is 'Edge' or 'Vertex'. REGIONID is
%   an rounded number specifying the ID of a point, vertex, or edge of the
%   model geometry.
p = inputParser();
p.addParameter('Point',[]);
p.addParameter('Vertex',[]);
p.addParameter('Edge', []);
p.addParameter('Constraint', [])
p.addParameter('Displacement', []);
p.addParameter('XDisplacement', []);
p.addParameter('YDisplacement', []);
p.addParameter('ZDisplacement', []);
p.addParameter('Rotation', []);
p.addParameter('XRotation', []);
p.addParameter('YRotation', []);
p.addParameter('ZRotation', []);
p.addParameter('Force', []);
p.addParameter('XForce', []);
p.addParameter('YForce', []);
p.addParameter('ZForce', []);
p.addParameter('Moment', []);
p.addParameter('XMoment', []);
p.addParameter('YMoment', []);
p.addParameter('ZMoment', []);
p.addParameter('Pressure', []);
p.parse(varargin{:});

try 
    bc = boundaryCondition(m,varargin{:});
catch ME
    throw(ME);
end

end

