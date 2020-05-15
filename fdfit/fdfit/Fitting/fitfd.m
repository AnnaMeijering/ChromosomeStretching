function [varargout] = fitfd(fd, varargin)
% FITFD Easy fitting of DNA force-extension curves.
%
% Based on least-squares fitting of the inverse of the eWLC/tWLC functions
% (i.e., expressing F as a function of d).
%
% SYNTAX:
% fitobject = fitfd(fd);
%   Most basic syntax; returns a cfit object (see MATLAB's 'fit' function).
% [fitobject, gof, output] = fitfd(fd);
%   Optionally, additionanl fit information can be returned (see MATLAB's
%   'fit' function).
% [fits] = fitfd(fdc);
%   Performs a fit for all FdData objects in an FdDataCollection.
%   A struct array with fit results is returned.
% fitfd(fd, 'key', value, ...);
%   Additional key-value pair arguments can be given; see below.
% fitfd(fd, 'flag', ...);
%   Additional flag arguments can be given; see below.
%
% INPUT:
% fd = FdData object. Note that when fitting the Odijk eWLC, the data is
%       automatically trimmed to only include forces up to 30 pN.
%       (See also the 'noTrim' flag argument below).
%
% KEY-VALUE PAIR ARGUMENTS:
% model = which model to use for fitting; available models are:
%         - 'odijk': Odijk eWLC;
%         - 'odijk-f0': Odijk eWLC, including a force offset (default);
%         - 'odijk-d0': Odijk eWLC, including a distance offset;
%         - 'odijk-d0-f0': Odijk eWLC, including a force and a distance
%           offset. For unprocessed F,d curves, this will usually be the
%           one you want.
%         - 'twlc': twistable WLC (with 'Fc' and 'C' fixed; see below);
%         - 'twlc-lc-fixed': twistable WLC, but with the "Lc" parameter
%           (contour length) kept fixed to a given value.
%         - 'twlc-f0': twistable WLC, with a force offset.
% startParams = vector with starting values for the fit parameters.
%       Depending on the model chosen, this will be a vector with values for:
%       - odijk:            [Lp Lc S]
%       - odijk-f0:         [Lp Lc S F0]
%       - odijk-d0:         [Lp S d0]
%       - odijk-d0-f0:      [Lp S d0 F0]
%       - twlc:             [Lp Lc S g0 g1]
%       - twlc-lc-fixed:    [Lp S g0 g1]
%       - twlc-f0:          [Lp Lc S g0 g1 F0]
% Lc = contour length (in um); required for the models 'odijk-d0', and
%       'odijk-d0-f0'.
% lBounds = lower bounds for the fit parameters. Same format as "startParams".
% uBounds = upper bounds for the fit parameters. Same format as "startParams".
% Fc = (only for the 'twlc' models) critical force (default: 30.6 pN).
%       This is the force at which the twist-stretch coupling changes from
%       a constant to a linear function (g0 + g1 F).
% C =  (only for the 'twlc' models) twist rigidity (default: 440 pN nm^2).
%
% FLAG ARGUMENTS:
% makePlot = automatically create a plot of the resulting fit.
% noTrim = when fitting the Odijk eWLC, do *not* automatically trim the data
%       to only include only forces up to 30 pN.
% skipFullFitInfo = only valid when fitting an FdDataCollection. When set, the
%       results struct array returned does not contain the fit information
%       fields "fd", "fitobject", "gof" and "output".
%       This is a bit of a hack, and seems to be necessary to prevent memory
%       corruption in older version of MATLAB when fitting an FdDataCollection.
%
% OUTPUT:
% fitobject = cfit object as returned by MATLAB's 'fit' function.
%       Depending on the model chosen (see the 'model' key-value pair argument),
%       the following fit coefficients/parameters are available:
%       - Lp: persistence length (nm)
%       - Lc: contour length (um)
%       - S: stretching modulus (pN)
%       - g0, g1: twist-stretch coupling constants (in pN*nm and nm,
%         respectively)
%       - F0: force offset (pN)
% gof = gof structure as returned by MATLAB's 'fit' function.
% output = output structure as returned by MATLAB's 'fit' function.
% fits = when fitting all items in an FdDataCollection, a struct array is
%       returned, where each item contains the fit parameters found.
%       Unless the 'skipFullFitInfo' flag is set, the following fields are also
%       available:
%       - fd: the FdData object fitted
%       - fitobject: see 'fitobject' output above
%       - gof: see 'fitobject' output above
%       - output: see 'fitobject' output above
%
% TODO:
% - Include FJC model
%
% SEE ALSO:
% fit, cfit, fOdijkInv, ftWLCInv

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Parse input

defaultArgs = struct(...
                      'model',              'odijk-f0' ...
                    , 'startParams',        [] ...
                    , 'lBounds',            [] ...
                    , 'uBounds',            [] ...
                    , 'Lc',                 [] ...
                    , 'Fc',                 30.6 ...
                    , 'C',                  440 ...
                    , 'makePlot',           false ...
                    , 'noTrim',             false ...
                    , 'skipFullFitInfo',    false ...
                    );

args = parseArgs(varargin, defaultArgs, {'makePlot','noTrim','skipFullFitInfo'});

if any(strcmp(args.model, {'odijk-d0','odijk-d0-f0','odijk-lc-fixed'})) && isempty(args.Lc)
    error('fitfd:LcMissing', 'Fit requested with Lc fixed, but no Lc value given.');
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Process FdDataCollection if given

if isa(fd, 'FdDataCollection')
    % Pre-allocate results.
    res = struct('fd', []);
    res(fd.length).fd = [];

    % Do the fits.
    parfor i = 1:fd.length
        [f,g,o] = fitfd(fd.items{i}, varargin{:}); %#ok

        % Store fit parameters directly.
        cn = coeffnames(f);
        for k = 1:length(cn)
            res(i).(cn{k}) = f.(cn{k});
        end

        % Store more detailed fit information, too, if requested.
        if ~args.skipFullFitInfo %#ok
            res(i).fd        = fd.items{i};
            res(i).fitobject = f;
            res(i).gof       = g;
            res(i).output    = o;
        end
    end
    if args.skipFullFitInfo
        res = rmfield(res, 'fd');
    end
    varargout = {res};
    return
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Process & validate input

% Process model choice.
switch args.model
    case 'odijk'
        nParams = 3;
        ftype = fittype(@(Lp, Lc, S, x) fOdijkInv(x, Lp, Lc, S));
        hasF0 = false;
    case 'odijk-lc-fixed'
        nParams = 2;
        ftype = fittype(@(Lp, S, x) fOdijkInv(x, Lp, args.Lc, S));
        hasF0 = false;
    case 'odijk-f0'
        nParams = 4;
        ftype = fittype(@(Lp, Lc, S, F0, x) fOdijkInv_f0(x, Lp, Lc, S, F0));
        hasF0 = true;
    case 'odijk-d0'
        nParams = 3;
        ftype = fittype(@(Lp, S, d0, x) fOdijkInv_d0(x, Lp, args.Lc, S, d0));
        hasF0 = false;
    case 'odijk-d0-f0'
        nParams = 4;
        ftype = fittype(@(Lp, S, d0, F0, x) fOdijkInv_d0_f0(x, Lp, args.Lc, S, d0, F0));
        hasF0 = true;
    case 'twlc'
        nParams = 5;
        ftype = fittype(@(Lp, Lc, S, g0, g1, x) ftWLCInv(x, Lp, Lc, S, args.C, g0, g1, args.Fc));
        hasF0 = false;
    case 'twlc-lc-fixed'
        nParams = 4;
        ftype = fittype(@(Lp, S, g0, g1, x) ftWLCInv(x, Lp, args.Lc, S, args.C, g0, g1, args.Fc));
        hasF0 = false;
    case 'twlc-f0'
        nParams = 6;
        ftype = fittype(@(Lp, Lc, S, g0, g1, F0, x) ftWLCInv_f0(x, Lp, Lc, S, args.C, g0, g1, args.Fc, F0));
        hasF0 = true;
    case 'network'
        nParams = 5;
        ftype = fittype(@(Lp, Lc, S, Fscale, F0, x) fOdijkInv_network(x, Lp, Lc, S, Fscale, F0));
        hasF0 = true;
    case 'network1'
        nParams = 6;
        ftype = fittype(@(Lp, Lc, S, Fscale, Ndna, F0, x) fOdijkInv_network1(x, Lp, Lc, S, Fscale, Ndna, F0));
        hasF0 = true;
    otherwise
        error('fitfd:UnknownModel', 'Unknown fit model "%s".', args.model);
end

if any(strcmp(args.model, {'twlc','twlc-lc-fixed','twlc-f0'})) && max(fd.f) < args.Fc
    % Error if fitting tWLC with too little data.
    error('fitfd:NotEnoughForceData', ...
          'Fitting tWLC with dataset that does not include any forces above Fc (Fc = %g pN); result will be ill-defined.', args.Fc);
end

% Automatically set starting point, if necessary.
if isempty(args.startParams)
    switch args.model
        case {'odijk','odijk-f0'}
            args.startParams = [50 16.5 1500];
        case {'network'}
            args.startParams = [5 3 1500 0.000001];
        case {'network1'}
            args.startParams = [5 3 1500 0.000001 1];
        case 'odijk-lc-fixed'
            args.startParams = [50 1500];
        case {'odijk-d0','odijk-d0-f0'}
            args.startParams = [50 1500 0];
        case {'twlc','twlc-f0'}
            args.startParams = [50 16.5 1500 -637 17];
        case {'twlc-lc-fixed'}
            args.startParams = [50 1500 -637 17];
    end
end

% Automatically add starting point/bounds for F0, if necessary.
if hasF0
    if numel(args.startParams) == (nParams-1)
        args.startParams = [args.startParams 0];
    end
    if numel(args.lBounds) == (nParams-1)
        args.lBounds = [args.lBounds -60];
    end
    if numel(args.uBounds) == (nParams-1)
        args.uBounds = [args.uBounds 60];
    end
end

% Sanity-check arguments.
if ~isempty(args.startParams) && numel(args.startParams) ~= nParams
    error('Invalid argument "startParams": vector with %d starting values expected', nParams);
end
if ~isempty(args.lBounds) && numel(args.lBounds) ~= nParams
    error('Invalid argument "lBounds": vector with %d bound values expected', nParams);
end
if ~isempty(args.uBounds) && numel(args.uBounds) ~= nParams
    error('Invalid argument "uBounds": vector with %d bound values expected', nParams);
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Do fit

% If fitting Odijk eWLC, only use forces up to 30 pN (unless this behavior has
% been disabled explicitly).
fd_fit = fd;
if any(strcmp(args.model, {'odijk','odijk-lc-fixed','odijk-f0','odijk-d0','odijk-d0-f0'})) && ~args.noTrim
    disp('Only using data up to 30 pN (use the "noTrim" flag to avoid this).');
    fd_fit = fd.subset('f', [-Inf 30]);
end

% Do actual fit.
fopt = fitoptions(ftype);
fopt.StartPoint = args.startParams;
fopt.Lower      = args.lBounds;
fopt.Upper      = args.uBounds;
fopt.MaxIter    = 120;

[fitobject, gof, output] = fit(fd_fit.d(:), fd_fit.f(:), ftype, fopt);

% Make plot, if requested.
if args.makePlot
    plotfdfit(fd, fitobject);
end

% Output results.
varargout = {fitobject, gof, output};

end

