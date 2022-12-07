classdef HEB < fem.internal.StructuralSection

    methods ( Hidden = true ) %hidden class constructor 
        function self = HEB(nameID, varargin)

            p = inputParser;
            addParameter(p, 'Orientation', [], @isnumeric);
            parse(p, varargin{:});

            narginchk(1,3);
            nargoutchk(0,1);
            data = readtable("+fem\+internal\+section\+data\heb.xlsx");
            data = table2array(data);
            if ( isnumeric(nameID) && isscalar(nameID) )
                sidval = nameID;
            elseif (ischar(nameID) || isstring(nameID))
                [~, sidval] = evalc(nameID);
            end
            flag = data(:,1) == sidval;
            if (all(flag == 0))
                error('Section not found.');
            end       
            
            %get the section data
            sdat = data(flag, :);
            b  = sdat(2);
            h  = sdat(3);
            tf = sdat(4);
            tw = sdat(5);
            r  = sdat(6);  

            %get the roll angle
            roll = p.Results.Orientation;
            if ( isempty(roll) )
                roll = 0;
            end
            
            [dl, hh] = fem.internal.section.compose_HE_IPE(b, h, tf, tw, r, roll);
            [geometry, inertia] = fem.internal.section.evaluateProperties(dl);
            
            %unpack properties
            area = geometry.A;
            iyy = inertia.Iuu;
            izz = inertia.Ivv;
            iyz = inertia.Iuv;
            jxx = (2*b*tw^3 + (h-tw)*tf^3)/3;
            i11 = inertia.I11;
            i22 = inertia.I22;
            t = [inertia.theta11 inertia.theta22];
            self@fem.internal.StructuralSection(area, iyy, izz, iyz, jxx, i11, i22, t);

            %set final parameters
            self.Perimeter = geometry.P;
            self.Centroid = [geometry.xg geometry.yg];
            prop1 = addprop(self, 'Polyshape'); 
            prop2 = addprop(self, 'Vertices'); 
            prop1.Hidden = true;
            prop2.Hidden = true;
            self.Polyshape = hh;
            self.Vertices = hh.Vertices;
            self.Class = ['HEB', num2str(sidval)];

        end

    end
    methods ( Static = true , Hidden = true )
        [dl, IH] = constructHEA(b, h, tf, tw, r, roll)
    end
end