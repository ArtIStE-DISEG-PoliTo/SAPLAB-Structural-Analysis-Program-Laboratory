function [hh, class, Polyshape] = IPEread(self, sectionType, roll)

arguments
    self (1,1) saplab.tool.SectionToolbox;
    sectionType {mustBeA(sectionType, ["char", "string"])};
    roll (1,1) double;
end
sectionType = string(sectionType);
sectionType = lower(sectionType);
text = sectionType;
if ( ~contains( sectionType, "ipe" ) )
    return;
end
section = readtable("+saplab\+tool\+section\+data\ipe.xlsx");
section = table2array(section);
IDvalue = erase(sectionType, "ipe");
[~, IDvalue] = evalc(IDvalue); 
flag = section(:,1) == IDvalue; %get the flag...

if all( flag == 0 )
    warning('Section not found.');
    hh = [];
    return;
end
data = section(flag, :);

h = data(2);
b = data(3);
tf = data(4);
tw = data(5);
r = data(6);

[hh, Polyshape] = self.IH_section(b, h, tf, tw, r, roll);
class = upper(text);
%evaluate torsional constant
J = (2*b*tw^3 + (h-tw)*tf^3)/3;
self.Data.J = J;
self.Polyshape = Polyshape; %set polyshape
end