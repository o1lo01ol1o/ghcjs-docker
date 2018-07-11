#Installs ghcjs 8.2
FROM haskell:8.2

RUN apt-get update \
    && apt-get -y install build-essential git zlib1g-dev libtinfo-dev libgmp-dev autoconf curl gnupg -yq \
    && curl -sL https://deb.nodesource.com/setup_8.x | bash \
    && apt-get install nodejs -yq

ENV PATH /root/.cabal/bin:$PATH

RUN cabal update && \
    cabal install cabal-install Cabal alex happy && \
    echo $PATH && which cabal && cabal --version

RUN git clone https://github.com/ghcjs/ghcjs.git && \
    cd ghcjs && \
    git checkout ghc-8.2 && \
    git submodule update --init --recursive && \
    ./utils/makePackages.sh

RUN cd ./ghcjs && \
    ./utils/makeSandbox.sh && \
    cabal install

ENV PATH /ghcjs/.cabal-sandbox/bin/:$PATH 

RUN ghcjs-boot

# RUN cd /opt && git clone https://github.com/transient-haskell/transient.git && cd transient && cabal new-build && cabal new-build --ghcjs

# RUN cd /opt && git clone https://github.com/transient-haskell/transient-universe.git && cd transient-universe && cabal new-build && cabal new-build --ghcjs

# RUN cd /opt && git clone https://github.com/transient-haskell/axiom.git && cd axiom && cabal new-build && cabal new-build --ghcjs
