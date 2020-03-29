FROM swift:5.2
LABEL Description="EvolutionLinux (swift) running on Docker"
RUN apt-get update \
    && apt-get install -y openssl libssl-dev uuid-dev sqlite3 libsqlite3-dev --no-install-recommends
ADD . /app
WORKDIR /app
RUN mkdir files
RUN swift build --configuration release
ENTRYPOINT .build/release/EvolutionLinux $(pwd)/files/