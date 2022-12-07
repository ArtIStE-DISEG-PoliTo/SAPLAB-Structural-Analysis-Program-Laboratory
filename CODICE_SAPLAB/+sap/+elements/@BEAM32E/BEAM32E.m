classdef BEAM32E < handle

    methods
        function self = BEAM32E()
            %Empty class constructor
        end
    end

    methods (Static=true,Access={?sap.MaterialPropertiesRecords,?sap.SectionPropertiesRecords})
        %Methods access is only permitted to MaterialPropertiesRecords and
        %SectionPropertiesRecords in order to compute the element stiffness

        function coefs=formulateMaterialCoefficients(Le,E,~)
            %formulateMaterialCoefficients() - Formulate the material
            %   coefficients into BEAM23E stiffness matrix.
            coefs(1,[1,4])=[1 -1]/Le;
            coefs(2,[2,3,5,6]) = [12/Le 6 -12/Le 6]/Le^2;
            coefs(3,[2,3,5,6]) = [6/Le 4 -6/Le 2]/Le;
            coefs(4,:) = -coefs(1,:);
            coefs(5,:) = -coefs(2,:);
            coefs(6,[2,3,5,6]) = [6/Le 2 -6/Le 4]/Le;  
            E = repmat(E,1,6);
            coefs = E.*coefs;
        end

        function coefs=formulateSectionCoefficients(A,I,~)
            %formulateMaterialCoefficients() - Formulate the material
            %   coefficients into BEAM23E stiffness matrix.            
            if isempty(A) || isempty(I)
                error('Missing section property or section properties not defined correctly');
            end
            Iyy = I(1);
            coefs = [A Iyy Iyy];
            coefs = repmat(coefs,1,2);             
        end
    end

    methods (Static=true,Access={?sap.DistributedLoadsRecords})
        %Methods access is only permitted to DistributedLoadsRecords 
        % in order to compute the nodal forces vector
        function f = formulateNodalForces(fstruct,Le,R)
            if ~fstruct.isnumeric
                fstruct=sap.DistributedLoadsRecords.reshapefstruct(fstruct);
                f(1,:)=fstruct.qx*Le/2;
                f(2,:)=fstruct.qy*Le/2;
                f(3,:)=fstruct.qy*Le^2/12;
                f(4,:)=fstruct.qx*Le/2;
                f(5,:)=fstruct.qy*Le/2;
                f(6,:)=-fstruct.qy*Le^2/12;      
                f=f(:);                
            else
                fstruct=sap.DistributedLoadsRecords.addzerovalue(fstruct);
                f = R'*[fstruct.qx;fstruct.qy;fstruct.qy*le/6;fstruct.qx;fstruct.qy;-fstruct.qy*le/6]*le/2;
            end
        end
    end

    methods (Static=true,Access={?sap.BodyLoadsRecords})
        %Methods access is only permitted to BodyLoadsRecords 
        % in order to compute the thermal and gravitational nodal forces
        % vectors.
        
        %Formulate Gravity Loads
        function f = formulateGravityLoads(m,g,a,Le,R)
            if isempty(m) || isempty(a) || isempty(g)
                f = zeros(6,1);
                return
            end     
            mg = m*g*a;
            fv = mg/2;
            fm = mg*Le/6;
            f = zeros(6,1);
            f([2,5]) = fv;
            f([3,6]) = [fm -fm];
            f = f*Le;  
            f = R'*f;
        end

        function t = formulateThermalLoads(a,i,E,cte,tval,tref)
            t= zeros(6,1);
            if isempty(a) || isempty(i) || isempty(E) || isempty(cte) || isempty(t) 
                return
            end
            tm = mean([tval,tref]);
            dt = diff([tval,tref]);            
            t([1,4],:)= [-cte*E*a*tm cte*E*a*tm];
            t([3,6],:) = [2*cte*dt*E*i -2*cte*dt*E*i];          
        end
    end

    methods (Static=true)
        function N=shapeFunc(s,Le)
            %Compute BEAM32E shape functions
            N = zeros(3,6,numel(Le)); % N is a NumEqnsx6 matrix.
            N1  = 1-s;              
            N2  = s;                
            N3  = 1-3*s^2+2*s^3;    dN3 = -(6/Le)*(s-s^2); 
            N4  = 3*s^2-2*s^3;      dN4 = (6/Le)*(s-s^2);
            N5  = Le*(s-2*s^2+s^3); dN5 = 1-4*s+3*s^2;
            N6  = Le*(-s^2+s^3);    dN6 = -2*s+3*s^2;  

            N(1,1) = N1;   N(1,4) =  N2;
            N(2,2) = N3;   N(2,3) =  N5;
            N(2,5) = N4;   N(2,6) =  N6;
            N(3,2) = -dN3; N(3,3) = dN5;
            N(3,5) = -dN4; N(3,6) = dN6;             
        end

        function N=dshapeFunc(s,Le)
            %Compute BEAM32E shape functions first derivatives
            N = zeros(3,6,numel(Le)); % N is a NumEqnsx6 matrix.
            N1  = 1-1/Le;              
            N2  = 1/Le;                
            N3  = -(6/Le)*(s-s^2); dN3 = -(6/Le^2)*(1-2*s); 
            N4  = (6/Le)*(s-s^2);  dN4 = (6/Le^2)*(1-2*s);
            N5  = 1-4*s+3*s^2;     dN5 = (1/Le)*(-4+6*s);
            N6  = -2*s+3*s^2;      dN6 = (1/Le)*(-2+6*s);     

            N(1,1) = N1;   N(1,4) =  N2;
            N(2,2) = N3;   N(2,3) =  N5;
            N(2,5) = N4;   N(2,6) =  N6;
            N(3,2) = -dN3; N(3,3) = dN5;
            N(3,5) = -dN4; N(3,6) = dN6;  
        end

        function N=d2shapeFunc(s,Le)
            %Compute BEAM32E shape functions second derivatives
            N = zeros(3,6,numel(Le)); % N is a NumEqnsx6 matrix.        
            N1  = 0;                 
            N2  = 0;                 
            N3  = -(6/Le^2)*(1-2*s);  dN3  = 12/Le^3;
            N4  = (6/Le^2)*(1-2*s);   dN4  = -12/Le^3;
            N5  = (1/Le)*(-4+6*s);    dN5  = 6/Le^2;
            N6  = (1/Le)*(-2+6*s);    dN6  = 6/Le^2; 

            N(1,1) = N1;   N(1,4) =  N2;
            N(2,2) = N3;   N(2,3) =  N5;
            N(2,5) = N4;   N(2,6) =  N6;
            N(3,2) = -dN3; N(3,3) = dN5;
            N(3,5) = -dN4; N(3,6) = dN6;             
        end

        function N=d3shapeFunc(Le)
            %Compute BEAM32E shape functions second derivatives
            N = zeros(3,6,numel(Le)); % N is a NumEqnsx6 matrix.   
            N1  = 0;       
            N2  = 0;       
            N3  = 12/Le^3;  dN3  = 0;
            N4  = -12/Le^3; dN4  = 0;
            N5  = 6/Le^2;   dN5  = 0;
            N6  = 6/Le^2;   dN6  = 0;      

            N(1,1) = N1;   N(1,4) =  N2;
            N(2,2) = N3;   N(2,3) =  N5;
            N(2,5) = N4;   N(2,6) =  N6;
            N(3,2) = -dN3; N(3,3) = dN5;
            N(3,5) = -dN4; N(3,6) = dN6;             
        end
    end
end