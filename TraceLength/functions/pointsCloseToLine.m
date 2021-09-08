function NearPointIDX = pointsCloseToLine(ShiftedLabelPoints, p, b, dx)

tempPts = ShiftedLabelPoints;

NearPointIDX = zeros(size(tempPts,1), 1);

for ii = 1 : size(tempPts,1)
    
    temp_Pt = tempPts(ii,:);
    
    t = ( b(1)*(temp_Pt(1)-p(1)) +  b(2)*(temp_Pt(2)-p(2)) + b(3)*(temp_Pt(3)-p(3)) );
    temp_d = norm(temp_Pt - ( p + (t*b) ));
    
    if temp_d <= dx
        NearPointIDX(ii,1) = 1;
    end
    
end

return;