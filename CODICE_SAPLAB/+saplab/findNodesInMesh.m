function r = findNodesInMesh(msh, varargin)
%findElementsInMesh Find Elements in mesh object

p = inputParser();
addParameter(p, 'Face',[]);
addParameter(p, 'Line',[]);
addParameter(p, 'Edge',[]);
addParameter(p, 'Vertex',[]);
addParameter(p, 'Point',[]);
parse(p, varargin{:});

args = varargin;

try
     r = findMesh(msh,'Parameter','Node',args{:});
catch ME
     error(ME.message);
end

end