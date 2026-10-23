function [conditionNumber,cTimeRunge,eTimeRunge,cTimeFunc,eTimeFunc,maxErrorRunge,maxErrorFunc] = Direct(n)

runge = @(x) 1./(1 + 25*x.^2);
f = @(x) x.^4 - 2*x.^2;

% interpolation points
x = linspace(-1,1,n+1);
yRunge = runge(x);

% Vandermonde matrix
V = vander(x);
conditionNumber = cond(V);

% coefficients
tic
cRunge = V \ yRunge';
cTimeRunge = toc;

xtest = linspace(-1,1,1000);
yTrue = runge(xtest);
yInterp = zeros(size(xtest));

tic
for i = 1:length(cRunge)
    yInterp = yInterp + cRunge(i) * xtest.^(length(cRunge)-i);
end
eTimeRunge = toc;
maxErrorRunge = max(abs(yTrue - yInterp));

% figure
% plot(xtest, yInterp, 'b', 'LineWidth', 1.5)
% hold on
% plot(xtest, yTrue, 'r--', 'LineWidth', 1.5)
% plot(x, yRunge, 'ko', 'MarkerFaceColor', 'k', 'MarkerSize', 6)   % nodes
% xlabel('x')
% ylabel('y')
% title(['Runge Interpolation (n = ', num2str(n+1), ')'])
% legend('Interpolant', 'True Function', 'Nodes')
% grid on
% hold off

% for the other function
x = linspace(-1,1,n+1);
yF = f(x);

V = vander(x);
tic;
cF = V \ yF';
cTimeFunc = toc;

xtest = linspace(-1,1,1000);
yTrue = f(xtest);
yInterp = zeros(size(xtest));

tic;
for i = 1:length(cF)
    yInterp = yInterp + cF(i) * xtest.^(length(cF)-i);
end
eTimeFunc = toc;
maxErrorFunc = max(abs(yTrue - yInterp));

% figure
% plot(xtest, yInterp, 'b', 'LineWidth', 1.5)
% hold on
% plot(xtest, yTrue, 'r--', 'LineWidth', 1.5)
% plot(x, yF, 'ko', 'MarkerFaceColor', 'k', 'MarkerSize', 6)       % nodes
% xlabel('x')
% ylabel('y')
% title(['f(x) Interpolation (n = ', num2str(n+1), ')'])
% legend('Interpolant', 'True Function', 'Nodes')
% grid on
% hold off
end