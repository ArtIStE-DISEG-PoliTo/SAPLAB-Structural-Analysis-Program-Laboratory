function mtl = getReleaseCondition(m, varargin)
%getReleaseCondition - Find release condition in
%sap.StructuralRCRecords object

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%                           Find Release Condition                          %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

narginchk(1,11);

p = inputParser();
addParameter(p, 'Line', []);
parse(p, varargin{:});

args = varargin;
try
    mtl = findStructuralRelease(m,args{:});
catch ME
    throw(ME)
end


end
