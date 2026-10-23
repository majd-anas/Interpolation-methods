function [cTimeRunge, eTimeRunge, cTimeFunc, eTimeFunc, maxErrorRunge, maxErrorFunc] = Lagrange(n)

n = n + 1;
runge = @(x) 1./(1 + 25*x.^2);
f     = @(x) x.^4 - 2*x.^2;
x = linspace(-1, 1, n);

% construction time
tic;
yRunge = runge(x);
cTimeRunge = toc;

% testing at 1000 points
xtest = linspace(-1, 1, 1000);
ytrue = runge(xtest);
yInterp = zeros(1, length(xtest));

% evaluation time of the test
tic;
for k = 1:length(xtest)
    a = zeros(1, n);
    for i = 1:n
        Li = 1;
        for j = 1:n
            if j == i, continue; end
            Li = Li * (xtest(k) - x(j)) / (x(i) - x(j));
        end
        a(i) = Li * yRunge(i);
    end
    yInterp(k) = sum(a);
end
eTimeRunge = toc;
maxErrorRunge = max(abs(ytrue - yInterp));

% --- Plot Runge ---
% figure;
% plot(xtest, yInterp, 'b', 'LineWidth', 2);
% hold on;
% plot(xtest, ytrue, 'r--', 'LineWidth', 2);
% plot(x, yRunge, 'ko', 'MarkerFaceColor', 'k', 'MarkerSize', 6);  % show nodes
% xlabel('x');
% ylabel('y');
% title(sprintf('Lagrange Interpolation — Runge Function (n=%d)', n-1));
% legend('Interpolated', 'True Runge', 'Nodes');
% grid on;
% hold off;

% constrution time of other function f(x)
tic;
yF = f(x);
cTimeFunc = toc;

% testing at 1000 points
xtest = linspace(-1, 1, 1000);
ytrueF = f(xtest);
yInterpF = zeros(1, length(xtest));

% evaluation time
tic;
for k = 1:length(xtest)
    a = zeros(1, n);
    for i = 1:n
        Li = 1;
        for j = 1:n
            if j == i, continue; end
            Li = Li * (xtest(k) - x(j)) / (x(i) - x(j));
        end
        a(i) = Li * yF(i);
    end
    yInterpF(k) = sum(a);
end
eTimeFunc = toc;
maxErrorFunc = max(abs(ytrueF - yInterpF));

% --- Plot f(x) ---
% figure;
% plot(xtest, yInterpF, 'b', 'LineWidth', 2);
% hold on;
% plot(xtest, ytrueF, 'r--', 'LineWidth', 2);
% plot(x, yF, 'ko', 'MarkerFaceColor', 'k', 'MarkerSize', 6);  % show nodes
% xlabel('x');
% ylabel('y');
% title(sprintf('Lagrange Interpolation — f(x) = x^4 - 2x^2 (n=%d)', n-1));
% legend('Interpolated', 'True f(x)', 'Nodes');
% grid on;
% hold off;

end
