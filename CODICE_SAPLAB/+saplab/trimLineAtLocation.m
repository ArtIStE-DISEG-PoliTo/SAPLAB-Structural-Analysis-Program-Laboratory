function trimLineAtLocation(m,varargin)
%TRIMLINEATDISTANCE Trim line at specific distance from extreme points

narginchk(3,5);

p = inputParser();
p.addParameter('Line',[]);
p.addParameter('origin','start',@(x) or(strcmpi(x,'start'),strcmpi(x,'end')));
p.parse(varargin{:});

if ~isa(m,'sap.FEModel')
    error('Invalid structural model object.');
else
    g = m.Geometry;
end

if isa(m,'sap.Geometry')
    g = m;
end

if isempty(g)
    error('Model does not have geometry.');
end

trimOpt = p.Results.Line;
origin = p.Results.origin;

try
    g.trimLineAtLocation(trimOpt(1),trimOpt(2),origin);
catch ME
    throw(ME);
end