clear; clc; close all;
% Example script to run all grain sizing functions in this suite. This is
% based on EBSD data input as an *.ANG file.
% MTEX can be either installed or be called in using the filepath options
% below

% %% Provide a path to MTEX
% fpth = pwd;
% mtex_pth = 'YOUR_MTEX_PATH';
% cd(mtex_pth)
% startup_mtex
% cd(fpth);

%% Specify File Names

% Path to files
pname = 'C:\Users\dmtim\OneDrive - University of Cincinnati\UC Research\Complete Projects\Grain Size Measurement\GS Meas Paper\Code\Data';
% Files to be imported
fname = [pname '/DNV4849_Thread2_Left.ang'];

%% Specify Crystal and Specimen Symmetries

% crystal symmetry
CS = {... 
  'notIndexed',...
  crystalSymmetry('432', [4 4 4], 'mineral', 'Face Centered Cubic', 'color', [0.53 0.81 0.98]),...
  crystalSymmetry('432', [5 5 5], 'mineral', 'Body Centered Cubic', 'color', [0.56 0.74 0.56])};

% plotting convention
setMTEXpref('xAxisDirection','east');
setMTEXpref('zAxisDirection','intoPlane');

%% Import the Data

% create an EBSD variable containing the data
ebsd_collected = EBSD.load(fname,CS,'interface','ang','convertEuler2SpatialReferenceFrame','setting 2');
ebsd = ebsd_collected('indexed');

% identify the grains
[grains,ebsd.grainId] = calcGrains(ebsd,'angle',5*degree);

%% Plot EBSD map [GS functions set to handle 1 phase, or 2 phase (FCC / BCC) structures]
figure;
% set the referece direction to Z
ipfKey = ipfTSLKey(ebsd('face centered cubic'), 'antipodal');
ipfKey.inversePoleFigureDirection = vector3d.Z;

% compute the colors
colors = ipfKey.orientation2color(ebsd('face centered cubic').orientations);
plot(ebsd('face centered cubic'), colors); hold on

% Plot IPF key if desired
figure;
plot(ipfKey)

%% Apply grain sizing & plot if desired
% Abrams
[G_Abrams, abramsIntCount, abrams_lbar, abramsCircumference_tot] = GrainSize_E112_Abrams(ebsd('face centered cubic'), 'PlotResults'); % will produce a plotted represention of the grain sizing function

% Hilliard
[G_Hilliard, hilliardIntCount, hilliard_lbar, circumference] = GrainSize_E112_Hilliard(ebsd('face centered cubic'), 'PlotResults');

% Heyn Mean Lineal Intercept
[G_HeynMLI, lbar, n_HeynMLI, intercept_lengths] = GrainSize_E112_HeynRandomLineMLI(ebsd('face centered cubic'), 'PlotResults');

% Saltikov
[G_Saltikov, N_A_Saltikov, N_Saltikov] = GrainSize_E112_SaltikovPlanimetric(ebsd('face centered cubic'), 'PlotResults', 'exclude_twins'); % will merge twins

% Jeffries
[G_Jeffries, N_A_Jeffries, N_Jeffries] = GrainSize_E112_JeffriesPlanimetric(ebsd('face centered cubic'), 'PlotResults', 'exclude_twins');

% ASTM E 2627 As Written
[G_E2627, Abar, n_E2627, N_A_measured, avg_px_per_grain_before_threshold, areas] = GrainSize_E2627_AsWritten(ebsd('face centered cubic'), 'PlotResults');

% Triple Point Count
[G_TPC, A_T, N_A] = GrainSize_TriplePointCount(ebsd('face centered cubic'), 'PlotResults');
