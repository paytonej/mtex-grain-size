clear; clc; close all;
% Combined script to run all grain sizing methods on five EBSD scans,
% saving results in a table and computing statistics on TPC method.
% Based on EBSD data input as *.CTF files.
% Requires MTEX toolbox.

%% Set Up File Paths
currentScriptPath = fileparts(mfilename('fullpath'));
pname = fullfile(currentScriptPath, 'example data');

% Preallocate arrays to store results
numScans = 5;
G_Abrams_all = zeros(numScans,1);
G_Hilliard_all = zeros(numScans,1);
G_HeynMLI_all = zeros(numScans,1);
G_Saltikov_all = zeros(numScans,1);
G_Jeffries_all = zeros(numScans,1);
G_E2627_all = zeros(numScans,1);
G_TPC_all = zeros(numScans,1);
N_A_all = zeros(numScans,1);  % For stats (Triple Point Count grain density)

% Loop over all scans
for i = 1:numScans
    fname = fullfile(pname, ['Example_Data' num2str(i) '.ctf']);
    ebsd_collected = EBSD.load(fname, 'interface', 'ctf');
    ebsd = ebsd_collected('indexed');

    [grains, ebsd.grainId] = calcGrains(ebsd, 'angle', 5*degree);

    % Apply all grain sizing methods (no plots)
    [G_Abrams, ~, ~, ~] = GrainSize_E112_Abrams(ebsd);
    [G_Hilliard, ~, ~, ~] = GrainSize_E112_Hilliard(ebsd);
    [G_HeynMLI, ~, ~, ~] = GrainSize_E112_HeynRandomLineMLI(ebsd);
    [G_Saltikov, ~, ~] = GrainSize_E112_SaltikovPlanimetric(ebsd);
    [G_Jeffries, ~, ~] = GrainSize_E112_JeffriesPlanimetric(ebsd);
    [G_E2627, ~, ~, ~, ~, ~] = GrainSize_E2627_AsWritten(ebsd);
    [G_TPC, A_T, N_A] = GrainSize_TriplePointCount(ebsd);

    % Store results
    G_Abrams_all(i) = G_Abrams;
    G_Hilliard_all(i) = G_Hilliard;
    G_HeynMLI_all(i) = G_HeynMLI;
    G_Saltikov_all(i) = G_Saltikov;
    G_Jeffries_all(i) = G_Jeffries;
    G_E2627_all(i) = G_E2627;
    G_TPC_all(i) = G_TPC;
    N_A_all(i) = N_A; % For stats
end

% Table combining all grain size results
grainSizeTable = table((1:numScans)', G_Abrams_all, G_Hilliard_all, G_HeynMLI_all, ...
    G_Saltikov_all, G_Jeffries_all, G_E2627_all, G_TPC_all, N_A_all, ...
    'VariableNames', {'ScanNumber', 'Abrams', 'Hilliard', 'HeynMLI', ...
    'Saltikov', 'Jeffries', 'E2627', 'TPC_GrainSize', 'TPC_N_A'});

%% Compute Field Statistics on TPC Grain Density (N_A)
[xbar, s, CI95, RApct] = GrainSize_FieldStats(N_A_all);