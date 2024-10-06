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

    "org/gnome/shell/extensions/rounded-window-corners-reborn" =
    let
      mkProperty = k: v: (mkDictionaryEntry [ k (mkVariant v)]);
      mkCornerSettings = {
        left ? 1,
        right ? 1,
        top ? 1,
        bottom ? 1,
        show-while-maximized ? false,
        show-while-in-fullscreen ? false,
        radius ? 12,
        smoothing ? 0,
      }: [
        (mkProperty "padding" [
          (mkProperty "left"   (mkUint32 (assert lib.isInt left; left)))
          (mkProperty "right"  (mkUint32 (assert lib.isInt right; right)))
          (mkProperty "top"    (mkUint32 (assert lib.isInt top; top)))
          (mkProperty "bottom" (mkUint32 (assert lib.isInt bottom; bottom)))
        ])
        (mkProperty "keep_rounded_corners" [
          (mkProperty "maximized"  (assert lib.isBool show-while-maximized; show-while-maximized))
          (mkProperty "fullscreen" (assert lib.isBool show-while-in-fullscreen; show-while-in-fullscreen))
        ])
        (mkProperty "border_radius" (mkUint32 (assert lib.isInt radius; radius)))
        (mkProperty "smoothing" (
          if (lib.isInt smoothing) then
            (mkUint32 (assert lib.isInt smoothing; smoothing))
          else
            (mkDouble (assert lib.isFloat smoothing; smoothing))
        ))
      ];
      mkCustomCornerSettings = windowClass: settings: (mkProperty windowClass (
        (mkCornerSettings settings) ++
        lib.lists.singleton (mkProperty "enabled" (
          if (lib.hasAttr "enabled" settings) then
            (assert lib.isBool settings.enabled; settings.enabled)
          else
            true
          ))
      ));
    in
    {
      border-width = 0;
      settings-version = (mkUint32 5);
      tweak-kitty-terminal = false;
      global-rounded-corner-settings = (mkCornerSettings {
        left = 1;
        right = 1;
        top = 1;
        bottom = 1;
      });
      custom-rounded-corner-settings = [
        (mkCustomCornerSettings "steamwebhelper" {
          left = 2;
          right = 3;
          top = 2;
          bottom = 3;
        })
      ];
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

