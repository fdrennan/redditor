FROM puckel/docker-airflow
USER root

RUN mkdir -p /usr/share/man/man1 && \
    apt-get update -y

RUN apt-get install unzip -y && \
    apt-get autoremove -y

RUN apt-get update -qq && apt-get install -y \
    ed \
		less \
		locales \
		vim-tiny \
		wget \
		ca-certificates \
		fonts-texgyre \
		git-core \
    libssl-dev \
    default-jdk \
    libcurl4-openssl-dev \
    libxml2-dev \
		libpq-dev -y

RUN rm -rf /var/lib/apt/lists/*

RUN echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
	&& locale-gen en_US.utf8 \
	&& /usr/sbin/update-locale LANG=en_US.UTF-8

ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8

## Now install R and littler, and create a link for littler in /usr/local/bin
RUN apt-get update
RUN apt-get install -y --no-install-recommends \
		littler \
    r-cran-littler \
		r-base \
		r-base-dev \
		r-recommended

RUN R -e "install.packages('devtools')"
# RUN R -e "install.packages('tidyverse')"
# RUN R -e "install.packages('DBI')"
