classdef (Sealed) FrameEquations
    %FRAMEEQUATIONS Summary of this class goes here
    %   Detailed explanation goes here

    properties (Access='private')
        %NumEquations - number of degree of freedom in the system.
        NumEquations;
    end

    methods
        function self = FrameEquations(numEqns)
            validateattributes(numEqns,{'numeric'},...
                {'scalar','integer','positive'});            
            self.NumEquations = numEqns;
        end

        function self = set.NumEquations(self, numEqns)
            validsize = [3 6];
            if ~(ismember(numEqns,validsize))
                error(['Invalid number of equations. Frame element supports ' ...
                       'only 3 or 6 number of equations.']);
            end
            self.NumEquations = numEqns;
        end

        function c = formulateMaterialCoefficients(self,E,nu,le)
            
            if ~isnumeric(E)
                c = E;
                return
            end

            if self.NumEquations == 3
                coefs(1,[1,4])=[1 -1]/le;
                coefs(2,[2,3,5,6]) = [12/le 6 -12/le 6]/le^2;
                coefs(3,[2,3,5,6]) = [6/le 4 -6/le 2]/le;
                coefs(4,:) = -coefs(1,:);
                coefs(5,:) = -coefs(2,:);
                coefs(6,[2,3,5,6]) = [6/le 2 -6/le 4]/le;              
            else
                coefs(1,[1,7])=[1 -1]/le;
                coefs(2,[2,6,8,12]) = [12/le 6 -12/le 6]/le^2;
                coefs(3,[3,5,9,11]) = [12/le -6 -12/le -6]/le^2;
                coefs(4,[4,10]) = coefs(1,[1,7]);
                coefs(5,[3,5,9,11]) = [-6/le 4 6/le 2]/le;
                coefs(6,[2,6,8,12]) = [6/le 4 -6/le 2]/le;    
                coefs(7,:) = -coefs(1,:);
                coefs(8,:) = -coefs(2,:);
                coefs(9,:) = -coefs(3,:);
                coefs(10,:) = -coefs(4,:);
                coefs(11,[3,5,9,11]) = [-6/le 2 6/le 4]/le;
                coefs(12,[2,6,8,12]) = [6/le 2 -6/le 4]/le;    
            end
            
            c = repmat(E,1,2*self.NumEquations);
            if self.NumEquations > 3
                G = E/(2*(1+nu));
                c([4,10])=G;           
            end
            c = c.*coefs;
        end

        function c = formulateSectionCoefficients(self, A, I, Jxx)
            if isempty(I)
                error('Unable to calculate frame stiffness matrix. Missing intertia section properties data.')
            end
            if self.NumEquations == 3
                Iyy = I(1);
                c = [A Iyy Iyy];
                c = repmat(c,1,2);                
            else
                Iyy = I(1);
                Izz = I(2);
                c = [A Izz Iyy Jxx Iyy Izz];
                c = repmat(c,1,2);
            end
        end

        function f = formulateForce(self,fstruct,le,R)
            if ~fstruct.isnumeric
                fstruct=sap.DistributedLoadsRecords.reshapefstruct(fstruct);
                if self.NumEquations==3
                    f(1,:)=fstruct.qx*le/2;
                    f(2,:)=fstruct.qy*le/2;
                    f(3,:)=fstruct.qy*le^2/12;
                    f(4,:)=fstruct.qx*le/2;
                    f(5,:)=fstruct.qy*le/2;
                    f(6,:)=-fstruct.qy*le^2/12;      
                    f=f(:);
                else
                    f(1,:)=fstruct.qx*le/2;
                    f(2,:)=fstruct.qy*le/2;
                    f(3,:)=fstruct.qz*le/2;
                    f(4,:)=fstruct.mx*le/2;
                    f(5,:)=-fstruct.qz*le/2;
                    f(6,:)=fstruct.qy*le^2/12;      
                    f(7,:)=fstruct.qx*le/2;
                    f(8,:)=fstruct.qy*le/2;
                    f(9,:)=fstruct.qz*le/2;
                    f(10,:)=fstruct.mx*le/2;
                    f(11,:)=fstruct.qz*le/2;
                    f(12,:)=-fstruct.qy*le^2/12;                     
                    f=f(:);
                end

            else
                fstruct=sap.DistributedLoadsRecords.addzerovalue(fstruct);
                if self.NumEquations == 3
                    f = R'*[fstruct.qx;fstruct.qy;fstruct.qy*le/6;fstruct.qx;fstruct.qy;-fstruct.qy*le/6]*le/2;
                else
                    f = R'*[fstruct.qx;fstruct.qy;fstruct.qz;fstruct.mx;-fstruct.qz*le/6;fstruct.qy*le/6; ...
                         fstruct.qx;fstruct.qy;fstruct.qz;fstruct.mx;fstruct.qz*le/6;-fstruct.qy*le/6]*le/2;                 
                end
            end
        end

        function f = formulateGravityLoads(self,m,g,a,le)

            if isempty(m) || isempty(a) || isempty(g)
                f = zeros(2*self.NumEquations,1);
                return
            end
            mg = m*g*a;
            fv = mg/2;
            fm = mg*le/6;
            f = zeros(2*self.NumEquations,1);
            f([2,self.NumEquations+2]) = fv;
            f([self.NumEquations,self.NumEquations*2]) = [fm -fm];
            f = f*le;
        end

        function t = formulateThermalLoads(self,a,i,E,cte,tval,tref)
            t= zeros(2*self.NumEquations,1);
            if isempty(a) || isempty(i) || isempty(E) || isempty(cte) || isempty(t) 
                return
            end
            tm = mean([tval,tref]);
            dt = diff([tval,tref]);            
            t([1,self.NumEquations+1],:)= [-cte*E*a*tm cte*E*a*tm];
            if self.NumEquations >=3
                i = i(1);
                if self.NumEquations == 6
                    i = i(2);
                end
                t([self.NumEquations,2*self.NumEquations],:) = [2*cte*dt*E*i -2*cte*dt*E*i];
            end 
        end

        function N = shapeFunc(self, s, L)
            N = zeros(self.NumEquations,6,numel(L)); % N is a NumEqnsx6 matrix.
            N1  = 1-s;             dN1 = 1-s;
            N2  = s;               dN2 = s;
            N3  = 1-3*s^2+2*s^3;   dN3 = -(6/L)*(s-s^2); 
            N4  = 3*s^2-2*s^3;     dN4 = (6/L)*(s-s^2);
            N5  = L*(s-2*s^2+s^3); dN5 = 1-4*s+3*s^2;
            N6  = L*(-s^2+s^3);    dN6 = -2*s+3*s^2;   

            if self.NumEquations == 3
            N(1,1) = N1;   N(1,4) =  N2;
            N(2,2) = N3;   N(2,3) =  N5;
            N(2,5) = N4;   N(2,6) =  N6;
            N(3,2) = -dN3; N(3,3) = dN5;
            N(3,5) = -dN4; N(3,6) = dN6; 
            else
            N(1,1) = N1;   N(1,7) =  N2;
            N(2,2) = N3;   N(2,6) =  N5;
            N(2,8) = N4;   N(2,12) =  N6;
            N(3,3) = N3;   N(3,5) = -N5;
            N(3,9) = N4;   N(3,11) = -N6;
            N(4,4) = dN1;  N(4,10) = dN2;
            N(5,3) = dN3;  N(5,5) = dN5;
            N(5,9) = dN4;  N(5,11) = dN6;
            N(6,2) = -dN3; N(6,6) = dN5;
            N(6,8) = -dN4; N(6,12) = dN6;       
            end
        end

        function N = d2shapeFunc(self, s, L)
            N1  = 0;                 dN1  = 0;
            N2  = 0;                 dN2  = 0;
            N3  = -(6/L^2)*(1-2*s);  dN3  = 12/L^3;
            N4  = (6/L^2)*(1-2*s);   dN4  = -12/L^3;
            N5  = (1/L)*(-4+6*s);    dN5  = 6/L^2;
            N6  = (1/L)*(-2+6*s);    dN6  = 6/L^2;       
            if self.NumEquations == 3
            N(1,1) = N1;   N(1,4) =  N2;
            N(2,2) = N3;   N(2,3) =  N5;
            N(2,5) = N4;   N(2,6) =  N6;
            N(3,2) = -dN3; N(3,3) = dN5;
            N(3,5) = -dN4; N(3,6) = dN6;   
            else
            N(1,1) = N1;   N(1,7) =  N2;
            N(2,2) = N3;   N(2,6) =  N5;
            N(2,8) = N4;   N(2,12) =  N6;
            N(3,3) = N3;   N(3,5) = -N5;
            N(3,9) = N4;   N(3,11) = -N6;
            N(4,4) = dN1;  N(4,10) = dN2;
            N(5,3) = dN3;  N(5,5) = dN5;
            N(5,9) = dN4;  N(5,11) = dN6;
            N(6,2) = -dN3; N(6,6) = dN5;
            N(6,8) = -dN4; N(6,12) = dN6;     
            end
        end

        function N = d3shapeFunc(self, L)
            N1  = 0;       dN1  = 0;
            N2  = 0;       dN2  = 0;
            N3  = 12/L^3;  dN3  = 0;
            N4  = -12/L^3; dN4  = 0;
            N5  = 6/L^2;   dN5  = 0;
            N6  = 6/L^2;   dN6  = 0; 
            if self.NumEquations == 3
            N(1,1) = N1;   N(1,4) =  N2;
            N(2,2) = N3;   N(2,3) =  N5;
            N(2,5) = N4;   N(2,6) =  N6;
            N(3,2) = -dN3; N(3,3) = dN5;
            N(3,5) = -dN4; N(3,6) = dN6;   
            else
            N(1,1) = N1;   N(1,7) =  N2;
            N(2,2) = N3;   N(2,6) =  N5;
            N(2,8) = N4;   N(2,12) =  N6;
            N(3,3) = N3;   N(3,5) = -N5;
            N(3,9) = N4;   N(3,11) = -N6;
            N(4,4) = dN1;  N(4,10) = dN2;
            N(5,3) = dN3;  N(5,5) = dN5;
            N(5,9) = dN4;  N(5,11) = dN6;
            N(6,2) = -dN3; N(6,6) = dN5;
            N(6,8) = -dN4; N(6,12) = dN6;     
            end        
        end
    end

    properties
        ParentModel;
    end
end