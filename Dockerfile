FROM docker.io/cruizba/ubuntu-dind

RUN apt-get update && apt-get install -y \
    build-essential \
    git    \
    neovim \
    podman 

# Get Rust & utilities
RUN curl https://sh.rustup.rs -sSf | bash -s -- -y
RUN $HOME/.cargo/bin/cargo install bat git-delta fd-find jql fnm broot procs bottom ripgrep just exa
RUN echo '. "$HOME/.cargo/env" ' >> ~/.zshrc && echo '. ~/.p10k.zsh' >> ~/.zshrc

# https://github.com/deluan/zsh-in-docker
RUN sh -c "$(curl https://github.com/deluan/zsh-in-docker/releases/download/v1.1.5/zsh-in-docker.sh)" -- \
    -p git -p ssh-agent -p 'history-substring-search' \
    -p https://github.com/zsh-users/zsh-autosuggestions \
    -p https://github.com/zsh-users/zsh-completions \
    -p https://github.com/zdharma-continuum/fast-syntax-highlighting \
    -a 'bindkey "\$terminfo[kcuu1]" history-substring-search-up' \
    -a 'bindkey "\$terminfo[kcud1]" history-substring-search-down'

# https://forums.docker.com/t/docker-build-with-alpine-fails-to-run-apk/77838/3
COPY files/ /

# Need ssh keys mounted in /mnt/ssh-keys
RUN chmod +x /usr/local/bin/copy_ssh_keys_and_run

WORKDIR /root
CMD ["/usr/bin/zsh"]
