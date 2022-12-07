function [hh, class] = readAll(self, sectionType, roll)
arguments
    self (1,1) saplab.tool.SectionToolbox;
    sectionType {mustBeA(sectionType, ["char", "string"])};
    roll (1,1) double;
end
sectionType = string(sectionType);
sectionType = lower(sectionType);
if (contains(sectionType, "he"))
    [hh, class, ~]= self.HEread(sectionType, roll);
    %evaluate torsional constant
elseif (contains(sectionType, "ipe"))
    [hh, class, ~]= self.IPEread(sectionType, roll);
else
    error('Invalid section type.');
end
end