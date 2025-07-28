# mtex-grain-size

*Functions for ASTM (and ISO[^1]) grain size characterization using the MTEX toolbox for MATLAB*

This software package provides the following functions:

* Measurement of $\bar{A}$ following the ASTM E 112 standard for the following planimetric methods
	 + Jeffries
	 + Saltikov
* Measurement of $\bar{l}$ following the ASTM E 112 standard for the following intercept methods
	+ Heyn
	+ Abrams
* Measurement of $N_A$ following the ASTM E 112 standard for the Hilliard method
* Measurement of $\bar{A}$ following the ASTM E 2627 (EBSD-specific) standard (with 100 px minimum grain size) [^2]
* Measurement of the as-large-as (ALA) grain size following ASTM E 930
* Measurement of the grain size using the Triple Point Count method described by Van der Voort [^3]
* Calculation of the field statistics following the reporting format described in ASTM E 112
* Conversion of $\bar{A}$m $\bar{l}$, and $N_A$ into ASTM $G$

# Citation

If use this software in a publication, please cite whichever of the following is most appropriate:

* D.M. Timberlake, K.S. Evans, and E.J. Payton: MTEX Grain Size Measurement, 2025. [Computer software]
* K.S. Evans, D.M. Timberlake, P. Tyagi, V.M. Miller, and E.J. Payton: Metallogr. Microstruct. Anal., 2024, vol. 13, pp 966–82. https://doi.org/10.1007/s13632-024-01124-8.
* D.M. Timberlake: MS Thesis, University of Cincinnati, 2025.

Users may also find the following related publications of interest:

* Y.A. Coutinho, S.C.K. Rooney, and E.J. Payton: Metall and Mat Trans A, 2017, vol. 48, pp 2375–95. https://doi.org/10.1007/s11661-017-4031-z.
* A.R.C. Gerlt, A.K. Criner, S.L. Semiatin, K.N. Wertz, and E.J. Payton: Metall Mater Trans A, 2021, vol. 52, pp 228–41. https://doi.org/10.1007/s11661-020-06072-w.
* A.R.C. Gerlt, A.K. Criner, L. Semiatin, and E.J. Payton: J Am Ceram Soc, 2019, vol. 102, pp 37–41. https://doi.org/10.1111/jace.15950.
* A.R.C. Gerlt, R.S. Picard, A.E. Saurber, A.K. Criner, S.L. Semiatin, and E.J. Payton: Metall and Mat Trans A, 2018, vol. 49, pp 4424–8. https://doi.org/10.1007/s11661-018-4808-8.

# Usage

This repository provides a collection of MATLAB scripts for grain size analysis, microstructure segmentation, and statistical evaluation of EBSD. The scripts are organized by function and naming convention for clarity.

* Functions that begin with `G_` calculate the ASTM $G$ value from the parameter described after the underscore, with `meanbarA` referring to $\bar{A}$, `meanintl` referring to $\bar{l}$, and `numgrain` referring to $N_A$.
* Functions that begin with `GrainSize` determine $\bar{A}$, $\bar{l}$, or $N_A$ (whichever is appropriate) according to the standard (when applicable) after the first underscore and then the method. Standards and method include:
	+ ASTM E 112
		- Abrams [`GrainSize_E112_Abrams`]
		- Heyn (mean lineal intercept) [`GrainSize_E112_HeynRandomLineMLI`]
		- Heyn (number of intercepts per line length) [`GrainSize_E112_HeynRandomLinePL`]
		- Hilliard [`GrainSize_E112_Hilliard`]
		- Jeffries [`GrainSize_E112_JeffriesPlanimetric`]
		- Saltikov [`GrainSize_E112_SaltikovPlanimetric`]
		- 
	+ ASTM E 930 []`GrainSize_E930_ALA`]
	+ ASTM E 2627
		- As written in the standard [`GrainSize_E2627_AsWritten`]
		- With an adjustable minimum grain size[^2] \(`GrainSize_E2627_CustomMinGS`\) 
	+ Triple Point Count[^3] \(`GrainSize_TriplePointCount`\)
* The function `FieldStats` follows Section 15 in ASTM E112 to calculate the mean values and standard errors on the mean for $\bar{A}$, $\bar{l}$, or $N_A$.

# Requirements

The code in this repository has been developed and tested on:

* MTEX Toolbox: Version 5.11.2
* MATLAB: R2024a

Modifications may be required to make it function for other versions of MATLAB or the MTEX Toolbox.

# Example

An example analysis script is provided in `Example.m`

# License

Copyright (C) 2025 Eric J Payton, D Meiyan Timberlake, and Kayla S Evans.

This software is licensed under GPL-3.0-or-later (GPLv3+).

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program. If not, see <https://www.gnu.org/licenses/>.

# References

[1] J. Friel, S. Wright, and S. Sitzman: Microsc Microanal, 2011, vol. 17, pp 838–9. https://doi.org/10.1017/S143192761100506X.
[2] A.Deal: E2627-Practice for Determining Average Grain Size Using Electron Backscatter Diffraction (EBSD) in Fully Recrystallized Polycrystalline Materials, ASTM International, West Conshohocken, PA, 2013. https://www.astm.org/rr-e04-1008.html 
[3] E04 Committee: Test Methods for Determining Average Grain Size, ASTM International. https://doi.org/10.1520/E0112-13R21.
[4] G.F. Vander Voort: Interlaboratory Study to Establish Precision Statements for ASTM E112, Tests for Determining the Average Grain Size, ASTM International, West Conshohocken, PA, 1992.
[5] E04 Committee: Practice for Determining Average Grain Size Using Electron Backscatter Diffraction (EBSD) in Fully Recrystallized Polycrystalline Materials, ASTM International, 2019. https://doi.org/10.1520/E2627-13R19.
[6] E04 Committee: Test Methods for Estimating the Largest Grain Observed in a Metallographic Section (ALA Grain Size), ASTM International, 2019. https://doi.org/10.1520/E0930-18.
[7] F. Bachmann, R. Hielscher, and H. Schaeben: Ultramicroscopy, 2011, vol. 111, pp 1720–33. https://doi.org/10.1016/j.ultramic.2011.08.002.
[8] F. Bachmann, R. Hielscher, and H. Schaeben: Solid State Phenom., 2010, vol. 160, pp 63–8. https://doi.org/10.4028/www.scientific.net/SSP.160.63.
[9] G.F. Vander Voort: Practical Metallography, 2014, vol. 51, pp 201–7. https://doi.org/10.3139/147.110291.


---


[^1]: ISO 13067 is similar to ASTM E 2627 measurements that follow either standard can be accomplished with the functions provided in this repository.
[^2]: For a critical analysis of the use of a minimum grain size threshold in this method, see Evans et al, Metall Microsc Analysis (2024).
[^3]: More information on this method can be found in G.F. Vander Voort: Practical Metallography, 2014, vol. 51, pp 201–7. For a comparison of this method with the more established methods in the ASTM standards, as well as an analysis of the strengths and weaknesses of triple point counts, see D.M. Timberlake, MS Thesis, University of Cincinnati, 2025.

