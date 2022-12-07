function rc = setReleaseCondition(m, varargin)
%sr = setReleaseCondition(STRUCTURALMODEL, NAME, VALUE) - Assign a structural  
%   release to boundary point regions.
p = inputParser();
addParameter(p,'Line',[]);
addParameter(p,'Type', []);
addParameter(p,'Location', 'start');
parse(p,varargin{:});

args = varargin;

try 
     rc = structuralRelease(m,args{:});
catch ME
     throw(ME);
end