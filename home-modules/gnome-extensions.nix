{ lib, pkgs, ... }:

{
  home.packages = with pkgs.gnomeExtensions; [
    rounded-window-corners-reborn
    weather-oclock
    vitals
    blur-my-shell
  ];

  dconf.settings = with lib.hm.gvariant; {
    "org/gnome/shell" = {
      disable-user-extensions = false;

      enabled-extensions = [
        "rounded-window-corners@fxgn"
        "weatheroclock@CleoMenezesJr.github.io"
        "Vitals@CoreCoding.com"
        "blur-my-shell@aunetx"
      ];
    };

    "org/gnome/shell/extensions/rounded-window-corners-reborn" = {
      tweak-kitty-terminal = false;
    };

    "org/gnome/shell/extensions/vitals" = {
      hot-sensors = [ "_memory_usage_" "_processor_usage_" "__network-rx_max__" "_temperature_processor_0_" ];
      show-fan = false;
      show-storage = false;
      show-system = false;
      show-voltage = false;
      use-higher-precision = false;
    };

    "org/gnome/shell/extensions/blur-my-shell" =
    let
      mkPipelineProperty = key: value: (mkDictionaryEntry [ key (mkVariant value) ]);
      mkPipeline = pipeline: { name, effects }: (mkDictionaryEntry [ pipeline [
        (mkPipelineProperty "name" name)
        (mkPipelineProperty "effects" (map mkPipelineEffect effects))
      ]]);
      mkPipelineEffect = { type, id, params }: (mkVariant [
        (mkPipelineProperty "type" type)
        (mkPipelineProperty "id" id)
        (mkPipelineProperty "params" (mkPipelineEffectParams params))
      ]);
      mkPipelineEffectParams = params: (builtins.attrValues (builtins.mapAttrs mkPipelineProperty params));
    in {
      pipelines = [
        (mkPipeline "pipeline_default" {
          name = "Default";
          effects = [
            {
              type = "native_static_gaussian_blur";
              id = "effect_000000000000";
              params = {
                radius = 30;
                brightness = 0.44;
              };
            }
          ];
        })
        (mkPipeline "pipeline_default_rounded" {
          name = "Default Rounded";
          effects = [
            {
              type = "native_static_gaussian_blur";
              id = "effect_000000000001";
              params = {
                radius = 30;
                brightness = 0.44;
              };
            }
            {
              type = "corner";
              id = "effect_000000000002";
              params = {
                radius = 24;
              };
            }
          ];
        })
      ];
    };

    "org/gnome/shell/extensions/blur-my-shell/appfolder" = {
      style-dialogs = 2;
    };
  };
}

