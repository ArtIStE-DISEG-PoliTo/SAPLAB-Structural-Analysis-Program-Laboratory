classdef TrussEquations
    %TRUSSEQUATIONS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Access='private')
        %NumEquation - number of degree of freedom in the system.
        NumEquations;
    end
    
    methods
        function obj = TrussEquations(numEqns)
            validateattributes(numEqns,{'numeric'},...
                {'scalar','integer','positive'});
            obj.NumEquations = numEqns;
        end
 
        function self = set.NumEquations(self, numEqns)
            validsize = [2 3];
            if ~(ismember(numEqns,validsize))
                error(['Invalid number of equations. Truss element supports ' ...
                       'only 2 or 3 number of equations.']);
            end
            self.NumEquations = numEqns;
        end

        function c = formulateMaterialCoefficients(~,varargin)
            if isempty(varargin)
                c = [];
                return
            end
            
            if nargin == 3
                E = varargin{1};
                le = varargin{2};
                c = E/le;
            else
                E = varargin{1};
                t = varargin{2};
                le = varargin{3};
                c = E*t./le;
            end
        end

        function K=formKMatricesForBarReinforcement(~,c,x,y,l)
            c=c';
            cost=(x(:,2)-x(:,1))./l';
            sint=(y(:,2)-y(:,1))./l';          
            n_bar=1:numel(cost);
            K=zeros(4,4,numel(cost));
            K(1,1,n_bar)=c.*cost.^2;
            K(1,2,n_bar)=c.*cost.*sint;
            K(1,3,n_bar)=-K(1,1,n_bar); %-cost^2
            K(1,4,n_bar)=-K(1,2,n_bar); %-costsint
            K(2,1,n_bar)=K(1,2,n_bar);
            K(2,2,n_bar)=c.*sint.^2;
            K(2,3,n_bar)=-K(1,2,n_bar);
            K(2,4,n_bar)=-K(2,2,n_bar);
            K(3,:,n_bar)=-K(1,:,n_bar);
            K(4,:,n_bar)=-K(2,:,n_bar);
        end

        function c = formulateSectionCoefficients(~,a)
            c = a;
        end

        function formulateDistributedLoads(self,fstruct,le)
            if isempty(fstruct)
                f = [];
                return
            end
            if self.NumEquations == 2
                f = [fstruct.qx;fstruct.qy;fstruct.qx;fstruct.qy]*le/2;
            else
                f = [fstruct.qx;fstruct.qy;fstruct.qz; ...
                     fstruct.qx;fstruct.qy;fstruct.qz;]*le/2;                 
            end            
        end

        function f = formulateGravityLoads(self,m,g,a,le)
            if isempty(m) || isempty(a) || isempty(g)
                f = [];
                return
            end
            mg = m*g*a;
            fv = mg/2;
            f = zeros(2*self.NumEquations,1);
            f([2,self.NumEquations+2]) = fv;
            f = f*le;
        end     

        function t = formulateThermalLoads(self,a,E,cte,t,tref)
            if isempty(a) || isempty(E) || isempty(cte) || isempty(t) 
                t = [];
                return
            end
            tm = mean([t,tref]);      
            t = zeros(2*self.NumEquations,1);
            t([1,self.NumEquations+1],:)= [-cte*E*a*tm cte*E*a*tm];          
        end

        function N = shapeFunc(s)
            N 
        end

    end
end

