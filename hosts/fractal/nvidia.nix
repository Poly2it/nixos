{ config, ... }:
{
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;

    powerManagement.enable = true;

    powerManagement.finegrained = false;
    prime = {
      offload.enable = true;
      intelBusId = "PCI:0:1:0";
      nvidiaBusId = "PCI:3:0:0";
    };
    open = true;

    nvidiaSettings = false;

    package = config.boot.kernelPackages.nvidiaPackages.beta;
  };
}

