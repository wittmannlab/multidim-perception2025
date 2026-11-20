function plot_difficulty(csv_id)

fs = filesep;

% --- Load CSV ------------------------------------------------------------
T1          = readtable(csv_id{1});
T2          = readtable(csv_id{2});

difficulty = T1.difficulty;
ed = T2.ED_2d;
acc= T2.accuracy;


% calculate partial correlation:
mdl_ed  = fitlm(difficulty, ed);    % linear model ed ~ difficulty
mdl_acc = fitlm(difficulty, acc);   % linear model acc ~ difficulty

ed_res  = mdl_ed.Residuals.Pearson;        % ED residuals (controlling for difficulty)
acc_res = mdl_acc.Residuals.Pearson;       % ACC residuals (controlling for difficulty)

[rres pres ] = corr(acc_res,ed_res);
%-------------------------------------------------------------------------------------------
% 1) make histogram:

figure; subplot(2,2,1)

% Histogram
h = histogram(difficulty, ...
    'Normalization','count', ...
    'BinMethod','fd', ...
    'FaceColor',[0.1 0.2 0.7], ...
    'EdgeColor','none');

% Axes formatting
xlim([0 1.5])
ylabel('Number of participants','FontSize',12)
xlabel({'Catch trial difficulty', ...
        '(Difference in ED distance between catch trial options and target)'}, ...
        'FontSize',11)

set(gca, ...
    'FontSize',11, ...
    'LineWidth',1, ...
    'Box','off')

% Panel label
text(-0.1, 1.05, 'A', ...
    'Units','normalized', ...
    'FontSize',14, ...
    'FontWeight','bold')

hold off


%-------------------------------------------------------------------------------------------
% 2) Correlation
subplot(2,2,2)


% Scatter: open orange circles
scatter(ed_res, acc_res, 35, ...
    'o', ...
    'MarkerEdgeColor', [0.95 0.55 0.25], ...
    'MarkerFaceColor', 'none', ...
    'LineWidth', 1); hold all

% Fit and plot regression line
lm_line = fitlm(ed_res, acc_res);
xfit = linspace(min(ed_res), max(ed_res), 200)';
yfit = predict(lm_line, xfit);
plot(xfit, yfit, '-', ...
    'Color', [0.9 0.2 0.2], ...
    'LineWidth', 1.5);

% Labels (match example)
xlabel('RS 2D residuals in vmPFC (controlling for difficulty)', 'FontSize', 11);
ylabel('Choice accuracy residuals (controlling for difficulty)', 'FontSize', 11);



% Stats annotation (top right, italic r)
txt = sprintf('\\itr\\rm = %.3f, p = %.3f', rres, pres);
text(0.55, 0.93, txt, ...
    'Units','normalized', ...
    'FontSize', 10);

% Panel label
text(-0.18, 1.05, 'B', ...
    'Units','normalized', ...
    'FontSize', 13, ...
    'FontWeight','bold');

% Axis styling
set(gca, ...
    'FontSize', 10, ...
    'LineWidth', 1.2, ...
    'Box','off', ...
    'TickDir','out');

hold off


saveas(gcf, ['..' fs '5_Figs' fs 'SuppFigure.5.fig']); 