FROM scratch AS ctx
COPY build_files /

FROM quay.io/fedora-ostree-desktops/cosmic-atomic:42

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/build.sh && \
    ostree container commit

RUN rpm-ostree install \
    https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
    https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

RUN curl -Lo /etc/yum.repos.d/starship.repo \
        https://copr.fedorainfracloud.org/coprs/atim/starship/repo/fedora-$(rpm -E %fedora)/atim-starship-fedora-$(rpm -E %fedora).repo && \
    curl -Lo /etc/yum.repos.d/yazi.repo \
        https://copr.fedorainfracloud.org/coprs/lihaohong/yazi/repo/fedora-$(rpm -E %fedora)/lihaohong-yazi-fedora-$(rpm -E %fedora).repo
        
RUN rpm-ostree install \
    distrobox \
    corectrl \
    alacritty \
    nu \
    dash \
    starship \
    atuin \
    zoxide \
    helix \
    yazi \
    btop \
    qemu \
    edk2-ovmf \ 
    virt-manager \
    virt-viewer \
    waydroid \
    just

RUN rpm-ostree install && \
    systemctl enable syncthing@.service
    
RUN bootc container lint
