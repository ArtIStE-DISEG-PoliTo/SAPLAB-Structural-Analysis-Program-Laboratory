function sct = setSectionProperties(self, varargin)
%setSectionProperties - Assign structural sction properties to the model
%   sct = STRUCTURALSECTION(structuralmodel,PROPERTY,VALUE) assigns
%   section properties to a line regions of a structural model. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%              Assign Structural Section to StructuralModel                 %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

p = inputParser();
addParameter(p, 'Line', []);
addParameter(p, 'Area', []);
addParameter(p, 'TorsionalConstant', []);
addParameter(p, 'Inertia',[]);
p.parse(varargin{:});

nRegion = p.Results.Line;
sct = cell(numel(nRegion),1);
[tRegion, nRegion, args] = extractInputParserData(p);
try
    for i=1:numel(nRegion)
    sct = structuralSection(self, tRegion, nRegion(i), args{:});
    end
catch ME
    throw(ME)
end

end

function [tRegion, nRegion, args] = extractInputParserData(p)
    if ~isempty(p.Results.Line)
        tRegion = 'Line';
        nRegion = p.Results.Line;
    end

    if ~isempty(p.Results.Area)
        args = {'Area', p.Results.Area};
    end

    if ~isempty(p.Results.Inertia)
        args = [args {'Inertia', p.Results.Inertia}];
    end    

    if ~isempty(p.Results.TorsionalConstant)
        args = [args {'TorsionalConstant', p.Results.TorsionalConstant}];
    end  
end