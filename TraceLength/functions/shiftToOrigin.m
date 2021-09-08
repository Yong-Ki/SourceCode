function [ShiftedPoints, ShiftValue] = shiftToOrigin(Points, minP, maxP)

ShiftedPoints = zeros(size(Points,1), 3);

p1 = minP;
p2 = maxP;
newshift = (p1 + p2) / 2;

for ii = 1 : size(Points,1)
    
    ShiftedPoints(ii,:) = Points(ii,:) - newshift;
    
end

ShiftValue = newshift;

