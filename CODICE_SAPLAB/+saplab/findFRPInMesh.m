function r = findFRPInMesh(msh, varargin)
%findElementsInMesh Find Elements in mesh object

if ~isprop(msh.ParentModel,'StructuralReinforcement')
     error('Model does not have Structural Reinforcement property.')
end

p = inputParser();
addParameter(p, 'Parameter',[]);
addParameter(p, 'Reinforcement',[]);
addParameter(p, 'Spring',[]);
parse(p, varargin{:});

args = varargin;

try
     r = findMesh(msh, args{:});
catch ME
     error(ME.message);
end

end