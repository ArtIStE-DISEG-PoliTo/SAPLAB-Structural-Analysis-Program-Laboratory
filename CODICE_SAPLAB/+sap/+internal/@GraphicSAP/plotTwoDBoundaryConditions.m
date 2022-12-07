function plotTwoDBoundaryConditions(self, varargin)

ax=varargin{1};
bc=varargin{2};
cl=varargin{3};

bcData=bc.readConstraintDataForPlot();
for i = 1:size(bcData,1)
    fun = strcat('sap.GraphicModel.',bcData{i,1});
    if isnumeric(bcData{i,2})
        loc = [bcData{i,2} 0 0.75*self.Canvas.BoundingBox];
    else
        loc = {bcData{i,2} 0.75*self.Canvas.BoundingBox};
    end
    feval(fun,loc,'parent',ax,'color',cl)
end

end