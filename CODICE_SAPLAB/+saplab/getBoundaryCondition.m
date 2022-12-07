function mtl = getBoundaryCondition(m, varargin)
%getBoundaryCondition - Find boundary condition in
%sap.BoundaryConditionRecords object

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%                          Find Boundary Condition                          %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

narginchk(1,11);

p = inputParser();
addParameter(p, 'point', []);
addParameter(p, 'edge', []);
addParameter(p, 'vertex', []);
parse(p, varargin{:});

args = varargin;
try
    mtl = findBoundaryCondition(m,args{:});
catch ME
    throw(ME)
end


end
