# Use an RStudio image with the specific R version
FROM rocker/rstudio:4.3.0

# install necessary libraries
RUN apt-get update && apt-get install -y \
    # libgmp3-dev: Necessary for the 'gmp' R package
    # Dependency for high precision arithmetic (gmp package in R)
    libgmp3-dev \
    # libmpfr-dev: Necessary for the 'Rmpfr' R package
    # Dependency for multiple-precision floating-point computations (Rmpfr package in R)
    libmpfr-dev \
    # libcurl4-openssl-dev: Necessary for R packages like 'RCurl', 'httr'
    # Dependency for URL transfer library (RCurl, httr package in R)
    libcurl4-openssl-dev \
    # libblas-dev: Necessary for linear algebra operations
    # Dependency for Basic Linear Algebra Subprograms (used by packages like lme4)
    libblas-dev \
    # liblapack-dev: Necessary for linear algebra routines
    # Dependency for LAPACK (Linear Algebra PACKage) used in many R packages including lme4
    liblapack-dev \
    # build-essential: Provides compiler and related tools
    # Includes g++ (C++ compiler), make, and other utilities essential for building R packages
    build-essential \
    # For nlopr package
    cmake \
    # libssl-dev: Necessary for R packages like 'openssl', 'httr'
    # Dependency for Secure Sockets Layer toolkit (openssl, httr package in R)
    libssl-dev \
    # libxml2-dev: Necessary for the 'XML', 'xml2' R packages
    # Dependency for XML processing (XML, xml2 package in R)
    libxml2-dev \
    # libudunits2-dev: Necessary for the 'units' R package
    # Dependency for unit conversion (units package in R)
    libudunits2-dev \
    # libgdal-dev: Necessary for the 'rgdal' R package
    # Dependency for Geospatial Data Abstraction Library (rgdal package in R)
    libgdal-dev \
    # libproj-dev: Necessary for the 'rgdal', 'proj4' R packages
    # Dependency for Cartographic projections library (rgdal, proj4 package in R)
    libproj-dev \
    # libgeos-dev: Necessary for the 'rgeos' R package
    # Dependency for Geometry Engine - Open Source (rgeos package in R)
    libgeos-dev \
    # libcairo2-dev: Necessary for R packages like 'Cairo', 'grDevices'
    # Dependency for 2D graphics library (Cairo, grDevices package in R)
    libcairo2-dev \
    # libxt-dev: Necessary for R packages that need X11 graphics capabilities
    # Dependency for X11 toolkit intrinsics library (Graphics related packages in R)
    libxt-dev \
    # zlib1g-dev: Necessary for R packages like 'zlibbioc', 'Rsamtools'
    # Dependency for compression library (zlibbioc, Rsamtools package in R)
    zlib1g-dev \
    # libbz2-dev: Necessary for R packages that handle bzip2-compressed files
    # Dependency for bzip2 compression library (File compression related packages in R)
    libbz2-dev \
    # liblzma-dev: Necessary for R packages that handle LZMA/XZ compression
    # Dependency for LZMA compression library (File compression related packages in R)
    liblzma-dev \
    # libmagick++-dev: Necessary for the 'magick' R package
    # Dependency for image processing and 2D rendering (magick package in R)
    libmagick++-dev \
    && rm -rf /var/lib/apt/lists/*

# Copy the current directory contents into the container at /app
COPY . /home/rstudio

# Set the working directory
WORKDIR /home/rstudio

# install remotes
RUN R -e "install.packages('remotes',dependencies=TRUE, version = '2.4.2', upgrade = FALSE, repos='http://cran.rstudio.com/')"

# set renv version
ENV RENV_VERSION 1.0.3

# Install renv
RUN Rscript -e "remotes::install_github('rstudio/renv@${RENV_VERSION}')"

# Intall renv package
RUN Rscript -e "install.packages('renv')" 
RUN R -e "renv::consent(provided = TRUE)"

# Install any needed packages specified in renv.lock
RUN Rscript -e "renv::restore()"

# Expose the port RStudio will run on
EXPOSE 8585

# Define environment variables
ENV RENV_WATCHDOG_ENABLED FALSE
ENV NAME neural_bases_of_empathy
