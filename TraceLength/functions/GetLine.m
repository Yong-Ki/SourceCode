function [p, b, votes] = GetLine(VotingSpace, icosV, max_x, dx)

[M_V, M_I] = max(VotingSpace, [], 'all', 'linear');
[mi_1,mi_2,mi_3] = ind2sub( [size(VotingSpace,1),size(VotingSpace,2),size(VotingSpace,3)] , M_I );

b = icosV(mi_3,:);
votes = M_V;

x = -(max_x) + dx * (mi_2 - 1);
y = -(max_x) + dx * (mi_1 - 1);

p1 = x * (1 - ((b(1) * b(1)) / (1 + b(3)))) - y * ((b(1) * b(2)) / (1 + b(3)));
p2 = x * (-((b(1) * b(2)) / (1 + b(3)))) + y * (1 - ((b(2) * b(2)) / (1 + b(3))));
p3 = - x * b(1) - y * b(2);

p = [p1,p2,p3];


return;





