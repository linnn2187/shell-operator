From flant/shell-operator:latest 
ADD hooks /hooks

RUN ( apk --no-cache add --virtual build-dependencies curl && \
      apk --no-cache add git && \
      apk --no-cache add tshark && \
      apk --no-cache add tcpdump \
    )

RUN ( mkdir /lib64 && \
      ln -s /lib/libc.musl-x86_64.so.1 /lib64/ld-linux-x86-64.so.2 \
    )

#krew
RUN ( set -x; cd "$(mktemp -d)" && \
      OS="$(uname | tr '[:upper:]' '[:lower:]')" && \
      ARCH="$(uname -m | sed -e 's/x86_64/amd64/' -e 's/\(arm\)\(64\)\?.*/\1\2/' -e 's/aarch64$/arm64/')" && \
      KREW="krew-${OS}_${ARCH}" && \
      curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/download/v0.4.1/krew.tar.gz" && \
      tar zxvf krew.tar.gz && \
      ./"${KREW}" install krew \
    )
RUN echo 'export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"' >> ~/.bashrc
ENV PATH=/root/.krew/bin:$PATH
RUN kubectl krew install sniff

#kubeconfig
RUN mkdir /etc/kubernetes
