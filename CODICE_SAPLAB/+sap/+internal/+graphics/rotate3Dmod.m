function vr = rotate3Dmod(v2rot, rotcenter, R)

xc = rotcenter(1); %coordinata x del centro di rotazione
yc = rotcenter(2); %coordinata y del centro di rotazione
zc = rotcenter(3); %coordinata z del centro di rotazione

centerofrotation = repmat([xc; yc; zc], 1, length(v2rot(1,:)));

%applica la rotazione
s = v2rot - centerofrotation; %shifta i punti al centro di rotazione
sr = R*s; %ruota i punti 
vr = sr+centerofrotation;
end

