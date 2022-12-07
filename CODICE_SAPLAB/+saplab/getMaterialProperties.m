function mtl = getMaterialProperties(self, varargin)
%getMaterialProperties - Find material properties in sap.MaterialPropertiesRecords
%object

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%                    Find Structural Material Properties                    %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

narginchk(1,11);

p = inputParser();
addParameter(p, 'line', []);
addParameter(p, 'face', []);
addParameter(p, 'reinforcement', []);
parse(p, varargin{:});

if ~isempty(p.Results.line)
    rQueries = p.Results.line;
    tRegion = 'Line';
elseif ~isempty(p.Results.face)
    rQueries = p.Results.face;
    tRegion = 'Face';
elseif ~isempty(p.Results.reinforcement)
    rQueries = p.Results.reinforcement;
    tRegion = 'Reinforcement';
end

try
    mtl = findMaterialProperties(self,tRegion,rQueries);
catch ME
    throw(ME)
end


end
