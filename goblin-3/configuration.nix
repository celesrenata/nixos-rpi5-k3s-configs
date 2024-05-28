# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:
{
  imports =
    [ # Include the results of the hardware scan.
      ./kubernetes.nix
      ./remote-build.nix
      ./hardware-configuration.nix
      ./iscsi.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = false;
  boot.loader.grub.device = "nodev";
  boot.loader.grub.efiSupport = true;
  boot.kernelPackages = (import (builtins.fetchTarball https://gitlab.com/vriska/nix-rpi5/-/archive/main.tar.gz)).legacyPackages.aarch64-linux.linuxPackages_rpi5;
  boot.kernelParams = [
    "cgroup_enable=cpuset" "cgroup_memory=1" "cgroup_enable=memory"
  ];
  boot.supportedFilesystems = [ "nfs" ];

  # Reset
  # services.etcd.enable = false;
  # KUBELET_PATH=$(mount | grep kubelet | cut -d' ' -f3);
  # sudo ${KUBELET_PATH:+umount $KUBELET_PATH}
  # sudo rm -rf /etc/rancher/{k3s,node};
  # sudo rm -rf /var/lib/{rancher/k3s,kubelet,longhorn,etcd,cni}
  ## services.etcd.enable = false;
  ## sudo rm -rf /var/lib/etcd/
  ### sudo reboot
  #### services.etcd.enable = true;
  ##### services.etcd.enable = true;
  
  # Power and Thermal.
  services.hardware.argonone.enable = true;
  services.auto-cpufreq.enable = true;
  services.auto-cpufreq.settings = {
    battery = {
      governor = "onDemand";
      turbo = "auto";
    };
    charger = {
      governor = "onDemand";
      turbo = "auto";
    };
  };

  # Networking
  networking.hostName = "goblin-3";
  services.rpcbind.enable = true;
  services.openssh.enable = true;
  services.openssh.settings.PermitRootLogin = "yes";
  networking.firewall.enable = false;
  nix.extraOptions = ''
    require-sigs = false
  '';
  time.timeZone = "America/Los_Angeles";

  # DistCC.
  services.distccd = {
    enable = true;
    allowedClients = [
      "192.168.42.0/25"
      "172.16.1.0/24"
      "192.168.0.0/25"
      "10.1.1.0/24"
    ];
    stats.enable = true;
    zeroconf = true;
  };

  # Virtualisation
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
      swtpm.enable = true;
      ovmf = {
        enable = true;
        packages = [(pkgs.OVMF.override {
          secureBoot = true;
          tpmSupport = true;
        }).fd];
      };
    };
  };
  programs.virt-manager.enable = true;
  virtualisation.docker.enable = true;
  virtualisation.docker.storageDriver = "btrfs";

  environment.systemPackages = with pkgs; [
    vim
    wpa_supplicant
    curl
    git
    nmap
    btop
    usbutils
    pciutils
    waypipe
    screen
    nfs-utils
    openiscsi
  ];

  # CA Certificate
  security.pki.certificateFiles = [
    /kubedata-remote/certs/home.crt
  ];
  # Storage Management
  nix.optimise.automatic = true;
  nix.optimise.dates = [ "03:45" ];
  services.openiscsi = {
    enable = true;
    name = "${config.networking.hostName}-initiatorhost"; 
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.celes = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" ]; # Enable ‘sudo’ for the user.
  };
  users.users.nixremote = {
    isNormalUser = true;
  };

  system.stateVersion = "24.05"; # Did you read the comment?

}

