function [] = mk3plot(signal,M,L)
    hold off
    A = makea1(signal,M,L);
    plot3(A(:,1), A(:,2), A(:,3));
    title(strcat('M = ',num2str(M),', L = ',num2str(L)));
end