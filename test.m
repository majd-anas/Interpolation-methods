x = [1 2 3 ];
y = [1 5 2];

n=length(x);

yRunge = y;
L=ones(1,n);
a=zeros(1,n);
%first for each x calculate 
ytest=zeros(1,n);
ytest
for k = 1:length(x)
    L = ones(1,n);
    a=zeros(1,n);
    for i = 1:n
        for j = 1:n
            if j == i
                continue;
            end
            L(i) = L(i) * ((x(k) - x(j)) / (x(i) - x(j)));
        end
        a(i) = L(i) * yRunge(i);
    end

    ytest(k) = sum(a);
end
plot(x,ytest)