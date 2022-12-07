classdef (Abstract=true) Geometry < matlab.mixin.CustomDisplay & dynamicprops
    %sap.GeometricModel - An abstract class for variuos geometric
    %   description of the domain
    
    methods (Access ={?sap.Geometry, ?sap.StructuralModel})
        function self = Geometry(M) %class constructor
            if isempty(M.Geometry)
                M.Geometry = self;
            else
                self = M.Geometry;
            end
            self.SysDim = M.FEMSystemSize;
            self.ElasType = M.ElasticityType;
            self.ParentModel = M;
        end
    end

    properties (Hidden = true, SetAccess = {?sap.Geometry, ?sap.FEModel, ?sap.GeometricModel2D}, GetAccess = public)
        SysDim; ElasType; ParentModel;
    end

end