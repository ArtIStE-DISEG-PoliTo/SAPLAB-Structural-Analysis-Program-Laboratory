classdef (Sealed) GraphicSAP < handle & matlab.mixin.SetGet
%%% sap.internal.VisualizeSAP - Graphic representation of a finite element
%%%     model. 

    properties (SetObservable)
        SAPModelSize;
        Canvas;    
    end

    methods
        function self = GraphicSAP(varargin)
        
        g = varargin{1};
        if isa(g, 'sap.FEModel')
            dim=g.Dim;
            size=g.FEMSystemSize;
        end

        if isa(g,'sap.GeometricModel')
            if g.Dim==1
                dim = g.Dim;
                size = g.isTwoD;
            else
                dim = g.Dim;
                size = 2;
            end
        end

        if isnumeric(g)
            dim=2;
            size=2;
        end

        if isa(g,'struct')
            dim = 2;
            size =2;
        end

        self.SAPModelSize=2;
        if dim==1 && size==6
            self.SAPModelSize=3;
        end

        theme = varargin{2};

        canvas=struct();
        canvas.Axis = [];
        canvas.BoundingBox = [];
        canvas.Appearance = self.defaultColorProperties(dim,theme);
        canvas.XLim = [];
        canvas.YLim = [];
        canvas.ZLim = [];
        self.Canvas = canvas;
        end

        function set_CanvasAxisLimits(self,xlim,ylim,zlim)
        self.Canvas.XLim=xlim;
        self.Canvas.YLim=ylim;
        self.Canvas.ZLim=zlim;
        end

        function bbox=set_CanvasBoundingBox(self,xlim,ylim,zlim)
        %evaluate bounding box
        lim = abs([xlim(1),xlim(2),ylim(1),ylim(2),zlim(1),zlim(2)]); 
        gradients = (max(lim));
        bbox = gradients/15;
        self.Canvas.BoundingBox = bbox;
        end

        function colp=defaultColorProperties(~, dim, theme)
            colp=struct();
            if strcmpi(theme,'white')
                if dim==1
                colp.LineColor=[.9 0.30 0];
                colp.PointColor='r';
                colp.InternalPointColor=colp.LineColor;
                colp.ReleasePointColor='g';
                colp.LineWidth=.8;
                colp.MarkerSize=2.5;
                colp.AxisTriad = .5*eye(3);
                colp.AxisColor = 'w';
                colp.TextColor = 'k';
                elseif dim==2
                colp.EdgeColor='k';
                colp.VertexColor='r';   
                colp.LineWidth=0.5;
                colp.MarkerSize=3;
                colp.AxisTriad= .5*eye(3);
                colp.AxisColor = 'w';
                colp.TextColor = 'k';
                end
                colp.ConstraintColor = [.2 .2 .2];
            elseif strcmpi(theme,'black')
                if dim==1
                colp.LineColor=[0 0.85 .85];
                colp.PointColor='w';
                colp.InternalPointColor=colp.LineColor;
                colp.ReleasePointColor='g';
                colp.LineWidth=.8;
                colp.MarkerSize=2.5;
                colp.AxisTriad = .5*eye(3);
                colp.AxisColor = 'k';
                colp.TextColor = 'w';
                elseif dim==2
                colp.EdgeColor=[0 0.85 .85];
                colp.VertexColor='w';   
                colp.LineWidth=0.5;
                colp.MarkerSize=2.5;
                colp.AxisTriad= .5*eye(3);
                colp.AxisColor = 'k';
                colp.TextColor = 'w';
                end
                colp.ConstraintColor = [1 0.5 0];
            end
            colp.FontName = 'Monospaced';
        end

        %methods declaration
        plotAxisTriad(self, varargin);
        plotTrussFrameGeometryInternal(self, g, varargin);
        plotTwoDGeometryInternal(self, g, varargin);
        plotTrussFrameBoundaryConditions(self, varargin);
        plotTwoDBoundaryConditions(self, varargin);
        h = patchsurf(~, dl,msb,tag);
        
        function set.SAPModelSize(self, coef)
        if isnumeric(coef) && isscalar(coef)
            self.SAPModelSize=coef;
        end
        end

        function set.Canvas(self, canvas)
        mustBeA(canvas, 'struct');
        self.Canvas=canvas;
        end
    end

    properties (Hidden)
        CanvasObjectTags;
        CanvasLinkedPoints;
    end

    methods (Static=true)
        %methods declaration.
        pinned2(location,varargin);     
        pinned3(location,varargin)
        fixed2(location,varargin);     
        fixed3(location,varargin);
        rollerx2(location,varargin);
        rollery2(location,varargin);
        rollerx3(location,varargin);
        rollery3(location,varargin);
        rollerxy3(location,varargin);
        rolleryz3(location,varargin);
        rollerxz3(location,varargin);
        pinned22(location,varargin);
        rollerx22(location,varargin);
        rollery22(location,varargin);
    end

    properties (Hidden)
        isOpenedInGui;
    end
end