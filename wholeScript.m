clc; clear;

degrees = [4, 8, 12, 16, 20];
nD = length(degrees);

% Storage: rows = degrees, cols = methods (A, B, C)
condNumbers = zeros(nD, 1);

cTimeFunc = zeros(nD, 3);
eTimeFunc = zeros(nD, 3);
maxErrFunc = zeros(nD, 3);

cTimeRunge = zeros(nD, 3);
eTimeRunge = zeros(nD, 3);
maxErrRunge = zeros(nD, 3);

for idx = 1:nD
    n = degrees(idx);

    % --- Method A: Direct ---
    [cond_A, cTR_A, eTR_A, cTF_A, eTF_A, mER_A, mEF_A] = Direct(n);
    condNumbers(idx)   = cond_A;
    cTimeRunge(idx,1)  = cTR_A;  eTimeRunge(idx,1) = eTR_A;  maxErrRunge(idx,1) = mER_A;
    cTimeFunc(idx,1)   = cTF_A;  eTimeFunc(idx,1)  = eTF_A;  maxErrFunc(idx,1)  = mEF_A;

    % --- Method B: Newton ---
    [cTR_B, eTR_B, cTF_B, eTF_B, mER_B, mEF_B] = newton(n);
    cTimeRunge(idx,2)  = cTR_B;  eTimeRunge(idx,2) = eTR_B;  maxErrRunge(idx,2) = mER_B;
    cTimeFunc(idx,2)   = cTF_B;  eTimeFunc(idx,2)  = eTF_B;  maxErrFunc(idx,2)  = mEF_B;

    % --- Method C: Lagrange ---
    [cTR_C, eTR_C, cTF_C, eTF_C, mER_C, mEF_C] = Lagrange(n);
    cTimeRunge(idx,3)  = cTR_C;  eTimeRunge(idx,3) = eTR_C;  maxErrRunge(idx,3) = mER_C;
    cTimeFunc(idx,3)   = cTF_C;  eTimeFunc(idx,3)  = eTF_C;  maxErrFunc(idx,3)  = mEF_C;
end

close all;  % close all per-method figures, print tables instead

%% ===== TABLE 1: Condition Numbers =====
fprintf('\n========== Table 1: Condition Numbers (Method A only) ==========\n');
fprintf('%-10s %-20s\n', 'Degree n', 'Condition Number');
fprintf('%s\n', repmat('-', 1, 32));
for idx = 1:nD
    fprintf('%-10d %-20.6e\n', degrees(idx), condNumbers(idx));
end

%% ===== TABLE 2: Construction Time =====
fprintf('\n========== Table 2: Construction Time (seconds) ==========\n');
fprintf('%-10s %-16s %-16s %-16s\n', 'Degree n', 'Method A', 'Method B', 'Method C');
fprintf('%s\n', repmat('-', 1, 60));
fprintf('-- Test 1: f(x) = x^4 - 2x^2 --\n');
for idx = 1:nD
    fprintf('%-10d %-16.6e %-16.6e %-16.6e\n', degrees(idx), cTimeFunc(idx,1), cTimeFunc(idx,2), cTimeFunc(idx,3));
end
fprintf('-- Test 2: Runge Function --\n');
for idx = 1:nD
    fprintf('%-10d %-16.6e %-16.6e %-16.6e\n', degrees(idx), cTimeRunge(idx,1), cTimeRunge(idx,2), cTimeRunge(idx,3));
end

%% ===== TABLE 3: Evaluation Time =====
fprintf('\n========== Table 3: Evaluation Time (seconds) ==========\n');
fprintf('%-10s %-16s %-16s %-16s\n', 'Degree n', 'Method A', 'Method B', 'Method C');
fprintf('%s\n', repmat('-', 1, 60));
fprintf('-- Test 1: f(x) = x^4 - 2x^2 --\n');
for idx = 1:nD
    fprintf('%-10d %-16.6e %-16.6e %-16.6e\n', degrees(idx), eTimeFunc(idx,1), eTimeFunc(idx,2), eTimeFunc(idx,3));
end
fprintf('-- Test 2: Runge Function --\n');
for idx = 1:nD
    fprintf('%-10d %-16.6e %-16.6e %-16.6e\n', degrees(idx), eTimeRunge(idx,1), eTimeRunge(idx,2), eTimeRunge(idx,3));
end

%% ===== TABLE 4: Maximum Interpolation Error =====
fprintf('\n========== Table 4: Maximum Interpolation Error ==========\n');
fprintf('%-10s %-16s %-16s %-16s\n', 'Degree n', 'Method A', 'Method B', 'Method C');
fprintf('%s\n', repmat('-', 1, 60));
fprintf('-- Test 1: f(x) = x^4 - 2x^2 --\n');
for idx = 1:nD
    fprintf('%-10d %-16.6e %-16.6e %-16.6e\n', degrees(idx), maxErrFunc(idx,1), maxErrFunc(idx,2), maxErrFunc(idx,3));
end
fprintf('-- Test 2: Runge Function --\n');
for idx = 1:nD
    fprintf('%-10d %-16.6e %-16.6e %-16.6e\n', degrees(idx), maxErrRunge(idx,1), maxErrRunge(idx,2), maxErrRunge(idx,3));
end

%% ===== FIGURE 1: Max Error vs Degree =====
figure;
subplot(1,2,1);
semilogy(degrees, maxErrFunc(:,1), 'b-o', 'LineWidth', 1.5, 'DisplayName', 'Method A'); hold on;
semilogy(degrees, maxErrFunc(:,2), 'r-s', 'LineWidth', 1.5, 'DisplayName', 'Method B');
semilogy(degrees, maxErrFunc(:,3), 'g-^', 'LineWidth', 1.5, 'DisplayName', 'Method C');
xlabel('Degree n'); ylabel('Max Error (log scale)');
title('Test 1: f(x) = x^4 - 2x^2');
legend('Location','best'); grid on;

subplot(1,2,2);
semilogy(degrees, maxErrRunge(:,1), 'b-o', 'LineWidth', 1.5, 'DisplayName', 'Method A'); hold on;
semilogy(degrees, maxErrRunge(:,2), 'r-s', 'LineWidth', 1.5, 'DisplayName', 'Method B');
semilogy(degrees, maxErrRunge(:,3), 'g-^', 'LineWidth', 1.5, 'DisplayName', 'Method C');
xlabel('Degree n'); ylabel('Max Error (log scale)');
title('Test 2: Runge Function');
legend('Location','best'); grid on;
sgtitle('Figure 1: Maximum Error vs. Degree');

%% ===== FIGURE 2: Evaluation Time vs Degree =====
figure;
subplot(1,2,1);
plot(degrees, eTimeFunc(:,1), 'b-o', 'LineWidth', 1.5, 'DisplayName', 'Method A'); hold on;
plot(degrees, eTimeFunc(:,2), 'r-s', 'LineWidth', 1.5, 'DisplayName', 'Method B');
plot(degrees, eTimeFunc(:,3), 'g-^', 'LineWidth', 1.5, 'DisplayName', 'Method C');
xlabel('Degree n'); ylabel('Evaluation Time (s)');
title('Test 1: f(x) = x^4 - 2x^2');
legend('Location','best'); grid on;

subplot(1,2,2);
plot(degrees, eTimeRunge(:,1), 'b-o', 'LineWidth', 1.5, 'DisplayName', 'Method A'); hold on;
plot(degrees, eTimeRunge(:,2), 'r-s', 'LineWidth', 1.5, 'DisplayName', 'Method B');
plot(degrees, eTimeRunge(:,3), 'g-^', 'LineWidth', 1.5, 'DisplayName', 'Method C');
xlabel('Degree n'); ylabel('Evaluation Time (s)');
title('Test 2: Runge Function');
legend('Location','best'); grid on;
sgtitle('Figure 2: Evaluation Time vs. Degree');