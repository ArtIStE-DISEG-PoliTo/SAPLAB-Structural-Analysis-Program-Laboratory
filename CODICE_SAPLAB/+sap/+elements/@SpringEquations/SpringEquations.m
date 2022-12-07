classdef (Sealed=true) SpringEquations
    %SPRINGEQUATIONS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties 
        %NumEquations - number of degree of freedom in the system.
        %   NumEquation property identifies the number of degree of freedom
        %   of the spring.
        NumEquations;
    end
    
    methods
        function self = SpringEquations(numEqns)
            validateattributes(numEqns,{'numeric'},...
                {'scalar','integer','positive'});            
            self.NumEquations = numEqns;            
        end

        function self = set.NumEquations(self, numEqns)
            validsize = 1;
            if ~(ismember(numEqns,validsize))
                error(['Invalid number of equations. Spring stiffness only' ...
                       ' supports a number of equation equals to one ']);
            end
            self.NumEquations = numEqns;
        end

    end

    methods (Access = public)
        
        function k = formNumericSpringMatrix(~, coef)
            %form linear-numeric stiffness spring matrix. Linear stiffness
            %   matrix is described by a numeric scalar specifiend in userK
            %   variable.
            isNumericInput = isnumeric(coef);
            if ~isNumericInput
                k = [];
                return
            end
            k = [coef -coef; -coef coef];
        end
        
        function k = formNonLinearSpringMatrix(~, coef)
            %form non linear stiffness matrix function. Non linear
            %   stiffness spring matrix function depends on solution data.
            %   Solution is a place-holder struct with the following field
            %   names: u, F. 
            coefs=repmat([1 -1;-1 1],1,1,numel(coef));
            coef=reshape(coef,1,1,numel(coef));
            k=pagemtimes(coef,coefs);
        end


    end

end

