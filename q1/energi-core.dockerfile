##############################
#    ::::::::::::::::::::    #
# :::: Energi Core Node :::: #
#    ::::::::::::::::::::    #
##############################

# Use TLS for longer depedency support
FROM ubuntu:22.04

# Install required library
RUN  apt-get update --fix-missing && apt install -y wget
                    
# Download Codebase
ENV DL_URL="https://s3-us-west-2.amazonaws.com/download.energi.software"
ENV DL_VERSION="v1.1.7"
ENV DL_ARCH="amd64"

RUN wget  ${DL_URL}/releases/energi3/${DL_VERSION}/energi3-${DL_VERSION}-linux-${DL_ARCH}-alltools.tgz
RUN wget  ${DL_URL}/releases/energi3/${DL_VERSION}/SHA256SUMS

# Verify the downloaded tarball
RUN sha256sum -c --ignore-missing SHA256SUMS energi3-${DL_VERSION}-linux-${DL_ARCH}-alltools.tgz | \
     if grep -q "OK"; then \
        tar -xzvf energi3-${DL_VERSION}-linux-${DL_ARCH}-alltools.tgz; \
    else \
        echo "(SHASUM not matched)"; \
    fi

# Select the binary to execute runtime
ARG BINARY
ENV BINARY_LIST="rlpdump evm abigen clef energi3 bootnode"

RUN if echo "${BINARY_LIST}" | grep -qw "${BINARY}"; then \
        # Copy needed binary, removed other files
        cp energi3-${DL_VERSION}-linux-${DL_ARCH}/bin/${BINARY} .; \
        rm -rf energi3-${DL_VERSION}-linux-${DL_ARCH}/ ; \
    else \
        echo List of binaries: "$BINARY_LIST"; \
    fi

RUN chmod +x $BINARY

##############################
# OS build - CVE
##############################

# * ubuntu/krb5 1.19.2-2ubuntu0.3
#       CVE-2024-26462 - no fix yet
#       CVE-2024-26461 - no fix yet
#       CVE-2024-26458 - no fix yet

# * ubuntu/gnutls28 3.7.3-4ubuntu1.4
#       CVE-2024-28835 - no fix yet
#       CVE-2024-28834 - no fix yet⁠

# * ubuntu/xz-utils 5.2.5-2ubuntu1
#       CVE-2020-22916 - no fix yet

# * ubuntu/util-linux 2.37.2-4ubuntu3
#       CVE-2024-28085
RUN apt install -y util-linux=2.37.2-4ubuntu3.3

# * ubuntu/libgcrypt20 1.9.4-3ubuntu3
#       CVE-2024-2236 - no fix yet

# * ubuntu/bash 5.1-6ubuntu1
#       CVE-2022-3715
RUN apt install -y bash=5.1-6ubuntu1.1

# * ubuntu/ncurses 6.3-2ubuntu0.1
#       CVE-2023-50495 - no fix yet
#       CVE-2023-45918 - no fix yet

# * ubuntu/systemd 249.11-0ubuntu3.12
#       CVE-2023-7008 - no fix yet

# * ubuntu/shadow 1:4.8.1-2ubuntu2.2
#       CVE-2023-29383 - no fix yet

# * ubuntu/pcre3 2:8.39-13ubuntu0.22.04.1
#       CVE-2017-11164 - no fix yet

# * ubuntu/libzstd 1.4.8+dfsg-3build1
#       CVE-2022-4899 - no fix yet

# * ubuntu/gnupg2 2.2.27-3ubuntu2.1
#       CVE-2022-3219 - no fix yet

# * ubuntu/glibc 2.35-0ubuntu3.6
#       CVE-2016-20013 - no fix yet

# * ubuntu/gcc-12 12.3.0-1ubuntu1~22.04
#       CVE-2022-27943 - no fix yet

# * ubuntu/coreutils 8.32-4.1ubuntu1.1
#       CVE-2016-2781 - no fix yet


##############################
# Software build - CVE
##############################

# * golang.org/x/net 0.10.0
#       CVE-2023-39325 - fix in 0.17.0
#       CVE-2023-44487
#       CVE-2023-3978

# * stdlib 1.21.4
#       CVE-2023-45283 - fix in 1.21.5 and 1.20.12

# * github.com/prometheus/client_golang 1.11.0
#       CVE-2022-21698 - fix in 1.11.1

# * google.golang.org/protobuf 1.27.1
#       CVE-2024-24786 - fix in 1.33.0

# * golang.org/x/crypto 0.16.0
#       CVE-2023-48795 - fix in 0.17.0


# Initiate Runtime
ARG PARAM=""
ENTRYPOINT ["/bin/sh", "-c", "./${BINARY} ${PARAM}"]
