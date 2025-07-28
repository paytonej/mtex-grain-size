clear; clc; close all;
% Script to compute average grain size using GrainSize functions and 
% applies FieldStats to Triple Point Count (TPC) on five sets of EBSD data.
% Based on EBSD data input as *.CTF files.
% Requires MTEX toolbox.

%% Set Up File Paths
currentScriptPath = fileparts(mfilename('fullpath'));
pname = fullfile(currentScriptPath, 'example_data');

numScans = 5;

% Preallocate arrays
G_TPC_all     = zeros(numScans,1);
N_A_TPC_all   = zeros(numScans,1);
G_Abrams_all  = zeros(numScans,1);
G_HeynMLI_all = zeros(numScans,1);
G_HeynPL_all  = zeros(numScans,1);
G_Hilliard_all= zeros(numScans,1);
G_Jeffries_all= zeros(numScans,1);
G_Saltikov_all= zeros(numScans,1);
G_E930_all    = zeros(numScans,1);
G_E2627_all   = zeros(numScans,1);

for i = 1:numScans
    fname = fullfile(pname, ['Example_Data' num2str(i) '.ctf']);
    ebsd_collected = EBSD.load(fname, 'interface', 'ctf');
    ebsd = ebsd_collected('indexed');
    
    %----Grain Size Methods
    % Triple Point Count (TPC)
    [G_TPC, A_T, N_A_TPC] = GrainSize_TriplePointCount(ebsd);
    G_TPC_all(i) = G_TPC;
    N_A_TPC_all(i) = N_A_TPC;
    % Abrams E112
    [G_Abrams, ~, ~, ~] = GrainSize_E112_Abrams(ebsd);
    % Heyn Random Line MLI
    [G_HeynMLI, ~, ~, ~] = GrainSize_E112_HeynRandomLineMLI(ebsd);
    % Heyn Random Line PL
    [G_HeynPL, ~, ~, ~, ~] = GrainSize_E112_HeynRandomLinePL(ebsd);
    % Hilliard
    [G_Hilliard, ~, ~, ~] = GrainSize_E112_Hilliard(ebsd);
    % Jeffries Planimetric
    [G_Jeffries, ~, ~] = GrainSize_E112_JeffriesPlanimetric(ebsd);
    % Saltikov Planimetric
    [G_Saltikov, ~, ~] = GrainSize_E112_SaltikovPlanimetric(ebsd);
    % ALA Method (ASTM E930)
    G2 = G_TPC; % Reference average G number
    [G_ALA, ~] = GrainSize_E930_ALA(ebsd, G2);
    % Area-Based (E2627)
    min_px = 100; % Recommended threshold
    [G_E2627, ~, ~, ~, ~, ~] = GrainSize_E2627_CustomMinGS(ebsd, min_px);
    
    %----Store results
    G_Abrams_all(i) = G_Abrams;
    G_HeynMLI_all(i) = G_HeynMLI;
    G_HeynPL_all(i) = G_HeynPL;
    G_Hilliard_all(i) = G_Hilliard;
    G_Jeffries_all(i) = G_Jeffries;
    G_Saltikov_all(i) = G_Saltikov;
    G_E930_all(i) = G_ALA;
    G_E2627_all(i) = G_E2627;
end

%% Table: All Grain Size Methods
grainSizeTable = table((1:numScans)', G_TPC_all, G_Abrams_all, G_HeynMLI_all, ...
    G_HeynPL_all, G_Hilliard_all, G_Jeffries_all, G_Saltikov_all, ...
    G_E930_all, G_E2627_all, ...
    'VariableNames', {'Scan', 'TPC', 'Abrams', 'HeynMLI', 'HeynPL', ...
    'Hilliard', 'Jeffries', 'Saltikov', 'ALA_E930', 'E2627'});

disp(grainSizeTable);

%% Mean Grain Size Summary
fprintf('\nMean Grain Size (µm) from each method across %d scans:\n', numScans);
fprintf('TPC       : %.4f\n', mean(G_TPC_all));
fprintf('Abrams    : %.4f\n', mean(G_Abrams_all));
fprintf('Heyn MLI  : %.4f\n', mean(G_HeynMLI_all));
fprintf('Heyn PL   : %.4f\n', mean(G_HeynPL_all));
fprintf('Hilliard  : %.4f\n', mean(G_Hilliard_all));
fprintf('Jeffries  : %.4f\n', mean(G_Jeffries_all));
fprintf('Saltikov  : %.4f\n', mean(G_Saltikov_all));
fprintf('ALA (E930): %.4f\n', mean(G_E930_all));
fprintf('E2627     : %.4f\n', mean(G_E2627_all));

%% Field Statistics: Only on TPC
[xbar, s, CI95, RApct] = GrainSize_FieldStats(N_A_TPC_all);
fprintf('\nField Stats (TPC method):\n');
fprintf('Mean N_A : %.4f grains/µm²\n', xbar);
fprintf('Std Dev  : %.4f\n', s);
fprintf('95%% CI   : %.4f\n', CI95);
fprintf('RA%%      : %.4f%%\n', RApct);