classdef Canvas < handle
    %CANVAS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Figure matlab.ui.Figure;
        Axes 
    end
    
    methods
        function obj = Canvas()
            %CANVAS Construct an instance of this class
            %   Detailed explanation goes here
            obj.Figure = figure('Name','SAPLAB Canvas','WindowStyle','normal','Color','w','NumberTitle','off');
            obj.Axes = axes(obj.Figure);
        end
        
        function outputArg = method1(obj,inputArg)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            outputArg = obj.Property1 + inputArg;
        end
    end
end

