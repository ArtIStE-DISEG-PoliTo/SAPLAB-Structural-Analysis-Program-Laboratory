function dl = findDistrLoad(dloads, varargin)
%FINDDISTRLOAD Find distributed loads in m.DistributedLoad object.

p = inputParser();
addParameter(p, 'Line', []);
parse(p, varargin{:});

try
    args = varargin;
    dl = findDistributedLoads(dloads, args{:});
catch ME
    error(ME.message)
end