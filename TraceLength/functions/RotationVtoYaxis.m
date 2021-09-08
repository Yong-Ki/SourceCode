function [RotX, RotZ] = RotationVtoYaxis(NormalVector)

nv = NormalVector;

nv = nv./norm(nv);
nv = -nv;

RefLineVec = nv;

projLineVec = [RefLineVec(1), RefLineVec(2), 0];
projLineVec = zeroing(projLineVec);

if projLineVec(1) < 0 
    LDD = 360 - acos(projLineVec(2)) / pi * 180;
else
    LDD = acos(projLineVec(2)) / pi * 180;
end
if RefLineVec(3) < 0
    LD = - acos(RefLineVec(1)*projLineVec(1) + RefLineVec(2)*projLineVec(2) + RefLineVec(3)*projLineVec(3)) / pi * 180;
else
    LD = acos(RefLineVec(1)*projLineVec(1) + RefLineVec(2)*projLineVec(2) + RefLineVec(3)*projLineVec(3)) / pi * 180;
end

RotX = rotx(-LD);
RotZ = rotz(LDD);

