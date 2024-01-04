FROM docker.io/cruizba/ubuntu-dind

RUN apt-get update && apt-get install -y \
    build-essential \
    git    \
    neovim \
    podman 

# Get Rust & utilities
RUN curl https://sh.rustup.rs -sSf | bash -s -- -y
RUN $HOME/.cargo/bin/cargo install bat xcp git-delta dua-cli fd-find jql choose xh fnm broot procs rm-improved bottom ripgrep just exa tokei
RUN echo '. "$HOME/.cargo/env" ' >> ~/.zshrc && echo '. ~/.p10k.zsh' >> ~/.zshrc

# https://github.com/deluan/zsh-in-docker
RUN sh -c "$(wget -O- https://github.com/deluan/zsh-in-docker/releases/download/v1.1.5/zsh-in-docker.sh)" -- \
    -p git -p ssh-agent -p 'history-substring-search' \
    -p https://github.com/zsh-users/zsh-autosuggestions \
    -p https://github.com/zsh-users/zsh-completions \
    -p https://github.com/zdharma-continuum/fast-syntax-highlighting \
    -a 'bindkey "\$terminfo[kcuu1]" history-substring-search-up' \
    -a 'bindkey "\$terminfo[kcud1]" history-substring-search-down'

# https://forums.docker.com/t/docker-build-with-alpine-fails-to-run-apk/77838/3
COPY files/ /

# Need ssh keys mounted in /mnt/ssh-keys
RUN chmod +x /usr/bin/copy_ssh_keys_and_run

WORKDIR /root
CMD ["/usr/bin/zsh"]
