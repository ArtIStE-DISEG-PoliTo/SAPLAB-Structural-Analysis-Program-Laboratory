classdef (Abstract) StructuralSection < handle & dynamicprops
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (SetObservable)
        Class;
        NameID;
        Area;
        Perimeter;
        Centroid;
        Iyy; %Second moment of area about y axis
        Izz; %Second moment of area about z axis;
        Iyz; %Product moment of area;
        Jxx; %Torsional Constant;
        I11; %Principal moment of inertia about 1 axis;
        I22; %Principal moment of inertia about 2 axis;
        Orientation;

    end
    
    methods ( Access = public )
        function self = StructuralSection(area, iyy, izz, iyz, jxx, i11, i22, theta)
            arguments
                area (1,1) double; %cross - sectional area
                iyy  (1,1) double; %Second moment of area about z axis;
                izz  (1,1) double; %Second moment of area about z axis;
                iyz  (1,1) double; %Product moment of area;
                jxx  (1,1) double; %Torsional Constant;
                i11  (1,1) double; %Principal moment of inertia about 1 axis;
                i22  (1,1) double; %Principal moment of inertia about 2 axis;
                theta  (1,2) double; %orientation parameters
            end
            mustBePositive(area);
            mustBeInRange(iyy, 0, +inf);
            mustBeInRange(izz, 0, +inf);
            mustBeInRange(jxx, 0, +inf);
            self.Area = area;
            self.Iyy = iyy;
            self.Izz = izz;
            self.Iyz = iyz;
            self.Jxx = jxx;
            self.I11 = i11;
            self.I22 = i22;
            self.Orientation = theta;
        end
        
    end
end

