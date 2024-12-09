{ ... }:

{
  networking.networkmanager.enable = true;
  networking.firewall.allowedTCPPorts = [
    # I2P.
    4444
    4445
    4447
    7656
    7657
    7658
    7659
    7660
  ];
  services.i2pd = rec {
    enable = true;
    enableIPv6 = false;
    address = "127.0.0.1";
    bandwidth = 32768;
    proto.http = {
      enable = true;
      inherit address;
    };
    proto.httpProxy = {
      enable = true;
      inherit address;
      port = 4444;
    };
    proto.socksProxy = {
      enable = true;
      inherit address;
      port = 4447;
    };
  };
}

