
function fixCross = makeFixCross(N, colbk, x, y, w)
if length(N)==2
fixCross = ones(N(2), N(1),3);
else 
    fixCross = ones(N, N,3);
end
fixCross(:,:,1) = colbk(1);
fixCross(:,:,2) = colbk(2);
fixCross(:,:,3) = colbk(3);
for i = 1:length(x)
    fixCross(round(y(i)), (round(x(i))-w):(round(x(i))+w),:) = 0;
    fixCross((round(y(i))-w):(round(y(i))+w), round(x(i)),:) = 0;
end

end