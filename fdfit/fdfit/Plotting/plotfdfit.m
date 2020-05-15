function plotfdfit(varargin)
% PLOTFDFIT Plot force-extension data together with an associated fit.
%
% SYNTAX:
% plotfdfit(fd, fitobject)
%       Plot the results of a fit made with the "fitfd" function.
% plotfdfit(fd, params)
%       Plot the results of a custom fit, given explicit values for the model
%       parameters.
% plotfdfit(..., 'key', value, ...)
%       For a description of the key-value pair arguments, see below.
% plotfdfit(ax, ...)
%       Plot the results in a specific axes system.
%
% INPUT:
% fd = FdData object
% fitobject = cfit object, as returned by the 'fit' or 'fitfd' functions.
% params = numeric vector with fit parameters.
% ax = axes handle (optional).
%
% KEY-VALUE PAIR ARGUMENTS:
% model = one of the models as supported by the "fitfd" function. See "fitfd"
%       for a list of available models.
% Fc = (only for the 'twlc' models) critical force (default: 30.6 pN).
%       This is the force at which the twist-stretch coupling changes from
%       a constant to a linear function (g0 + g1 F).
% C =  (only for the 'twlc' models) twist rigidity (default: 440 pN nm^2).
% Lc = contour length (only needed for models that require it).
% highlightSubset = FdData object with data that should be highlighted in
%       the plot. This could, for example, be the data range that was
%       actually used for fitting. (Optional)
% style = plot style. Available styles:
%         - 'normal' (default)
%         - 'semilog' (logarithmic F axis)
%         - 'log' (log-log scale)
%
% SEE ALSO:
% fitfd

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Parse & validate input

if nargin == 0
    error('plotfdfit:InvalidArgument', 'Invalid arguments: no arguments given.');
end

if ishghandle(varargin{1})
    axesHandle = varargin{1};
    varargin(1) = [];
else
    figure();
    axesHandle = gca();
end

if length(varargin) < 2
    error('plotfdfit:InvalidArgument', 'Invalid arguments: no arguments given.');
end

if isnumeric(varargin{2})
    mode = 'custom';
    [fd, paramVals] = varargin{1:2};
    varargin = varargin(3:end);
elseif isa(varargin{2}, 'cfit')
    mode = 'fitobject';
    [fd, fitObject] = varargin{1:2};
    varargin = varargin(3:end);
else
    error('plotfdfit:InvalidArgument', 'Invalid arguments: cfit object or numeric vector expected.');
end

% Parse remaining key-value pair arguments
defaultArgs = struct(...
                      'model',              'odijk-f0' ...
                    , 'Fc',                 30.6 ...
                    , 'C',                  440 ...
                    , 'Lc',                 [] ...
                    , 'highlightSubset',    [] ...
                    , 'style',              'normal' ...
                    );

args = parseArgs(varargin, defaultArgs);

if any(strcmp(args.model, {'odijk-d0','odijk-d0-f0','twlc-lc-fixed'})) && isempty(args.Lc)
    error('plotfdfit:LcMissing', 'Plot of fit with Lc fixed requested, but no Lc value given.');
end

switch args.model
    case 'odijk'
        args.model = @(Lp, Lc, S, x) fOdijkInv(x, Lp, Lc, S);
        paramNames = {'Lp', 'Lc', 'S'};
    case 'odijk-f0'
        args.model = @(Lp, Lc, S, F0, x) fOdijkInv_f0(x, Lp, Lc, S, F0);
        paramNames = {'Lp', 'Lc', 'S', 'F0'};
    case 'odijk-d0'
        args.model = @(Lp, S, d0, x) fOdijkInv_d0(x, Lp, args.Lc, S, d0);
        paramNames = {'Lp', 'S', 'd0'};
    case 'odijk-d0-f0'
        args.model = @(Lp, S, d0, F0, x) fOdijkInv_d0_f0(x, Lp, args.Lc, S, d0, F0);
        paramNames = {'Lp', 'S', 'd0', 'F0'};
    case 'twlc'
        args.model = @(Lp, Lc, S, g0, g1, x) ftWLCInv(x, Lp, Lc, S, args.C, g0, g1, args.Fc);
        paramNames = {'Lp', 'Lc', 'S', 'g0', 'g1'};
    case 'twlc-f0'
        args.model = @(Lp, Lc, S, g0, g1, F0, x) ftWLCInv_f0(x, Lp, Lc, S, args.C, g0, g1, args.Fc, F0);
        paramNames = {'Lp', 'Lc', 'S', 'g0', 'g1', 'F0'};
    case 'twlc-lc-fixed'
        args.model = @(Lp, S, g0, g1, x) ftWLCInv(x, Lp, args.Lc, S, args.C, g0, g1, args.Fc);
        paramNames = {'Lp', 'S', 'g0', 'g1'};
    otherwise
        error('plotfdfit:InvalidArgument', 'Unknown model "%s".', args.model);
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  Make plot

switch args.style
    case 'normal'
        plotfun = @plot;
    case 'semilog'
        plotfun = @semilogy;
    case 'log'
        plotfun = @log;
end

if isempty(args.highlightSubset)
    plotfun(axesHandle, fd.d, fd.f, '.b');
    hold(axesHandle, 'on');
else
    plotfun(axesHandle, fd.d, fd.f, '.', 'Color', [0.5 0.5 0.5]);
    hold(axesHandle, 'on');
    plotfun(axesHandle, args.highlightSubset.d, args.highlightSubset.f, '.b');
end
switch mode
    case 'fitobject'
        makeFitPlot(fd.d, fitObject(fd.d));
        fParamList = [coeffnames(fitObject) num2cell(coeffvalues(fitObject))' num2cell(confint(fitObject))']';
        paramText = sprintf('%8.8s: %12g  (%12g -- %-12g)\n', fParamList{:});
    case 'custom'
        % Create the fit curve manually, by calling the model function with
        % the data and the fit parameters
        params = num2cell(paramVals);
        makeFitPlot(fd.d, args.model(params{:}, fd.d));
        fParamList = [paramNames' params']';
        paramText = sprintf('%8.8s: %12g\n', fParamList{:});
    otherwise
        error('Internal error: Invalid plot mode.');
end
text(0.05, 0.85, paramText, ...
        'Parent',      axesHandle, ...
        'Units',       'normalized', ...
        'FontName',    'FixedWidth', ...
        'Interpreter', 'none' ...
        );
hold(axesHandle, 'off');

xlim(axesHandle, [min(fd.d) max(fd.d)]);
ylim(axesHandle, [min(fd.f) max(fd.f)]);
xlabel(axesHandle, 'Distance ({\mu}m)');
ylabel(axesHandle, 'Force (pN)');
if ~isempty(fd.name)
    title(axesHandle, fd.name);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    function makeFitPlot(d, f)
        % To get a nice line, make sure the data is ordered by ascending 'd'
        sortVals = sortrows([d(:) f(:)]);
        plotfun(axesHandle, sortVals(:,1), sortVals(:,2), '-r');
    end

end

