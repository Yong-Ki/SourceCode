function [LinkedPolyLines,CutPolylines] = SegmentLink(MinDistTol, LineSegments)

PolyLines = LineSegments;
MinSegLengthTol = MinDistTol;

tot_RemainingPolyNum = 0;
tot_RemainingPolyLines = cell(10000,1);

tot_NewPolyNum = 0;
tot_NewPolyLines = cell(10000,1);

TargetPoly = 1;

while 1
    
    if size(PolyLines,1) == 1
        tot_NewPolyNum = tot_NewPolyNum + 1;
        tot_NewPolyLines{tot_NewPolyNum,1} = PolyLines{1,1};
        break;
    end
    
    RemoveCheck = ones(size(PolyLines,1),1);
    
    MinSegLength = 1E10;
    for LSnum = 1 : size(PolyLines,1)
        if LSnum == TargetPoly
            continue;
        end
        [temp_MinSegLength, temp_MinSLNumber] = CalMinSegLength(PolyLines{TargetPoly,1}, PolyLines{LSnum,1});
        if temp_MinSegLength < MinSegLength
            NextPoly = LSnum;
            MinSegLength = temp_MinSegLength;
            MinSLNumber = temp_MinSLNumber;
        end
    end
    
    if MinSegLength <= MinSegLengthTol
        [NewPolyLine, RemainingPolyLine] = PolyToPolyLink(PolyLines{TargetPoly,1}, PolyLines{NextPoly,1}, MinSLNumber, 0.05);
        RemoveCheck(TargetPoly,1) = 0;
        RemoveCheck(NextPoly,1) = 0;
        PolyLines = PolyLines(logical(RemoveCheck),:);
        PolyLines = [NewPolyLine; PolyLines];
        TargetPoly = 1;
    else
        RemoveCheck(TargetPoly,1) = 0;
        tot_NewPolyNum = tot_NewPolyNum + 1;
        tot_NewPolyLines{tot_NewPolyNum,1} = PolyLines{TargetPoly,1};
        if TargetPoly < NextPoly
            TargetPoly = 1;
        else
            TargetPoly = TargetPoly+1;
        end
        PolyLines = PolyLines(logical(RemoveCheck),:);
        continue;
    end
    
    if size(RemainingPolyLine,1) > 0
        tot_RemainingPolyLines(tot_RemainingPolyNum+1:tot_RemainingPolyNum+size(RemainingPolyLine,1), :)...
            = RemainingPolyLine(1:end,:);
        tot_RemainingPolyNum = tot_RemainingPolyNum + size(RemainingPolyLine,1);
    end

end

LinkedPolyLines = tot_NewPolyLines(1:tot_NewPolyNum, :);
CutPolylines = tot_RemainingPolyLines(1:tot_RemainingPolyNum, :);