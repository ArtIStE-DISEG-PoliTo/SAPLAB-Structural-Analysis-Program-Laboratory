function mtl = getSectionProperties(self, varargin)
%getSectionProperties - Find section properties in sap.SectionPropertiesRecords
%object

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%                     Find Structural Section Properties                    %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

narginchk(1,11);

p = inputParser();
addParameter(p, 'line', []);
parse(p, varargin{:});

rQueries = p.Results.line;
tRegion = 'Line';

try
    mtl = findSectionProperties(self,tRegion,rQueries);
catch ME
    throw(ME)
end


end
