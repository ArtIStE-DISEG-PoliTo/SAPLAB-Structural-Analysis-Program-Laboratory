function mm = defineMatModel(varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%          Define Stress Strain Curve Properties               %%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Generate Non Linar Material Properties Object. This function generate a 
%   NonLinearMaterialProperties object which define the stress/strain
%   curve for non linear analysis purpose.

narginchk(4,4); nargoutchk(1,1);


p=inputParser();
p.addParameter('Force',[]);
p.addParameter('u',[]);
p.parse(varargin{:});

Force = p.Results.Force;
uu = p.Results.u;

mm = sap.NonLinearMaterialProperties("force",Force,"displacement",uu);

end