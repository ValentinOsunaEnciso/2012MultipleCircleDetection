function [y0ord x0ord rord]=ordenaconmisindices(x0,y0,r,ind)
tam=size(ind,2);
y0ord=zeros(1,tam);
x0ord=zeros(1,tam);
rord=zeros(1,tam);
for ind5=1:tam
    y0ord(ind5)=y0(ind(ind5));
    x0ord(ind5)=x0(ind(ind5));
    rord(ind5)=r(ind(ind5));
end