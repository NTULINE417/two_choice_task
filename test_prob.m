n_trials = 10;
p = [0.8, 0.2];

% threshold
t = round(n_trials * (1-p.'));

% build initial guess
p2 = [randperm(n_trials); randperm(n_trials)];
% generate decision
p2 = p2 > t;

% estimate probability for L/R
pl = sum(p2(1, :)) / n_trials;
pr = sum(p2(2, :)) / n_trials;
fprintf('p2, P(L)=%.4f, P(R)=%.4f\n', pl, pr);

% dump result
disp(p2);
