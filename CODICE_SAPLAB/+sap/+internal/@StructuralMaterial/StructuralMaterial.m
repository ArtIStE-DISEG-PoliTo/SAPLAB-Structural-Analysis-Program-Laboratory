classdef (Abstract) StructuralMaterial < handle
    %fem.internal.StructuralMaterial - An abstract class for structural
    %   material definition. A structural material is an object which stores
    %   structural material properties in terms of Modulus of Elasticity,
    %   Poissons Ratio, Mass Density, Coefficient of thermal expansion e
    %   materials costitutive model data.

    properties (SetAccess='private')
        %MaterialType - String scalar or character vector defining the
        %   material type. MaterialType = {'Concrete','Steel','User'}
        MaterialType; 
        %MaterialTag - String scalar or character vector defining the
        %   material tag. Material tag identify a material object in the
        %   model library.
        MaterialTag;         
    end

    properties (SetObservable = true, SetAccess = 'private')
        %YoungsModulus - Young's modulus of the material
        % A numeric scalar representing the Young's modulus or elastic
        % modulus of an isotropic material.
        YoungsModulus;
    
        %PoissonsRatio - Poisson's ratio of the material
        % A numeric scalar representing the Poisson's ratio of an isotropic
        % material.
        PoissonsRatio;
        
        %MassDensity  - Mass density of the material
        % A numeric scalar representing the mass density of an isotropic
        % material.
        MassDensity;
        
        %CTE - Coefficient of thermal expansion of the material
        % A numeric scalar representing the linear coefficient of thermal
        % expansion of an isotropic material.
        CTE;

    end

    properties (Hidden)

        %MultipointCurveData - Vector which stores the material
        %   stress/strain curve points data. The first and the second
        %   rows store the x and y data of the multipoint curve, the third
        %   and the fourth rows stores the tangent/shear modulus values.
        %   Stress/Strain curve can also be stored in a function_handle
        %   format.
        ConstitutiveModelData;
    end

    methods
        function self = StructuralMaterial(mtc, varargin)
            %fem.internal.StructuralMaterial - Class constructor
            
            narginchk(1,7);
            
            E = varargin{1};
            nu = varargin{2};
            md = varargin{3};
            cte = varargin{4};
            G = varargin{5};
            mcd = varargin{6};

            if (nargin==1)
                return;
            end 
                
            mtc = validateMtc(self, mtc);
            
            %generate properties vector
            validateCoeffE(self,  E); 
            validateCoeffnu(self, nu); 
            validateCoeffmd(self, md);
            validateCoeffcte(self, cte);
            validateCoeffE(self,  G);

            
            self.MaterialType = mtc;
            self.YoungsModulus = E;
            self.PoissonsRatio = nu;
            self.MassDensity = md;
            self.CTE = cte;
            if isempty(mcd)
                return;
            end

            self.ConstitutiveModelData = mcd;
        end

        function mtc = validateMtc(~, mtc)
            validstrings= ["Concrete", "Steel", "User Material"];
            validatestring(mtc, validstrings);
        end

        function coeff = validateCoeffE(~, coeff)
            %validate YoungsModulus
            if isa(coeff, 'function_handle')
                return
            end
            if ~isnumeric(coeff) && ~isscalar(coeff)
                error('Modulus of elasticity must be a positive numeric scalar!');
            else
                mustBeNonempty(coeff);
                mustBePositive(coeff);                
            end
        end

        function coeff = validateCoeffnu(~, coeff)
            %Validate PoissonsRatio
            if isempty(coeff)
                coeff = 0;
            end
            if ~isnumeric(coeff) && ~isscalar(coeff)
                error('Poisson''s ratio must be a numeric scalar!');
            else
                mustBeInRange(coeff, 0, +.5, "inclusive");
            end
            
        end

        function coeff = validateCoeffmd(~, coeff)
            %validate mass density
            if isempty(coeff)
                coeff = 0;
            end
            if ~isnumeric(coeff) && ~isscalar(coeff)
                error('Mass density must be a positive numeric scalar!');
            else            
            mustBeInRange(coeff, 0, +Inf, "exclude-upper");
            end
        end

        function coeff = validateCoeffcte(~, coeff)
            %validate coefficient of thermal expansion
            if isempty(coeff)
                coeff = 0;
            end
            if ~isnumeric(coeff) && ~isscalar(coeff)
                error('Coefficient of thermal expansion must be a positive numeric scalar!');
            else                     
            mustBeInRange(coeff, 0, +Inf, "exclude-upper");
            end
        end

        function setMaterialTag(self, mtag)
            if ischar(mtag) || isstring(mtag)
                self.MaterialTag = mtag;
            end
        end
    end
end