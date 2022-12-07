function rei = structuralREI(m,varargin)
%STRUCTURALREI generate a structural reinforcement
%   Detailed explanation goes here

p = inputParser();
addParameter(p, 'Edge', []);
addParameter(p, 'Thickness', []);
parse(p, varargin{:});

args = varargin;

try 
    rei = m.structuralREI(args{:});
catch ME
    error(ME.message)

end