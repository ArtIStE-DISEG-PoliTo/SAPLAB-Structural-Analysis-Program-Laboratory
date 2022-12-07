function dc = directionCosine(loc,glob)

if strcmp(glob,'x')
    dc = loc(1);
elseif strcmp(glob,'y')
    dc = loc(2);
elseif strcmp(glob,'z')
    dc = loc(3);
end

end
