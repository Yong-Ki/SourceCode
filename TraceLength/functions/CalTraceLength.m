function TraceLength = CalTraceLength(LinkedPolyLines)

TraceLength = zeros(size(LinkedPolyLines,1), 1);

for ii = 1 : size(LinkedPolyLines,1)
    
    tempPolyLine = LinkedPolyLines{ii,1};
    
    tempLength = 0;
    for jj = 1 : size(tempPolyLine,1)-1
        p1 = tempPolyLine(jj,:);
        p2 = tempPolyLine(jj+1,:);
        tempLength = tempLength + sqrt(sum((p2-p1).^2));
    end
    
    TraceLength(ii,1) = tempLength;

end
