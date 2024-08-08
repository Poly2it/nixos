{ ... }:

let virtualisation = {
  memorySize = 8192;
  cores = 8;
  qemu.options = [
    "-accel kvm"
    "-audio pa"
  ];
};
in
{
  virtualisation.vmVariant = {
    inherit virtualisation;
  };
  virtualisation.vmVariantWithBootLoader = {
    inherit virtualisation;
  };
}

