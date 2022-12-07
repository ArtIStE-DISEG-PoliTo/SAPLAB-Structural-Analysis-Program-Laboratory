classdef IPE < fem.internal.StructuralSection

    methods ( Hidden = true ) %hidden class constructor 
        function self = IPE(nameID, varargin)

            p = inputParser;
            addParameter(p, 'Orientation', [], @isnumeric);
            parse(p, varargin{:});

            narginchk(1,3);
            nargoutchk(0,1);
            data = readtable("+fem\+internal\+section\+data\ipe.xlsx");
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
            h  = sdat(2);
            b  = sdat(3);
            tf = sdat(4);
            tw = sdat(5);
            r  = sdat(6);  

            %get the roll angle
            roll = p.Results.Orientation;
            if ( isempty(roll) )
                roll = 0;
            end
            
            [dl, hh] = fem.internal.section.compose_HE_IPE(b, h, tf, tw, r, roll);
            [geometry, interia] = fem.internal.section.evaluateProperties(dl);
            
            %unpack properties
            area = geometry.A;
            iyy = interia.Iuu;
            izz = interia.Ivv;
            iyz = interia.Iuv;
            jxx = (2*b*tw^3 + (h-tw)*tf^3)/3;
            i11 = interia.I11;
            i22 = interia.I22;
            t = [interia.theta11 interia.theta22];
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
            self.Class = ['IPE', num2str(sidval)];

        end

    end
    methods ( Static = true , Hidden = true )
        [dl, IH] = constructHEA(b, h, tf, tw, r, roll)
    end
end