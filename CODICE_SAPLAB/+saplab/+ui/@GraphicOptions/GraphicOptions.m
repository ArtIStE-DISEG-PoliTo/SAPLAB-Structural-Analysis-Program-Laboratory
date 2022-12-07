classdef GraphicOptions < handle

    properties
        ModelToPlot;
        PlotOpt;
        Appearance;
        Canvas;
        LinkedCanvasPoints;
        CanvasChildrenTags;
    end

    properties (Hidden)
       Dim;
    end

    methods
        function obj = GraphicOptions(app)
            if isa(app, 'saplab.ui.Dashboard'), M=app.MODEL;dim=M.Dim; end
            if isa(app, 'sap.StructuralModel'), M = app;dim=M.Dim; end
            obj.ModelToPlot = M;
            %Set the canvas dim
            obj.Dim = dim;
            % set the graphics
            if isempty(M.Graphics)
                obj.AppearanceOpt();
                M.Graphics = obj;
            else
                obj = M.Graphics;
            end
        end

        %methods declaration
        plotAxisTriad(self, varargin);
        plotModel(self, M);
        plot1DElementGeometry(~, g, varargin);

        function AppearanceOpt(obj)

            %set default appearance options
            app.LineColor    = [0,0,1];
            app.PointColor   = [0,0,1];
            app.ReleaseColor = [0,1,0];
            app.EdgeColor    = [0,0,1];
            app.NotImportedEdgeColor = [.35 .35 .35];
            app.NotImportedVertexColor = [.35 .35 .35];
            app.VertexColor  = [1,0,0];
            app.AxisTriad    = [0,0,0;0,0,0;0,0,0];
            app.BackgroundColor  = [1 1 1];
            app.LineLabelColor   = 'r';
            app.PointLabelColor  = 'k';            
            app.EdgeLabelColor   = 'k';          
            app.VertexLabelColor = 'k';
            app.FaceLabelColor   = 'r';
            app.ConstraintColor  = [0,0.7,0.7];
            app.UndeformedShapeColor = [0 0 0];
            app.DeformedShapeColor = [0,0,0];
            app.DiagramBorderColor = [0 0 0];
            app.DiagramFillColor = [.9 .0 .1];
            app.GenericTextColor = 'k';
            app.ReinforcementColor = [0 0.4 0];
            app.LineWidth=1.5;
            app.LineStyle='-';
            app.MarkerSize=2.75;        
            app.AxisVisibility = 'off';
            app.FontName = 'Segoe UI';
            app.ForceColor   = 'r';
            obj.Appearance = app;
        end

    end
end

