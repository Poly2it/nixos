{ ... }:

{
  hardware.graphics = {
    enable = true;
  };

  environment.variables = {
    MESA_GL_VERSION_OVERRIDE="3.3";
  };
}

