# mtex-grain-size

*Functions for ASTM and ISO grain size characterization using the MTEX toolbox for MATLAB*

This software package provides the following functions:

* Measurement of $\bar{A} following the ASTM E 112 standard for the following planimetric methods
	 + Jeffries
	 + Saltikov
* Measurement of $\bar{l} following the ASTM E 112 standard for the following intercept methods
	+ Heyn
	+ Abrams
* Measurement of $N_A$ following the ASTM E 112 standard for the Hilliard method
* Measurement of $\bar{A} following the ASTM E 2627 (EBSD-specific) standard (with 100 px minimum grain size) ^[See Evans et al, Metall Microsc Analysis (2024) for a critical analysis of the use of a minimum grain size threshold]
* Measurement of the as-large-as (ALA) grain size following ASTM E 930
* Measurement of the grain size using the Triple Point Count method described by Van der Voort ^[See Timberlake (2025) for a critical analysis of this method]
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

# Requirements

The code in this repository has been developed and tested on:

* MTEX Toolbox: Version 5.11.2
* MATLAB: R2024a

Modifications may be required to make it function for other versions of MATLAB or the MTEX Toolbox.

# Example

Example.m

# License

Copyright (C) 2025 Eric J Payton, D Meiyan Timberlake, and Kayla S Evans.

This software is licensed under GPL-3.0-or-later (GPLv3+).

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program. If not, see <https://www.gnu.org/licenses/>.

