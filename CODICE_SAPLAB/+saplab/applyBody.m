function bdl = applyBody(m, varargin)
%applyBody Apply body loads
%bdl = applyBody(STRUCTURALMODEL, NAME, VALUE) - Applies body load
% to a structural model. Body load acts on the entire volume of the
% material.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%             Apply Structural Body Load to Structural Model                %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

p = inputParser();
addParameter(p, 'Face', []);
addParameter(p, 'Line', []);
addParameter(p, 'GravitationalAcceleration', []);
addParameter(p, 'Temperature', []);
parse(p, varargin{:});

args = parserInputScheme(p.Results);

tRegion = 'Face';
nRegion = p.Results.Face;
if isempty(nRegion)
    tRegion = 'Line';
    nRegion = p.Results.Line;
    if any(nRegion>m.Geometry.NumLines)
          error('Some of the region IDs exceed the number of lines in the geometry.')
    end
end

bdl = cell(numel(nRegion),1);
try
     for i=1:numel(nRegion)
          bdl{i} = structuralBodyLoad(m, tRegion, nRegion(i), args{:});
     end
catch ME
     error(ME.message)
end

if isscalar(nRegion)
     bdl = bdl{1};
end

end

function args = parserInputScheme(pr)
     args = [];
     if ~isempty(pr.GravitationalAcceleration)
         args = {'GravitationalAcceleration', pr.GravitationalAcceleration};
     end

     if ~isempty(pr.Temperature)
          args = [args, {'Temperature', pr.Temperature}];
     end
end