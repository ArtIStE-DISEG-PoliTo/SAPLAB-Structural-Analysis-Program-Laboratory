function gm = csgdef(self, tag)
%IMPORT2DGEOMETRY() - This function import the geometry specified in TAG
%   string into the model plane geometry.

if self.Dim==1
    error('Model does not support 2D geometry.')
end
if isempty(tag)
    return;
end

try
    gm = self.Geometry.import(tag);
catch ME
    throwAsCaller(ME);
end

end