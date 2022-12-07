function trimLine(m, varargin)
%SPLITLINE - Split line in segments
p = inputParser();
p.addParameter('Line',[],@(x) size(x,2)==2 && isnumeric(x))
p.parse(varargin{:});

if ~isa(m,'sap.FEModel')
    error('Invalid structural model object.');
end

if isempty(m.Geometry)
    error('Model with empty geometry!')
end

queries = p.Results.Line;
nQueries = size(queries,1);

if any(queries(:,1)>m.Geometry.('NumLines'))
    error('Some of the Line(s) ID(s) exceeds the number of line in the goemetry.');
end

if any(~isrounded(queries(:,1))) || any(queries(:,1) < 0)
    error('Some of the Line(s) ID(s) is invalid.')
end

try
    for i=1:nQueries
        ndiv = queries(i,2);
        if ~isrounded(ndiv) || ndiv<=1
            error('Number of division must be rounded and positive');
        end
        trimLine(m.Geometry, queries(i,1), queries(i,2));
    end
catch ME
    throwAsCaller(ME);
end

end