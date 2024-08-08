{ pkgs, ... }:

{
  chaotic.mesa-git = {
    enable = true;
    extraPackages = with pkgs; [ vaapiIntel amdvlk ];
  };

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [ 
      xorg.xf86videonv
      xorg.xf86videonouveau      
      vaapiVdpau 
      vulkan-tools
      vulkan-validation-layers
    ];
    package = (pkgs.mesa_git.override {
      galliumDrivers = [
        "nouveau"
        "swrast"
        "zink" 
      ];
      vulkanDrivers = [
        "swrast"
        "nouveau"
      ];
    }).drivers;
  };
}

