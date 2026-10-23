function [cTimeRunge,eTimeRunge,cTimeFunc,eTimeFunc,maxErrorRunge,maxErrorFunc] = newton(n)

n=n+1;
runge = @(x) 1./(1 + 25*x.^2);
f = @(x) x.^4 - 2*x.^2;
x = linspace(-1,1,n);
yRunge = runge(x);
% create the coeffecients (construction time here)
tic
b = bValues(x,yRunge);
cTimeRunge = toc;
% test on 1000 points
xtest = linspace(-1,1,1000);
ytrue = runge(xtest);
yInterp = zeros(1,length(xtest));
tic;
for k = 1:length(xtest)
    xp = xtest(k);
    a = zeros(1, length(b));
    for i = 1:length(b)
        a(i) = b(i);
        if i > 1
            for j = 1:i-1
                a(i) = a(i) * (xp - x(j));
            end
        end
    end
    yInterp(k) = sum(a);
end
eTimeRunge=toc;
maxErrorRunge= max(abs(ytrue - yInterp));

%plotting Runge
% figure;
% plot(xtest, yInterp, 'r', 'LineWidth', 1.5);
% hold on;
% plot(xtest, ytrue, 'b--', 'LineWidth', 1.5);
% plot(x, yRunge, 'ko', 'MarkerFaceColor', 'k', 'MarkerSize', 6);  % nodes
% title(sprintf('Newton Interpolation vs Runge Function (n=%d)', n-1));
% xlabel('x');
% ylabel('y');
% legend('Newton Interpolation', 'True Function (Runge)', 'Nodes');
% grid on;
% hold off;

%other function f(x)
x = linspace(-1,1,n);
yF = f(x);
% find the coefficients recursively
tic
b = bValues(x,yF);
cTimeFunc = toc;
% test on 1000 points
xtest = linspace(-1,1,1000);
ytrue = f(xtest);
yInterp = zeros(1,length(xtest));
tic;
for k = 1:length(xtest)
    xp = xtest(k);
    a = zeros(1, length(b));
    for i = 1:length(b)
        a(i) = b(i);
        if i > 1
            for j = 1:i-1
                a(i) = a(i) * (xp - x(j));
            end
        end
    end
    yInterp(k) = sum(a);
end
eTimeFunc=toc;
maxErrorFunc= max(abs(ytrue - yInterp));

%plotting f(x)
% figure;
% plot(xtest, yInterp, 'r', 'LineWidth', 1.5);
% hold on;
% plot(xtest, ytrue, 'b--', 'LineWidth', 1.5);
% plot(x, yF, 'ko', 'MarkerFaceColor', 'k', 'MarkerSize', 6);      % nodes
% title(sprintf('Newton Interpolation vs f(x) = x^4 - 2x^2 (n=%d)', n-1));
% xlabel('x');
% ylabel('y');
% legend('Newton Interpolation', 'True Function (x.^4 - 2*x.^2)', 'Nodes');
% grid on;
% hold off;
end

function b = bValues(x, y)
    n = length(x);
    b = zeros(1,n);
    for i = 1:n
        b(i) = dividedDiff(x(1:i), y(1:i));
    end
end

function d = dividedDiff(x, y)
    n = length(x);
    if n == 1
        d = y(1);
    else
        d = ( ...
            dividedDiff(x(2:end), y(2:end)) - ...
            dividedDiff(x(1:end-1), y(1:end-1)) ...
            ) / (x(end) - x(1));
    end
end