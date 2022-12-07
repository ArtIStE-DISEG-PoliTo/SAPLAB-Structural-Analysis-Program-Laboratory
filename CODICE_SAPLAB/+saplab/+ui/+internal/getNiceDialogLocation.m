function figSize = getNiceDialogLocation(Pos)
if nargin == 0

scSize = get(0,'ScreenSize');
l = .8*scSize(3);
w = .8*scSize(4);
x = (scSize(3)-l)/2;
y = (scSize(4)-w)/3;

figSize = [x y l w];

else
scSize = get(0,'ScreenSize');

l = Pos(3);
w = Pos(4);

x = (scSize(3)-l)/2;
y = (scSize(4)-w)/2;
figSize = [x y l w];

end

end