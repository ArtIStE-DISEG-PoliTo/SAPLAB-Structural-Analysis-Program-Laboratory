function vr = rotate3D_o(v2rot, rotdirection, rotcenter, rotangle)

if strcmpi('X', rotdirection)
    R = makehgtform('xrotate',rotangle);
    R = R(1:3, 1:3);
elseif strcmpi('Y', rotdirection)
    R = makehgtform('yrotate',rotangle);
    R = R(1:3, 1:3);
elseif strcmpi('Z', rotdirection)
    R = makehgtform('zrotate',rotangle);
    R = R(1:3, 1:3);
end

xc = rotcenter(1); %coordinata x del centro di rotazione
yc = rotcenter(2); %coordinata y del centro di rotazione
zc = rotcenter(3); %coordinata z del centro di rotazione

centerofrotation = repmat([xc; yc; zc], 1, length(v2rot(1,:)));

%applica la rotazione
s = v2rot - centerofrotation; %shifta i punti al centro di rotazione
sr = R*s; %ruota i punti 
vr = sr+centerofrotation;

end     