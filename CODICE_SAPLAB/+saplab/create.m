function femodel = create(varargin)

if nargin > 0
    [varargin{:}] = convertStringsToChars(varargin{:});
end

parser = inputParser(); %parse the function input arguments scheme
parser.addParameter('Attributes',  [], @(x) ischar(x) || isstring(x) || isempty(x));
parser.parse( varargin{:} );

narginchk(0,2);
nargoutchk(1,1);

%check if toolboxes are installed
pdeTool = sap.isToolBoxInstalled('Partial Differential Equation Toolbox');
symTool = sap.isToolBoxInstalled('Symbolic Math Toolbox');

if ~pdeTool && symTool
    try
        error(['"Partial Differential Equation Toolbox" is not installed in MATLAB. ' ...
               'Please install ToolBox before using ' App ' Application.']);
    catch ME
        throwAsCaller(ME);
    end
end
if pdeTool && ~symTool
    try
        error(['"Symbolic Math Toolbox" is not installed in MATLAB. ' ...
               'Please install ToolBox before using ' App ' Application.']);
    catch ME
        throwAsCaller(ME);
    end
end
if ~pdeTool && ~symTool
    try
        error(['"Partial Differential Equation Toolbox" and "Symbolic Math Toolbox" is not installed in MATLAB. ' ...
               'Please install ToolBox before using ' App ' Application.']);
    catch ME
        throwAsCaller(ME);
    end
end
if ~isempty(varargin)
argsToPass = varargin{2:2:end};
else
argsToPass = 'static-planeframe';
end
femodel = sap.StructuralModel(argsToPass);

end