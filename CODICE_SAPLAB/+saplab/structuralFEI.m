function fei = structuralFEI(m,varargin)
%bdl = structuralFEI(STRUCTURALMODEL, NAME, VALUE) - Assign a structural  
%   finite element interface to a structural model. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%           Apply Structural FE Interface to Structural Model               %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
parser = inputParser;
addParameter(parser, 'Edge', []);
addParameter(parser, 'HorizontalStiffness', []);
addParameter(parser, 'VerticalStiffness', []);
parse(parser, varargin{:});

narginchk(5,5)

args=varargin;

try 
     fei = m.structuralFEI(args{:});
catch ME
    throw(ME)
end
end
