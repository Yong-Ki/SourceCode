function NewVotingSpace = VotingHoughSpace(xprimeMat,yprimeMat, VotingSpace, VotingFlag)

% (Add) VotingFlag = 1 
% (Subtract) VotingFlag = 0 

for ii = 1 : size(xprimeMat,1)
    for jj = 1 : size(xprimeMat,2)
        if VotingFlag == 1
            VotingSpace(yprimeMat(ii,jj), xprimeMat(ii,jj), jj) = VotingSpace(yprimeMat(ii,jj), xprimeMat(ii,jj), jj) + 1;
        else
            VotingSpace(yprimeMat(ii,jj), xprimeMat(ii,jj), jj) = VotingSpace(yprimeMat(ii,jj), xprimeMat(ii,jj), jj) - 1;
        end
    end
end

NewVotingSpace = VotingSpace;