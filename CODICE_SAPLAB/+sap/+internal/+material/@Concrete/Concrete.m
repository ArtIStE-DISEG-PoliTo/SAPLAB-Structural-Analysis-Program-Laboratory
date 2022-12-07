classdef Concrete < handle & sap.internal.StructuralMaterial
    %sap.internal.material.Concrete - A class for creating concrete
    %   material.

    properties (Hidden = true, SetAccess = 'private')
        %CompressiveStrenght - A numeric scalar which represents the
        %compressive strenght of the concrete material.
        CompressiveStreght;

        %TensileStrenght - A numeric scalar which represents the
        %tensile strenght of the concrete material. 
        TensileStrenght;
    end

    methods (Access = 'public')
        function self = Concrete(varargin)
            %sap.internal.material.Concrete - Class constructor
            narginchk(1,3);
            
            fcc=varargin{1};
            fct=varargin{2};
            mcd=varargin{3};

            fcc=sap.internal.validateCoeffcs([], fcc);
            fct=sap.internal.validateCoeffts([], fct, fcc);

            [E, nu, md, ceoffTerm] = sap.internal.evaldefclsProperties([], fcc);
            
            G = E/(2*(1+nu));
            mcData = [];
            if ~isempty(mcd)
                if ~isa(mcd, 'sap.ConstitutiveModelAssignment')
                    error('Invalid costitutive model object.')
                end
                if contains(mcd.CurveType, 'multi')
                    x = mcd.XData';
                    y = mcd.YData';
                    kt =  mcd.evaluateTangentModulus(x,y);
                    gt = kt/(2*(1+nu));
                    E  = mcd.evalYoungsModulus(x,y);
                    G = E/(2*(1+nu));
                    mcData = [x;y;[kt kt(end)];[gt gt(end)]];
                else
                    E = mcd.evalTangentModulusFcn(mcd.Function);
                    G = E;
                    mcData = mcd.Function;
                end
            end
            
            self@sap.internal.StructuralMaterial('concrete', E, nu, md, ceoffTerm, G, mcData);
            
            self.CompressiveStreght = fcc;
            self.TensileStrenght = fct;
        end

        function coeff=validateCoeffcs(~, coeff)
            %validate compressive strenght value
            if ~isnumeric(coeff) && ~isscalar(coeff)
                error('Compressive strenght must be a positive numeric scalar!');
            else
                mustBeNonEmpty(coeff);
                mustBePositive(coeff);                
            end
        end

        function coeff=validateCoeffts(~, coeff, cs)
            %validate tensile strenght value
            narginchk(2,3);
            if isempty(coeff)
                coeff=0;
            end
            if ~isnumeric(coeff) && ~isscalar(coeff)
                error('Tensile strenght must be a positive numeric scalar!');
            else
                mustBeInRange(0,cs/10);
            end            
        end

        function [E, nu, md, ceoffTerm] = evaldefclsProperties(~, fcc)
            E = 22000*(.1*(fcc+8))^.3;
            nu = .2;
            md = 25;
            ceoffTerm = 1.2E-5;
        end
    end
end