function dl = applyDistributed(m, varargin)
%bdl = applyDistributed(STRUCTURALMODEL, NAME, VALUE) - Applies 
%   distributed load to a structural model. Distributed load acts on the entire 
%   length of the material.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%         Apply Structural Distributed Load to Structural Model             %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

parser=inputParser();
addParameter(parser, 'Line',   []);
addParameter(parser, 'Force', []);
addParameter(parser, 'Moment',[]);
addParameter(parser, 'XForce', []);
addParameter(parser, 'YForce', []);
addParameter(parser, 'ZForce', []);
addParameter(parser, 'XMoment', []);
addParameter(parser, 'YMoment', []);
addParameter(parser, 'ZMoment', []);   
parser.parse(varargin{:});

if ~isprop(m, 'DistributedLoads')
    error(['Distributed loads are not supported in ' char(m.AnalysisType) ' analysis.']);
end

%parse scheme input
args = parseInputScheme(parser.Results);
nRegion = parser.Results.Line;

dl = cell(numel(nRegion),1);
try
    for i=1:numel(nRegion)
         dl{i} = structuralDistributedLoad(m,'Line', nRegion(i), 'LoadType', 'Constant', args{:});
    end
catch ME
    throw(ME)
end

if isscalar(nRegion)
     dl = dl{1};
end

end

function args = parseInputScheme(pr)
    args = [];
    if ~isempty(pr.XForce)
        args = {'XForce', pr.XForce};
    end
    if ~isempty(pr.YForce)
        args = [args {'YForce', pr.YForce}];
    end    
    if ~isempty(pr.ZForce)
        args = [args {'ZForce', pr.ZForce}];
    end  
    if ~isempty(pr.XMoment)
        args = [args {'XMoment', pr.XMoment}];
    end  
    if ~isempty(pr.YMoment)
        args = [args {'YMoment', pr.YMoment}];
    end       
    if ~isempty(pr.ZMoment)
        args = [args {'ZMoment', pr.ZMoment}];
    end 
    if ~isempty(pr.Force)
        args = {'Force', pr.Force};
    end
    if ~isempty(pr.Moment)
        args = {'Moment', pr.Moment};
    end

end