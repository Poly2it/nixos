{ pkgs, inputs, ...}:

let
  package = pkgs.firefox.overrideAttrs
    (oldAttrs:
    {
    buildCommand = oldAttrs.buildCommand +
    ''
    wrapProgram $out/bin/firefox \
      --set MOZ_ENABLE_WAYLAND 0 \
      --set MOZ_USE_XINPUT2 1
    '';
  });

  bookmarks = [
    {
      name = "wikipedia";
      tags = [ "wiki" ];
      keyword = "wiki";
      url = "https://en.wikipedia.org/wiki/Special:Search?search=%s&go=Go";
    }
    {
      name = "kernel.org";
      url = "https://www.kernel.org";
    }
    {
      name = "Nix Sites";
      toolbar = true;
      bookmarks = [
        {
          name = "NixOS Home";
          tags = [ "nix" ];
          url = "https://nixos.org/";
        }
        {
          name = "NixOS Wiki";
          tags = [ "wiki" "nix" ];
          url = "https://wiki.nixos.org/";
        }
        {
          name = "MyNixOS";
          tags = [ "nix" ];
          url = "https://mynixos.com/";
        }
      ];
    }
  ];

  search = {
    force = true;
    default = "DuckDuckGo";
    order = [ "DuckDuckGo" ];
    engines = {
      "Google".metaData.hidden = true;
      "Bing".metaData.hidden = true;
      "eBay".metaData.hidden = true;
      "Wikipedia (en)".metaData.alias = "@w";
      "Wiktionary" = {
        urls = [{
          template = "https://en.wiktionary.org/w/index.php";
          params = [
            { name = "go"; value = "Go"; }
            { name = "search"; value = "{searchTerms}"; }
          ];
        }];
        icon = "${pkgs.fetchurl {
          url = "https://upload.wikimedia.org/wikipedia/commons/a/ab/English_Wiktionary_favicon.png";
          sha256 = "sha256-VB7jk9ZzkGN+PacHaST/ghnKIqrCu4njsPfV2s8Tbbw=";
        }}";
        definedAliases = [ "@wt" ];
      };
      "GitHub" = {
        urls = [{
          template = "https://github.com/search";
          params = [
            { name = "q"; value = "{searchTerms}"; }
          ];
        }];
        icon = "${pkgs.fetchurl {
          url = "https://github.githubassets.com/favicons/favicon.svg";
          sha256 = "sha256-apV3zU9/prdb3hAlr4W5ROndE4g3O1XMum6fgKwurmA=";
        }}";
        definedAliases = [ "@gh" ];
      };
      "Nix Packages" = {
        urls = [{
          template = "https://search.nixos.org/packages";
          params = [
            { name = "channel"; value = "unstable"; }
            { name = "query"; value = "{searchTerms}"; }
          ];
        }];
        icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
        definedAliases = [ "@np" ];
      };
      "NixOS Wiki" = {
        urls = [{
          template = "https://wiki.nixos.org/w/index.php";
          params = [ { name = "search"; value = "{searchTerms}"; }];
        }];
        icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
        definedAliases = [ "@nw" ];
      };
      "MyNixOS" = {
        urls = [{
          template = "https://mynixos.com/search";
          params = [ { name = "q"; value = "{searchTerms}"; }];
        }];
        icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
        definedAliases = [ "@mn" ];
      };
    };
  };

  profiles = {
    default = {
      id = 0;
      name = "default";
      isDefault = true;
      userChrome = ''
        @import "firefox-gnome-theme/userChrome.css";

        #webrtcIndicator {
          display: none;
        }

        #firefox-view-button {
          display: none;
        }

        /* Disable the "Import Bookmarks" button. */
        #import-button {
          display: none;
        }
      '';
      userContent = ''
        @import "firefox-gnome-theme/userContent.css";
      '';

      inherit bookmarks;
      inherit search;

      settings = preferences;
      containersForce = true;
    };
  };

  extensions = {
    "*".installation_mode = "blocked";
    "uBlock0@raymondhill.net" = {
      install_url = "https://addons.mozilla.org/firefox/downloads/file/4290466/ublock_origin-1.58.0.xpi";
      installation_mode = "force_installed";
    };
    "7esoorv3@alefvanoon.anonaddy.me" = {
      install_url = "https://addons.mozilla.org/firefox/downloads/file/4280925/libredirect-2.8.4.xpi";
      installation_mode = "force_installed";
    };
  };

  ext-extensions = {
    # https://github.com/libredirect/browser_extension/blob/b3457faf1bdcca0b17872e30b379a7ae55bc8fd0/src/config.json
    "7esoorv3@alefvanoon.anonaddy.me" = {
      services.options.youtube.enabled = true;
      services.options.reddit.enabled = true;
    };
    # https://github.com/gorhill/uBlock/blob/master/platform/common/managed_storage.json
    "uBlock0@raymondhill.net".adminSettings = {
      userSettings = {
        uiTheme = "light";
        uiAccentCustom = true;
        uiAccentCustom0 = "#E6E6E6";
        cloudStorageEnabled = false;
      };
      # https://github.com/gorhill/uBlock/blob/master/assets/assets.json
      selectedFilterLists = [
        "adguard-generic"
        "adguard-annoyance"
        "adguard-social"
        "adguard-spyware"
        "adguard-spyware-url"
        "adguard-popup_overlays"
        "adguard-mobile-app-banners"
        "adguard-other-annoyances"
        "adguard-widgets"
        "adguard-cookies"
        "ublock-cookies-adguard"
        "fanboy-cookiemonster"
        "fanboy-social"
        "fanboy-thirdparty_social"
        "block-lan"
        "dpollock-0"
        "easylist"
        "easylist-annoyances"
        "easylist-newsletters"
        "easyprivacy"
        "easylist_cookie"
        "ublock-cookies-easylist"
        "ublock-abuse"
        "ublock-badware"
        "ublock-filters"
        "ublock-annoyances"
        "ublock-privacy"
        "ublock-quick-fixes"
        "ublock-unbreak"
        "urlhaus-1"
        "plowe-0"
        "DEU-0"
        "FIN-0"
        "ISL-0"
        "NOR-0"
        "SWE-1"
      ];
    };
  };

  policies = {
    Preferences = preferences;
    ExtensionSettings = extensions;
    "3rdparty".Extensions = ext-extensions;
    AllowedDomainsForApps = "";
    AppAutoUpdate = false;
    AutofillCreditCardEnabled = false;
    BackgroundAppUpdate = false;
    DisableAccounts = true;
    DisableAppUpdate = true;
    DisableFirefoxAccounts = true;
    DisableFirefoxScreenshots = true;
    DisableFirefoxStudies = true;
    DisableFormHistory = true;
    DisableMasterPasswordCreation = true;
    DisablePocket = true;
    DisableSystemAddonUpdate = true;
    DisableTelemetry = true;
    DisplayMenuBar = "never";
    DontCheckDefaultBrowser = true;
    ExtensionUpdate = false;
    HardwareAcceleration = true;
    HttpsOnlyMode = "enabled";
    ManualAppUpdateOnly = true;
    NetworkPrediction = true;
    OfferToSaveLogins = false;
    OfferToSaveLoginsDefault = false;
    OverrideFirstRunPage = "";
    OverridePostUpdatePage = "";
    PasswordManagerEnabled = false;
    PostQuantumKeyAgreementEnabled = true;
    PrimaryPassword = false;
    PromptForDownloadLocation = false;
    SearchEngines = {
      Default = "DuckDuckGo";
      PreventInstalls = true;
    };
    ShowHomeButton = false;
    StartDownloadsInTempDirectory = false;
  };

  preferences = {
    # Enable customChrome.css
    "toolkit.legacyUserProfileCustomizations.stylesheets" = lock-true;

    # Set UI density to normal.
    "browser.uidensity" = 0;

    # Enable SVG context-propertes.
    "svg.context-properties.content.enabled" = lock-true;

    # Disable private window dark theme.
    "browser.theme.dark-private-windows" = lock-false;

    # Enable rounded bottom window corners.
    "widget.gtk.rounded-bottom-corners.enabled" = lock-true;

    # Release notes and vendor URLs.
    "app.releaseNotesURL" = "http://127.0.0.1/";
    "app.vendorURL" = "http://127.0.0.1/";
    "app.privacyURL" = "http://127.0.0.1/";

    # Disable plugin installer.
    "plugins.hide_infobar_for_missing_plugin" = lock-true;
    "plugins.hide_infobar_for_outdated_plugin" = lock-true;
    "plugins.notifyMissingFlash" = lock-false;

    # Speeding it up.
    "network.http.pipelining" = lock-true;
    "network.http.proxy.pipelining" = lock-true;
    "network.http.pipelining.maxrequests" = 10;
    "nglayout.initialpaint.delay" = 0;

    # Disable third party cookies.
    "network.cookie.cookieBehavior" = 1;

    "privacy.firstparty.isolate" = lock-true;

    # Tor.
    "network.proxy.socks" = "127.0.0.1";
    "network.proxy.socks_port" = 9050;

    # Extensions cannot be updated without permission.
    "extensions.update.enabled" = lock-false;
    # Use LANG environment variable to choose locale.
    "intl.locale.matchOS" = lock-true;
    # Disable default browser checking.
    "browser.shell.checkDefaultBrowser" = lock-false;
    # Prevent EULA dialog to popup on first run.
    "browser.EULA.override" = lock-true;
    # Don't disable extensions dropped in to a system
    # location, or those owned by the application.
    "extensions.autoDisableScopes" = 3;
    # Don't display the one-off addon selection dialog when
    # upgrading from a version of Firefox older than 8.0.
    "extensions.shownSelectionUI" = lock-true;
    # Don't call home for blacklisting.
    "extensions.blocklist.enabled" = lock-false;

    # Disable app updater url.
    "app.update.url" = "http://127.0.0.1/";
    "app.update.url.details" = "http://127.0.0.1/";
    "app.update.url.manual" = "http://127.0.0.1/";

    "breakpad.reportURL" = "http://127.0.0.1/";

    "startup.homepage_welcome_url" = "";
    "browser.startup.homepage_override.mstone" = "ignore";

    # Help URL.
    "app.support.baseURL" = "http://127.0.0.1/";
    "app.support.inputURL" = "http://127.0.0.1/";
    "app.feedback.baseURL" = "http://127.0.0.1/";
    "browser.uitour.url" = "http://127.0.0.1/";
    "browser.uitour.themeOrigin" = "http://127.0.0.1/";
    "plugins.update.url" = "http://127.0.0.1/";
    "browser.customizemode.tip0.learnMoreUrl" = "http://127.0.0.1/";

    # Dictionary download.
    "browser.dictionaries.download.url" = "http://127.0.0.1/";
    "browser.search.searchEnginesURL" = "http://127.0.0.1/";
    "layout.spellcheckDefault" = 0;

    # Apturl.
    "network.protocol-handler.app.apt" = "/usr/bin/apturl";
    "network.protocol-handler.warn-external.apt" = lock-false;
    "network.protocol-handler.app.apt+http" = "/usr/bin/apturl";
    "network.protocol-handler.warn-external.apt+http" = lock-false;
    "network.protocol-handler.external.apt" = lock-true;
    "network.protocol-handler.external.apt+http" = lock-true;

    # Quality of life stuff.
    "browser.download.useDownloadDir" = lock-false;
    "browser.aboutConfig.showWarning" = lock-false;
    # Hover preview would be cool, but it unfortunately bugs tab grabbing currently.
    "browser.tabs.hoverPreview.enabled" = false;
    # Disable the feature tour (can Firefox just calm down?).
    "browser.firefox-view.feature-tour" = lock { screen = "FIREFOX_VIEW_SPOTLIGHT"; complete = true; };
    "browser.bookmarks.addedImportButton" = lock-false;
    "widget.use-xdg-desktop-portal.file-picker" = "1";
    # Disable UI tooltips, as they are just buggy, and I never use them. At the
    # point where you have so many tabs you need to peek through each one to
    # find what you're looking for, is a 300 ms sluggish 2010-era text overlay
    # really that much better than just going through those tabs to find
    # the content you're searching for? Either way requires an iteration of the
    # ambigious tabs.
    "ui.tooltip.delay_ms" = -1;

    # Use system scroll.
    "mousewheel.system_scroll_override" = lock-true;

    # Privacy & Freedom Issues.
    # https://webdevelopmentaid.wordpress.com/2013/10/21/customize-privacy-settings-in-mozilla-firefox-part-1-aboutconfig/
    # https://panopticlick.eff.org
    # http://ip-check.info
    # http://browserspy.dk
    # https://wiki.mozilla.org/Fingerprinting
    # http://www.browserleaks.com
    # http://fingerprint.pet-portal.eu
    "browser.translation.engine" = "";
    "browser.urlbar.update2.engineAliasRefresh" = lock-true;
    "browser.newtabpage.activity-stream.feeds.topsites" = lock-false;
    "browser.newtabpage.activity-stream.showSponsored" = lock-false;
    "browser.newtabpage.activity-stream.default.sites" = "";
    "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons" = lock-false;
    "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features" = lock-false;
    "browser.newtabpage.activity-stream.discoverystream.enabled" = lock-false;
    "browser.newtabpage.activity-stream.discoverystream.endpointSpocsClear" = "http://127.0.0.1/";
    "browser.newtabpage.activity-stream.discoverystream.endpoints" = "http://127.0.0.1/";
    "browser.newtabpage.activity-stream.telemetry.structuredIngestion.endpoint" = "http://127.0.0.1/";
    "browser.newtabpage.activity-stream.feeds.sections" = lock-false;
    "browser.newtabpage.activity-stream.feeds.snippets" = lock-false;
    "browser.newtabpage.activity-stream.feeds.system.topsites" = lock-false;
    "browser.newtabpage.activity-stream.feeds.system.topstories" = lock-false;
    "browser.newtabpage.activity-stream.feeds.systemtick" = lock-false;
    "browser.newtabpage.activity-stream.feeds.telemetry" = lock-false;
    "browser.urlbar.suggest.engines" = lock-false;
    "browser.urlbar.suggest.topsites" = lock-false;
    "security.OCSP.enabled" = 0;
    "security.OCSP.require" = lock-false;
    "browser.discovery.containers.enabled" = lock-false;
    "browser.discovery.enabled" = lock-false;
    "browser.discovery.sites" = "http://127.0.0.1/";
    "services.sync.prefs.sync.browser.startup.homepage" = lock-false;
    "browser.contentblocking.report.monitor.home_page_url" = "http://127.0.0.1/";
    "dom.ipc.plugins.flash.subprocess.crashreporter.enabled" = lock-false;
    "browser.safebrowsing.enabled" = lock-false;
    "browser.safebrowsing.downloads.remote.enabled" = lock-false;
    "browser.safebrowsing.malware.enabled" = lock-false;
    "browser.safebrowsing.provider.google.updateURL" = "";
    "browser.safebrowsing.provider.google.gethashURL" = "";
    "browser.safebrowsing.provider.google4.updateURL" = "";
    "browser.safebrowsing.provider.google4.gethashURL" = "";
    "browser.safebrowsing.provider.mozilla.gethashURL" = "";
    "browser.safebrowsing.provider.mozilla.updateURL" = "";
    "services.sync.privacyURL" = "http://127.0.0.1/";
    "social.enabled" = lock-false;
    "social.remote-install.enabled" = lock-false;
    "datareporting.policy.dataSubmissionEnabled" = lock-false;
    "datareporting.healthreport.uploadEnabled" = lock-false;
    "datareporting.healthreport.about.reportUrl" = "http://127.0.0.1/";
    "datareporting.healthreport.documentServerURI" = "http://127.0.0.1/";
    "healthreport.uploadEnabled" = lock-false;
    "social.toast-notifications.enabled" = lock-false;
    "datareporting.healthreport.service.enabled" = lock-false;
    "browser.slowStartup.notificationDisabled" = lock-true;
    "network.http.sendRefererHeader" = 2;
    "network.http.referer.spoofSource" = lock-true;
    # We don't want to send the Origin header.
    "network.http.originextension" =  lock-false;
    # http://grack.com/blog/2010/01/06/3rd-party-cookies-dom-storage-and-privacy/
    # "dom.storage.enabled" = lock-false;
    "dom.event.clipboardevents.enabled" = lock-false;
    "network.user_prefetch-next" = lock-false;
    "network.dns.disablePrefetch" = lock-true;
    "network.http.sendSecureXSiteReferrer" = lock-false;
    "toolkit.telemetry.enabled" = lock-false;
    "toolkit.telemetry.server" = "";
    "experiments.manifest.uri" = "";
    "toolkit.telemetry.unified" = lock-false;
    # Make sure updater telemetry is disabled; see https://trac.torproject.org/25909.
    "toolkit.telemetry.updatePing.enabled" = lock-false;
    # Do not tell what plugins do we have enabled: https://mail.mozilla.org/pipermail/firefox-dev/2013-November/001186.html.
    "plugins.enumerable_names" = "";
    "plugin.state.flash" = 0;
    # Do not autoupdate search engines.
    "browser.search.update" = lock-false;
    # Warn when the page tries to redirect or refresh
    # "accessibility.blockautorefresh" = lock-true;
    "dom.battery.enabled" = lock-false;
    "device.sensors.enabled" = lock-false;
    "camera.control.face_detection.enabled" = lock-false;
    "camera.control.autofocus_moving_callback.enabled" = lock-false;
    "network.http.speculative-parallel-limit" = 0;
    # No search suggestions.
    "browser.urlbar.userMadeSearchSuggestionsChoice" = lock-true;
    "browser.search.suggest.enabled" = lock-false;
    # Always ask before restoring the browsing session.
    "browser.sessionstore.max_resumed_crashes" = 0;
    # Don't ping Mozilla for MitM detection, see https://bugs.torproject.org/32321.
    "security.certerrors.mitm.priming.enabled" = lock-false;
    "security.certerrors.recordEventTelemetry" = lock-false;
    # Disable shield/heartbeat.
    "extensions.shield-recipe-client.enabled" = lock-false;
    # Always ask before restoring the browsing session.
    # Disable tracking protection since it makes you stick out.
    "privacy.trackingprotection.enabled" = lock-false;
    "privacy.trackingprotection.pbmode.enabled" = lock-false;
    "urlclassifier.trackingTable" = "test-track-simple,base-track-digest256,content-track-digest256";
    "privacy.donottrackheader.enabled" = lock-false;
    "privacy.trackingprotection.introURL" = "https://www.mozilla.org/%LOCALE%/firefox/%VERSION%/tracking-protection/start/";
    # Ensure crash reports don't go through.
    "browser.crashReports.unsubmittedCheck.enabled" = lock-false;
    "browser.tabs.crashReporting.includeURLfals" = lock-false;
    "browser.tabs.crashReporting.sendReport" = lock-false;
    # Disable geolocation.
    "geo.enabled" = lock-false;
    "geo.wifi.uri" = "";
    "geo.provider.use_gpsd" = lock-false;
    "geo.provider.use_geoclue" = lock-false;
    "browser.search.geoip.url" = "";
    "browser.search.geoSpecificDefaults" = lock-false;
    "browser.search.geoSpecificDefaults.url" = "";
    "browser.search.modernConfig" = lock-false;
    # Disable captive portal detection.
    "captivedetect.canonicalURL" = "";
    "network.captive-portal-service.enabled" = lock-false;
    # Disable shield/heartbeat and canvas fingerprint protection.
    # This also enables useragent spoofing.
    "privacy.resistFingerprinting" = lock-true;
    "webgl.disabled" = lock-true;
    "privacy.trackingprotection.cryptomining.enabled" = lock-true;
    "privacy.trackingprotection.fingerprinting.enabled" = lock-true;

    # Disable channel updates.
    "app.update.enabled" = lock-false;
    "app.update.auto" = lock-false;

    # EME.
    "media.eme.enabled" = lock-false;
    "media.eme.apiVisible" = lock-false;

    "identity.fxaccounts.enabled" = lock-false;

    # WebRTC.
    "media.peerconnection.enabled" = lock-true;
    # Don't reveal your internal IP when WebRTC is enabled.
    "media.peerconnection.ice.no_host" = lock-true;
    "media.peerconnection.ice.default_address_only" = lock-true;

    # Use the proxy server to do DNS lookups when using SOCKS.
    # http://kb.mozillazine.org/Network.proxy.socks_remote_dns
    "network.proxy.socks_remote_dns" = lock-true;

    # Services.
    "gecko.handlerService.schemes.mailto.0.name" = "";
    "gecko.handlerService.schemes.mailto.1.name" = "";
    "handlerService.schemes.mailto.1.uriTemplate" = "";
    "gecko.handlerService.schemes.mailto.0.uriTemplate" = "";
    "browser.contentHandlers.types.0.title" = "";
    "browser.contentHandlers.types.0.uri" = "";
    "browser.contentHandlers.types.1.title" = "";
    "browser.contentHandlers.types.1.uri" = "";
    "gecko.handlerService.schemes.webcal.0.name" = "";
    "gecko.handlerService.schemes.webcal.0.uriTemplate" = "";
    "gecko.handlerService.schemes.irc.0.name" = "";
    "gecko.handlerService.schemes.irc.0.uriTemplate" = "";

    "font.default.x-western" = "sans-serif";

    # Preferences for the Get Add-ons panel.
    "extensions.webservice.discoverURL" = "http://127.0.0.1/";
    "extensions.getAddons.search.url" = "http://127.0.0.1/";
    "extensions.getAddons.search.browseURL" = "http://127.0.0.1/";
    "extensions.getAddons.get.url" = "http://127.0.0.1/";
    "extensions.getAddons.link.url" = "http://127.0.0.1/";
    "extensions.getAddons.discovery.api_url" = "http://127.0.0.1/";

    "extensions.systemAddon.update.url" = "";
    "extensions.systemAddon.update.enabled" = lock-false;

    # FIXME: find better URLs for these:
    "extensions.getAddons.langpacks.url" = "http://127.0.0.1/";
    "lightweightThemes.getMoreURL" = "http://127.0.0.1/";
    "browser.geolocation.warning.infoURL" = "";
    "browser.xr.warning.infoURL" = "";

    # Mobile.
    "privacy.announcements.enabled" = lock-false;
    "browser.snippets.enabled" = lock-false;
    "browser.snippets.syncPromo.enabled" = lock-false;
    "identity.mobilepromo.android" = "http://127.0.0.1/";
    "browser.snippets.geoUrl" = "http://127.0.0.1/";
    "browser.snippets.updateUrl" = "http://127.0.0.1/";
    "browser.snippets.statsUrl" = "http://127.0.0.1/";
    "datareporting.policy.firstRunTime" = 0;
    "datareporting.policy.dataSubmissionPolicyVersion" = 2;
    "browser.webapps.checkForUpdates" = 0;
    "browser.webapps.updateCheckUrl" = "http://127.0.0.1/";
    "app.faqURL" = "http://127.0.0.1/";

    # PFS url.
    "pfs.datasource.url" = "http://127.0.0.1/";
    "pfs.filehint.url" = "http://127.0.0.1/";

    # Disable Gecko media plugins: https://wiki.mozilla.org/GeckoMediaPlugins.
    "media.gmp-manager.url.override" = "data:text/plain,";
    "media.gmp-manager.url" = "";
    "media.gmp-manager.updateEnabled" = lock-false;
    "media.gmp-provider.enabled" = lock-false;

    # Don't install openh264 codec.
    "media.gmp-gmpopenh264.enabled" = lock-false;
    "media.gmp-eme-adobe.enabled" = lock-false;

    # Disable middle click content load, avoid loading urls by mistake.
    "middlemouse.contentLoadURL" = lock-false;

    # Disable heartbeat.
    "browser.selfsupport.url" = "";

    # Disable Link to FireFox Marketplace, currently loaded with non-free "apps".
    "browser.apps.URL" = "";

    # Disable Firefox Hello.
    "loop.enabled" = lock-false;

    # Use old style that allow javascript to be disabled.
    "browser.user_preferences.inContent" = lock-false;

    # Don't download ads for the newtab page.
    "browser.newtabpage.directory.source" = "";
    "browser.newtabpage.directory.ping" = "";
    "browser.newtabpage.introShown" = lock-true;
    "browser.newtabpage.activity-stream.showSponsoredTopSites" = lock-false;

    # Disable home snippets.
    "browser.aboutHomeSnippets.updateUrl" = "data:text/html";

    "browser.user_preferences.moreFromMozilla" = lock-false;

    # Disable SSDP.
    "browser.casting.enabled" = lock-false;

    # Disable directory service.
    "social.directories" = "";

    # Don't report TLS errors to Mozilla.
    "security.ssl.errorReporting.enabled" = lock-false;

    # Crypto hardening
    # https://gist.github.com/haasn/69e19fc2fe0e25f3cff5
    # General settings.
    "security.tls.unrestricted_rc4_fallback" = lock-false;
    "security.tls.insecure_fallback_hosts.use_static_list" = lock-false;
    "security.tls.version.min" = 1;
    "security.ssl.require_safe_negotiation" = lock-false;
    "security.ssl.treat_unsafe_negotiation_as_broken" = lock-true;
    "security.ssl3.rsa_seed_sha" = lock-true;

    # Avoid logjam attack.
    "security.ssl3.dhe_rsa_aes_128_sha" = lock-false;
    "security.ssl3.dhe_rsa_aes_256_sha" = lock-false;
    "security.ssl3.dhe_dss_aes_128_sha" = lock-false;
    "security.ssl3.dhe_rsa_des_ede3_sha" = lock-false;
    "security.ssl3.rsa_des_ede3_sha" = lock-false;

    # Disable Pocket integration.
    "browser.pocket.enabled" = lock-false;
    "extensions.pocket.enabled" = lock-false;
    "extensions.pocket.api" = "http://127.0.0.1/";

    # This redirect is dead and potentially dangerous.
    "extensions.webextensions.identity.redirectDomain" = "http://127.0.0.1/";

    # Disable More from Mozilla.
    "browser.preferences.moreFromMozilla" = lock-false;

    # Don't conceal preferences.
    "browser.preferences.experimental" = lock-true;

    # Enable extensions by default in private mode.
    "extensions.allowPrivateBrowsingByDefault" = lock-true;

    # Do not show unicode urls, see: https://www.xudongz.com/blog/2017/idn-phishing/.
    "network.IDN_show_punycode" = lock-true;

    # Disable screenshots extension.
    "extensions.screenshots.disabled" = lock-true;

    # Disable onboarding.
    "browser.onboarding.newtour" = "performance,private,addons,customize,default";
    "browser.onboarding.updatetour" = "performance,library,singlesearch,customize";
    "browser.onboarding.enabled" = lock-false;

    # New tab settings.
    "browser.newtabpage.activity-stream.showTopSites" = lock-false;
    "browser.newtabpage.activity-stream.feeds.section.topstories" = lock-false;
    "browser.newtabpage.activity-stream.disableSnippets" = lock-true;
    "browser.newtabpage.activity-stream.tippyTop.service.endpoint" = "";

    # Enable xrender.
    "gfx.xrender.enabled" = lock-true;

    # Disable push notifications.
    "dom.webnotifications.enabled" = lock-false;
    "dom.webnotifications.serviceworker.enabled" = lock-false;
    "dom.push.enabled" = lock-false;

    # Disable recommended extensions.
    "browser.newtabpage.activity-stream.asrouter.useruser_prefs.cfr" = lock-false;
    "extensions.htmlaboutaddons.discover.enabled" = lock-false;
    "extensions.htmlaboutaddons.recommendations.enabled" = lock-false;

    # Disable the settings server.
    "services.settings.server" = "";

    # Disable use of WiFi region/location information.
    "browser.region.network.scan" = lock-false;
    "browser.region.network.url" = "";

    # Disable VPN/mobile promos.
    "browser.contentblocking.report.hide_vpn_banner" = lock-true;
    "browser.contentblocking.report.mobile-ios.url" = "";
    "browser.contentblocking.report.mobile-android.url" = "";
    "browser.contentblocking.report.show_mobile_app" = lock-false;
    "browser.contentblocking.report.vpn.enabled" = lock-false;
    "browser.contentblocking.report.vpn.url" = "";
    "browser.contentblocking.report.vpn-promo.url" = "";
    "browser.contentblocking.report.vpn-android.url" = "";
    "browser.contentblocking.report.vpn-ios.url" = "";
    "browser.privatebrowsing.promoEnabled" = lock-false;

    # Enable hardware acceleration.
    "media.ffmpeg.vaapi.enabled" = lock-true;
    "media.ffvpx.enabled" = lock-true;

    # Disable hardware acceleration.
    # "media.ffmpeg.vaapi.enabled" = lock-false;
    # "media.ffvpx.enabled" = lock-false;
    # "gfx.direct2d.disabled" = lock-true;

    # Disable Form Autofill.
    "extensions.formautofill.addresses.enabled" = lock-false;
    "extensions.formautofill.creditCards.enabled" = lock-false;

    # Disable AV1 codec.
    "media.av1.enabled " = lock-false;

    # https://blog.privacyguides.org/2024/07/14/mozilla-disappoints-us-yet-again-2/
    "dom.private-attribution.submission.enabled" = lock-false;
  };

  lock = value: { Value = value; Status = "locked"; };
  lock-false = {
    Value = false;
    Status = "locked";
  };
  lock-true = {
    Value = true;
    Status = "locked";
  };
in

{
  home.file.".mozilla/firefox/default/chrome/firefox-gnome-theme".source = inputs.firefox-gnome-theme;
  programs.firefox = {
    enable = true;
    inherit package;
    inherit policies;
    inherit profiles;
  };
}

