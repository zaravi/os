# Allow build scripts to be referenced without being copied into the final image
FROM scratch AS ctx
COPY build_files /

# Base Image
FROM quay.io/fedora-ostree-desktops/cosmic-atomic:42

### MODIFICATIONS
## make modifications desired in your image and install packages by modifying the build.sh script
## the following RUN directive does all the things required to run "build.sh" as recommended.

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/build.sh && \
    ostree container commit

RUN rpm-ostree install \
    https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
    https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
    https://copr.fedorainfracloud.org/coprs/atim/starship/repo/fedora-%OS_VERSION%/atim-starship-fedora-%OS_VERSION%.repo
    https://copr.fedorainfracloud.org/coprs/lihaohong/yazi/repo/fedora-%OS_VERSION%/lihaohong-yazi-fedora-%OS_VERSION%.repo

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
    just \

RUN systemctl enable rpm-ostreed-automatic.timer && \
    systemctl enable flatpak-system-update.timer
    
### LINTING
## Verify final image and contents are correct.
RUN bootc container lint
