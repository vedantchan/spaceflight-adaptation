function RM=RecMat(A)
[N,M]=size(A);
for j=1:N
  AA=A-ones(N,1)*A(j,:);
  AA=sqrt(sum(AA'.^2));
  RM(j,1:N)=AA;
end
return
