function [NewPolyLine, RemainingPolyLine] = PolyToPolyLink(PolyLine1, PolyLine2, MinSLNumber, RemainingLengthTol)

NearZero = 1E-10;

TargetSeg1 = [ PolyLine1(MinSLNumber(1),:) ; PolyLine1(MinSLNumber(1)+1,:) ];
TargetSeg2 = [ PolyLine2(MinSLNumber(2),:) ; PolyLine2(MinSLNumber(2)+1,:) ];

[int_dist, ~, int_p1, int_p2] = DistBetween2Segment(TargetSeg1, TargetSeg2);

if norm(int_p1- int_p2) < NearZero
    int_p1 = (int_p1+int_p2)/2;
    int_p2 = int_p1;
end

int_Segments = cell(1,4);
int_Segments{1,1} = [int_p1; TargetSeg1(1,:)];
int_Segments{1,2} = [int_p1; TargetSeg1(2,:)];
int_Segments{1,3} = [int_p2; TargetSeg2(1,:)];
int_Segments{1,4} = [int_p2; TargetSeg2(2,:)];

temp_MaxL = zeros(1,4);

if size(int_Segments{1,1},1) ~= 0
    temp_centerSeg = int_Segments{1,1};
    temp_Length = 0;
    for ii = 1 : MinSLNumber(1)-1
        temp_Length = temp_Length + norm(PolyLine1(ii+1,:)-PolyLine1(ii,:));
    end
    temp_MaxL(1,1) = temp_Length + norm(temp_centerSeg(2,:)-temp_centerSeg(1,:));
end

if size(int_Segments{1,2},1) ~= 0
    temp_centerSeg = int_Segments{1,2};
    temp_Length = 0;
    for ii = MinSLNumber(1)+1 : size(PolyLine1,1)-1
        temp_Length = temp_Length + norm(PolyLine1(ii+1,:)-PolyLine1(ii,:));
    end
    temp_MaxL(1,2) = temp_Length + norm(temp_centerSeg(2,:)-temp_centerSeg(1,:));
end

if size(int_Segments{1,3},1) ~= 0
    temp_centerSeg = int_Segments{1,3};
    temp_Length = 0;
    for ii = 1 : MinSLNumber(2)-1
        temp_Length = temp_Length + norm(PolyLine2(ii+1,:)-PolyLine2(ii,:));
    end
    temp_MaxL(1,3) = temp_Length + norm(temp_centerSeg(2,:)-temp_centerSeg(1,:));
end

if size(int_Segments{1,4},1) ~= 0
    temp_centerSeg = int_Segments{1,4};
    temp_Length = 0;
    for ii = MinSLNumber(2)+1 : size(PolyLine2,1)-1
        temp_Length = temp_Length + norm(PolyLine2(ii+1,:)-PolyLine2(ii,:));
    end
    temp_MaxL(1,4) = temp_Length + norm(temp_centerSeg(2,:)-temp_centerSeg(1,:));
end

% 6 distances
% (1) 1-2  (2) 1-3  (3) 1-4
% (4) 2-3  (5) 2-4  (6) 3-4

sixdists = [temp_MaxL(1)+temp_MaxL(2);  temp_MaxL(1)+temp_MaxL(3)+int_dist;  temp_MaxL(1)+temp_MaxL(4)+int_dist; ...
    temp_MaxL(2)+temp_MaxL(3)+int_dist;  temp_MaxL(2)+temp_MaxL(4)+int_dist;  temp_MaxL(3)+temp_MaxL(4)];

[~,NewPolyIndex] = max(sixdists);

% 6 distances
% (1) 1-2  (2) 1-3  (3) 1-4
% (4) 2-3  (5) 2-4  (6) 3-4

RemainingPolyLine = cell(2,1);

switch NewPolyIndex
    
    case 1  % 1-2
        
        % NewPolyLine
        NewPolyLine = [PolyLine1(1:MinSLNumber(1), :); int_p1 ; PolyLine1(MinSLNumber(1)+1:end, :)];

        % RemainingPolyLines
        RemainingPolyNum = 0;
        if temp_MaxL(3) ~= 0 && temp_MaxL(3) > RemainingLengthTol
            RemainingPolyNum = RemainingPolyNum+1;
            RemainingPolyLine{RemainingPolyNum,1} = [PolyLine2(1:MinSLNumber(2),:); int_p1];
        end
        if temp_MaxL(4) ~= 0 && temp_MaxL(4) > RemainingLengthTol
            RemainingPolyNum = RemainingPolyNum+1;
            RemainingPolyLine{RemainingPolyNum,1} = [int_p1; PolyLine2(MinSLNumber(2)+1:end, :)];
        end
        
        
    case 2  % 1-3
        
        % NewPolyLine
        NewPolyLine = [PolyLine1(1:MinSLNumber(1),:); int_p1 ; int_p2 ; PolyLine2(MinSLNumber(2):-1:1,:)];

        % RemainingPolyLines
        RemainingPolyNum = 0;
        if temp_MaxL(2) ~= 0 && temp_MaxL(2) > RemainingLengthTol
            RemainingPolyNum = RemainingPolyNum+1;
            RemainingPolyLine{RemainingPolyNum,1} = [int_p1; PolyLine1(MinSLNumber(1)+1:end, :)];
        end
        if temp_MaxL(4) ~= 0 && temp_MaxL(4) > RemainingLengthTol
            RemainingPolyNum = RemainingPolyNum+1;
            RemainingPolyLine{RemainingPolyNum,1} = [int_p2; PolyLine2(MinSLNumber(2)+1:end, :)];
        end
        
        
    case 3  % 1-4
        
        % NewPolyLine
        NewPolyLine = [PolyLine1(1:MinSLNumber(1),:); int_p1; int_p2; PolyLine2(MinSLNumber(2)+1:end,:)];
        
        % RemainingPolyLines
        RemainingPolyNum = 0;
        if temp_MaxL(2) ~= 0 && temp_MaxL(2) > RemainingLengthTol
            RemainingPolyNum = RemainingPolyNum+1;
            RemainingPolyLine{RemainingPolyNum,1} = [int_p1; PolyLine1(MinSLNumber(1)+1:end, :)];
        end
        if temp_MaxL(3) ~= 0 && temp_MaxL(3) > RemainingLengthTol
            RemainingPolyNum = RemainingPolyNum+1;
            RemainingPolyLine{RemainingPolyNum,1} = [PolyLine2(1:MinSLNumber(2),:); int_p2];
        end

        
    case 4  % 2-3
        
        % NewPolyLine
        NewPolyLine = [PolyLine1(end:-1:MinSLNumber(1)+1,:); int_p1; int_p2; PolyLine2(MinSLNumber(2):-1:1,:)];

        % RemainingPolyLines
        RemainingPolyNum = 0;
        if temp_MaxL(1) ~= 0 && temp_MaxL(1) > RemainingLengthTol
            RemainingPolyNum = RemainingPolyNum+1;
            RemainingPolyLine{RemainingPolyNum,1} = [PolyLine1(1:MinSLNumber(1), :); int_p1];
        end
        if temp_MaxL(4) ~= 0 && temp_MaxL(4) > RemainingLengthTol
            RemainingPolyNum = RemainingPolyNum+1;
            RemainingPolyLine{RemainingPolyNum,1} = [int_p2; PolyLine2(MinSLNumber(2)+1:end, :)];
        end
        
    case 5  % 2-4
        
        % NewPolyLine
        NewPolyLine = [PolyLine1(end:-1:MinSLNumber(1)+1,:); int_p1; int_p2 ; PolyLine2(MinSLNumber(2)+1:end,:)];
        
        % RemainingPolyLines
        RemainingPolyNum = 0;
        if temp_MaxL(1) ~= 0 && temp_MaxL(1) > RemainingLengthTol
            RemainingPolyNum = RemainingPolyNum+1;
            RemainingPolyLine{RemainingPolyNum,1} = [PolyLine1(1:MinSLNumber(1), :); int_p1];
        end
        if temp_MaxL(3) ~= 0 && temp_MaxL(3) > RemainingLengthTol
            RemainingPolyNum = RemainingPolyNum+1;
            RemainingPolyLine{RemainingPolyNum,1} = [PolyLine2(1:MinSLNumber(2),:); int_p2];
        end
        
    case 6  % 3-4
        
        % NewPolyLine
        NewPolyLine = [PolyLine2(1:MinSLNumber(2), :); int_p2 ; PolyLine2(MinSLNumber(2)+1:end,:)];

        % RemainingPolyLines
        RemainingPolyNum = 0;
        if temp_MaxL(1) ~= 0 && temp_MaxL(1) > RemainingLengthTol
            RemainingPolyNum = RemainingPolyNum+1;
            RemainingPolyLine{RemainingPolyNum,1} = [PolyLine1(1:MinSLNumber(1), :); int_p1];
        end
        if temp_MaxL(2) ~= 0 && temp_MaxL(2) > RemainingLengthTol
            RemainingPolyNum = RemainingPolyNum+1;
            RemainingPolyLine{RemainingPolyNum,1} = [int_p1; PolyLine1(MinSLNumber(1)+1:end, :)];
        end
        
end

RemainingPolyLine = RemainingPolyLine(1:RemainingPolyNum, :);
