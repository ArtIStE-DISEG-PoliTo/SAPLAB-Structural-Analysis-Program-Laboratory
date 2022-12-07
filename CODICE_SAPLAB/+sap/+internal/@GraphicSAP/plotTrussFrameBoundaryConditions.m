function plotTrussFrameBoundaryConditions(self, varargin)

ax=varargin{1};
bc=varargin{2};
cl=varargin{3};

bcData=bc.readConstraintDataForPlot();
for i = 1:size(bcData,1)
    fun = strcat('sap.GraphicModel.',bcData{i,1});
    loc = [bcData{i,2} 0.75*self.Canvas.BoundingBox];
    feval(fun,loc,'parent',ax,'color',cl)
end

end