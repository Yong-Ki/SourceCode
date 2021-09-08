function DividedP = DividePCs(CheckIndex, tempIDX, Rot_PC_Pts)

Pts_Ymin = min(Rot_PC_Pts(:,2));
Pts_Ymax = max(Rot_PC_Pts(:,2));

boxH = (Pts_Ymax - Pts_Ymin) / 49;

DividedP = cell(50,1);

for ii = 1 : 50
    
    Yupper = Pts_Ymax + (boxH/2) - (boxH*(ii-1));
    Ylower = Yupper - boxH;
    
    innerSeg = [];

    for jj = 1 : size(tempIDX,1)
        
        CheckValue = CheckIndex{tempIDX(jj,1),1};
        
        tempMin = 1E100;
        tempMax = -1E100;
        
        for kk = 1 : size(CheckValue,1)
            tempP = Rot_PC_Pts(CheckValue(kk,1), :);
            if tempP(2) <= tempMin
                tempMin = tempP(2);
            end
            if tempP(2) >= tempMax
                tempMax = tempP(2);
            end
        end
        
        if tempMin >= Ylower && tempMin <= Yupper
            innerSeg = [innerSeg; tempIDX(jj,1)];
            continue;
        end
        if tempMax >= Ylower && tempMax <= Yupper
            innerSeg = [innerSeg; tempIDX(jj,1)];
            continue;
        end
        
    end
    
    OriP = [];
    for aa = 1 : size(innerSeg,1)
        tempCheckValue = CheckIndex{innerSeg(aa,1), 1};
        OriP = [OriP ; tempCheckValue];
    end
    if size(OriP,1) == 0
        continue;
    else
        DividedP{ii,1} = OriP;
    end    
    
end