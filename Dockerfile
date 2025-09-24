FROM python

#Required for tzdata
ENV TZ=America/Vancouver
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Install dependencies
RUN apt-get update && apt-get upgrade -y && apt-get install -y git unzip curl build-essential cmake ninja-build libx11-dev libxcursor-dev libxi-dev libgl1-mesa-dev libfontconfig1-dev clang libxrandr-dev

COPY --chmod=755 compile.sh /compile

VOLUME /output

WORKDIR /work

ENTRYPOINT ["/compile"]
