FROM perl:5.24

COPY cpanfile cpanfile.snapshot /code/
WORKDIR /code

ENV PERL_CARTON_PATH=/carton
RUN cpanm Carton && \
    useradd -m mojo -g users && \
    mkdir /carton && \
    carton install

COPY . /code/
RUN chown -R mojo:users /code /carton
VOLUME /carton

USER mojo:users


