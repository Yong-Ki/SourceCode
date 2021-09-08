function [MinSegLength, MinSLNumber] = CalMinSegLength(PolyLine1, PolyLine2)

MinSegLength = 1E10;
MinSLNumber = zeros(1,2);

for ii = 1 : size(PolyLine1,1)-1
    Seg1 = [PolyLine1(ii,:); PolyLine1(ii+1,:)];
    for jj = 1 : size(PolyLine2,1)-1
        Seg2 = [PolyLine2(jj,:); PolyLine2(jj+1,:)];
        temp_MinSegLength = DistBetween2Segment(Seg1, Seg2);
        if temp_MinSegLength < MinSegLength
            MinSegLength = temp_MinSegLength;
            MinSLNumber = [ii,jj];
        end
    end
end

return;


    


    