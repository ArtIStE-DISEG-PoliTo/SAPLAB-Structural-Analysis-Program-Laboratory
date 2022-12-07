function msh = mesh(g, varargin)
%mesh mesh the model geometry
%
if ~isa(g, 'sap.Geometry')
     error('Invalid geometry');
end

m = g.ParentModel;

parser = inputParser;
addParameter(parser, 'Line', []);
addParameter(parser, 'ElementSize', []);
addParameter(parser, 'Face', []);
addParameter(parser,'Hmax',0);
addParameter(parser,'Hmin',0);       
addParameter(parser,'Hgrad',0);
addParameter(parser,'GeometricOrder','linear');        
addParameter(parser,'Hface',{});
addParameter(parser,'Hedge',{});
addParameter(parser,'Hvertex',{});
parse(parser, varargin{:});

% try
    args = varargin;
    msh = FEMeshInternal(m, args{:});
% catch ME
%      error(ME.message);
% end


end