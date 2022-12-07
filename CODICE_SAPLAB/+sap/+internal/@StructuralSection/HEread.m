function [hh, class, Polyshape] = HEread(self, sectionType, roll)

arguments
    self (1,1) saplab.tool.SectionToolbox;
    sectionType {mustBeA(sectionType, ["char", "string"])};
    roll (1,1) double;
end
sectionType = string(sectionType);
sectionType = lower(sectionType);
if ( ~contains(sectionType, "he") )
    return;
end
text = sectionType;
if ( contains(sectionType, "a") )
    section = readtable("+saplab\+tool\+section\+data\hea.xlsx");
    IDvalue = erase(sectionType, "hea");
elseif ( contains(sectionType, "b") )
    section = readtable("+saplab\+tool\+section\+data\heb.xlsx");
    IDvalue = erase(sectionType, "heb"); 
elseif ( contains(sectionType, "m") )
    section = readtable("+saplab\+tool\+section\+data\hem.xlsx");
    IDvalue = erase(sectionType, "hem"); 
else 
    error('Invalid HE section');
end
section = table2array(section);
[~, IDvalue] = evalc(IDvalue); 
flag = section(:,1) == IDvalue; %get the flag...

if all( flag == 0 )
    warning('Section not found.');
    hh = [];
    return;
end
data = section(flag, :);

b = data(2);
h = data(3);
tf = data(4);
tw = data(5);
r = data(6);

[hh, Polyshape] = self.IH_section(b, h, tf, tw, r, roll);
class = upper(text);

self.Polyshape = Polyshape; %set polyshape

%evaluate torsional constant
J = (2*b*tw^3 + (h-tw)*tf^3)/3;
self.Data.J = J;

end