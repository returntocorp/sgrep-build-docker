FROM ocaml/opam2:debian-stable
USER root
RUN apt-get update \
    && apt-get install -y --no-install-recommends m4 perl wget swi-prolog mercurial \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

USER opam
WORKDIR /home/opam/opam-repository
# the ocaml-migrate-parsetree is a temporary fix for an issue in OPAM
# see https://github.com/ocaml/opam-repository/issues/15281
RUN git pull && \
  opam update && opam switch 4.07 && \
  opam install ocaml-migrate-parsetree ocaml-migrate-parsetree.1.3.1 && \
  opam install pfff
WORKDIR /home/opam/
RUN wget https://github.com/aryx/pfff/archive/0.39.4.tar.gz -O pfff.tgz
RUN mkdir pfff; tar xvfz pfff.tgz -C pfff --strip-components 1
RUN eval $(opam env); cd pfff; ./configure -novisual; make depend