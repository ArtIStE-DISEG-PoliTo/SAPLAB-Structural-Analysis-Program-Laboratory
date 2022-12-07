function r = findElementsInMesh(msh, varargin)
%findElementsInMesh Find Elements in mesh object
p = inputParser();
addParameter(p, 'Face',[]);
addParameter(p, 'Line',[]);
addParameter(p, 'Edge',[]);
addParameter(p, 'Vertex',[]);
addParameter(p, 'Point',[]);
parse(p, varargin{:});
% msh.ParentModel.Geometry
% and(~isprop('NumLines', msh.ParentModel.Geometry),~isempty(p.Results.Line))
% if and(~isprop('NumLines', msh.ParentModel.Geometry),~isempty(p.Results.Line))
%      error('No line(s) region(s) found.')
% end
% if ~isprop('NumFaces', msh.ParentModel.Geometry) && (~isempty(p.Results.Face) || ~isempty(p.Results.Edge) || ~isempty(p.Results.Vertex))
%      error('No plane surface(s) found.')
% end
args = varargin;

try
     r = findMesh(msh,'Parameter','Element',args{:});
catch ME
     error(ME.message);
end
end