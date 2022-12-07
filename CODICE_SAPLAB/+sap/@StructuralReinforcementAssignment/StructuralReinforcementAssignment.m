classdef StructuralReinforcementAssignment < handle & matlab.mixin.CustomDisplay
    %STRUCTURALREINFORCEMENTASSIGNMENT Summary of this class goes here
    %   Detailed explanation goes here

    properties (Constant)
        %RegionType - Type of geometric region to which the Structural 
        %   Reinforcement are assigned.
        %   The type of geometric region specified as 'Edge'.        
        RegionType = 'Edge';
    end

    properties
        % RegionID - IDs of the geometric regions to which the Structural
        %       Reinforcement are assigned
        %  RegionID cannot exceed the number of edge for a 2-D geometry.        
        RegionID;
        %ReinforcementID - IDs of the reinforcement
        %This property is read only.
        %Thickness - Thickness of the structural reinforcement. A numeric
        %   scalar representing the thickness of the structural
        %   reinforcement section.
        Thickness;
    end

    properties(Access={?sap.StructuralReinforcementRecords, ?sap.elements.TrussEquations})
        %Type - Define the edge geometric shape. 
        %   Edge shape can be 'Line','Circle', or 'Ellipse'.  
        Type='line';
    end

    methods
        function self = StructuralReinforcementAssignment(srrec, varargin)
            
            p = inputParser();
            addParameter(p, 'Edge', []);
            addParameter(p, 'Thickness',[]);
            parse(p,varargin{:});

            self.RecordsOwner = srrec;
            self.RegionID = p.Results.Edge;
            self.Thickness = p.Results.Thickness;
            
            isAttachedtoInternalEdge(self);

        end
        
        function set.RegionID(self, rid)
            maxRegions = self.RecordsOwner.nRegions; %#ok
            if rid > maxRegions
                error('The RegionID must not exceed the number of the edges in the geometry.')
            end
            if ~isnumeric(rid)
                error('Input must be numeric');
            end
            self.RegionID = rid;
        end

        function set.Thickness(self, t)
            if ~isnumeric(t) || t<=0 || ~isscalar(t) 
                error('Invalid structural reinforcement thickness value.');
            end
            if isempty(t)
                error('Structural reinforcement thickness value must be non empty.')
            end
            self.Thickness = t;
        end
    end

    properties (Hidden, Access = 'private')
        %ParentModel storage.
        RecordsOwner;
    end

    methods (Hidden,Access='private')
        function Type=borderType(self)
           geom = self.RecordsOwner.ParentModel.Geometry.geom;
           thisEdge = geom(:,edgeID);
           if thisEdge(1)==1
               Type='circle';
           elseif thisEdge(1)==2
               Type='line';
           elseif thisEdge(1)==4
               Type='ellipse';
           end
        end

        function isAttachedtoInternalEdge(self)
            edgeID = self.RegionID;
            geom = self.RecordsOwner.ParentModel.Geometry.geom;
            thisEdge = geom(:,edgeID);
            
            self.isInternal = false;
            if ~thisEdge(6) == 0 && ~thisEdge(7) == 0
                self.isInternal = true;
            end
        end
    end

    properties (Hidden)
        %isInternal - A true/false flag. If value is true then the
        %   reinforcement is attached on an internal edge of the region. 
        isInternal;
    end
end