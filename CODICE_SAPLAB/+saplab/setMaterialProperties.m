function mtl = setMaterialProperties(self, varargin)
%setMaterialProperties - Assign structural material properties to the self
%   mtl = structuralMaterial(structuralmodel,PROPERTY,VALUE) assigns
%   material properties to a structural model. Structural model supports
%   only isotropic materials, hence each VALUE must be specified as a
%   numeric scalar.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%             Apply Structural Material Properties To Model                 %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

narginchk(1,11);

p = inputParser();
addParameter(p, 'Line', []);
addParameter(p, 'Face', []);
addParameter(p, 'Reinforcement', []);
addParameter(p, 'YoungsModulus', [])
addParameter(p, 'PoissonsRatio', [])
addParameter(p, 'MassDensity', [])
addParameter(p, 'CTE', [])
parse(p, varargin{:});

[tRegion, nRegion, args] = extractInputParserData(p);

mtl = cell(numel(nRegion),1);
try
    for i=1:numel(nRegion)
        mtl{i} = structuralMaterial(self, tRegion, nRegion(i), args{:});
    end
catch ME
    throw(ME)
end

if numel(mtl) == 1
    mtl = mtl{1};
end

end

function [tRegion, nRegion, args] = extractInputParserData(p)
    if ~isempty(p.Results.Line)
        tRegion = 'Line';
        nRegion = p.Results.Line;
    end
    if ~isempty(p.Results.Face)
        tRegion = 'Face';
        nRegion = p.Results.Face;
    end
    if ~isempty(p.Results.Reinforcement)
        tRegion = 'Reinforcement';
        nRegion = p.Results.Reinforcement;
    end

    if ~isempty(p.Results.YoungsModulus)
        args = {'YoungsModulus', p.Results.YoungsModulus};
    end

    if ~isempty(p.Results.PoissonsRatio)
        args = [args {'PoissonsRatio', p.Results.PoissonsRatio}];
    end    

    if ~isempty(p.Results.MassDensity)
        args = [args {'MassDensity', p.Results.MassDensity}];
    end  

    if ~isempty(p.Results.CTE)
        args = [args {'CTE', p.Results.CTE}];
    end 
end