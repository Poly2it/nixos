{ lib, pkgs, inputs, ...}:

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
      "Noogle" = {
        urls = [{
          template = "https://noogle.dev/q";
          params = [
            { name = "term"; value = "{searchTerms}"; }
          ];
        }];
        icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
        definedAliases = [ "@no" ];
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

        @namespace xul "http://www.mozilla.org/keymaster/gatekeeper/there.is.only.xul";
      '';
      userContent = ''
        @import "firefox-gnome-theme/userContent.css";
      '';

      inherit bookmarks;
      inherit search;

      settings = (mkUserPreferences preferences-base) // preferences-extended;
      containersForce = true;
    };

    unsafe = {
      id = 1;
      name = "unsafe";
      isDefault = false;
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

        @namespace xul "http://www.mozilla.org/keymaster/gatekeeper/there.is.only.xul";
      '';
      userContent = ''
        @import "firefox-gnome-theme/userContent.css";
      '';

      inherit bookmarks;
      inherit search;

      settings = mkUserPreferences preferences-base;
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
    Preferences = mkPolicyPreferences preferences-base;
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

  preferences-base = {
    # GNOME theme.
    "gnomeTheme.bookmarksToolbarUnderTabs" = true;

    # Enable customChrome.css
    "toolkit.legacyUserProfileCustomizations.stylesheets" = true;

    # Set UI density to normal.
    "browser.uidensity" = 0;

    # Enable SVG context-propertes.
    "svg.context-properties.content.enabled" = true;

    # Disable private window dark theme.
    "browser.theme.dark-private-windows" = false;

    # Enable rounded bottom window corners.
    "widget.gtk.rounded-bottom-corners.enabled" = true;

    # Release notes and vendor URLs.
    "app.releaseNotesURL" = localhost;
    "app.vendorURL" = localhost;
    "app.privacyURL" = localhost;

    # Disable plugin installer.
    "plugins.hide_infobar_for_missing_plugin" = true;
    "plugins.hide_infobar_for_outdated_plugin" = true;
    "plugins.notifyMissingFlash" = false;

    # Speeding it up.
    "network.http.pipelining" = true;
    "network.http.proxy.pipelining" = true;
    "network.http.pipelining.maxrequests" = 10;
    "nglayout.initialpaint.delay" = 0;

    # Disable third party cookies.
    "network.cookie.cookieBehavior" = 1;

    "privacy.firstparty.isolate" = true;

    # Tor.
    "network.proxy.socks" = localhost;
    "network.proxy.socks_port" = 9050;

    # Extensions cannot be updated without permission.
    "extensions.update.enabled" = false;
    # Use LANG environment variable to choose locale.
    "intl.locale.matchOS" = true;
    "intl.regional_prefs.use_os_locales" = false;
    # Disable default browser checking.
    "browser.shell.checkDefaultBrowser" = false;
    # Prevent EULA dialog to popup on first run.
    "browser.EULA.override" = true;
    # Don't disable extensions dropped in to a system
    # location, or those owned by the application.
    "extensions.autoDisableScopes" = 3;
    # Don't display the one-off addon selection dialog when
    # upgrading from a version of Firefox older than 8.0.
    "extensions.shownSelectionUI" = true;
    # Don't call home for blacklisting.
    "extensions.blocklist.enabled" = false;

    # Disable app updater url.
    "app.update.url" = localhost;
    "app.update.url.details" = localhost;
    "app.update.url.manual" = localhost;

    "breakpad.reportURL" = localhost;

    "startup.homepage_welcome_url" = "";
    "browser.startup.homepage_override.mstone" = "ignore";

    # Help URL.
    "app.support.baseURL" = localhost;
    "app.support.inputURL" = localhost;
    "app.feedback.baseURL" = localhost;
    "browser.uitour.url" = localhost;
    "browser.uitour.themeOrigin" = localhost;
    "plugins.update.url" = localhost;
    "browser.customizemode.tip0.learnMoreUrl" = localhost;

    # Dictionary download.
    "browser.dictionaries.download.url" = localhost;
    "browser.search.searchEnginesURL" = localhost;
    "layout.spellcheckDefault" = 0;

    # Apturl.
    # "network.protocol-handler.app.apt" = "/usr/bin/apturl";
    # "network.protocol-handler.warn-external.apt" = false;
    # "network.protocol-handler.app.apt+http" = "/usr/bin/apturl";
    # "network.protocol-handler.warn-external.apt+http" = false;
    # "network.protocol-handler.external.apt" = true;
    # "network.protocol-handler.external.apt+http" = true;

    # Quality of life stuff.
    "browser.download.useDownloadDir" = false;
    "browser.aboutConfig.showWarning" = false;
    # Hover preview would be cool, but it unfortunately bugs tab grabbing currently.
    "browser.tabs.hoverPreview.enabled" = false;
    # Disable the feature tour (can Firefox just calm down?).
    "browser.firefox-view.feature-tour" = { screen = "FIREFOX_VIEW_SPOTLIGHT"; complete = true; };
    "browser.bookmarks.addedImportButton" = false;
    "widget.use-xdg-desktop-portal.file-picker" = 1;
    # Disable UI tooltips, as they are just buggy, and I never use them. At the
    # point where you have so many tabs you need to peek through each one to
    # find what you're looking for, is a 300 ms sluggish 2010-era text overlay
    # really that much better than just going through those tabs to find
    # the content you're searching for? Either way requires an iteration of the
    # ambigious tabs.
    "ui.tooltip.delay_ms" = -1;
    "browser.translations.neverTranslateLanguages" = "sv";

    # Use system scroll.
    "mousewheel.system_scroll_override" = true;

    # Privacy & Freedom Issues.
    # https://webdevelopmentaid.wordpress.com/2013/10/21/customize-privacy-settings-in-mozilla-firefox-part-1-aboutconfig/
    # https://panopticlick.eff.org
    # http://ip-check.info
    # http://browserspy.dk
    # https://wiki.mozilla.org/Fingerprinting
    # http://www.browserleaks.com
    # http://fingerprint.pet-portal.eu
    "browser.translation.engine" = "";
    "browser.urlbar.update2.engineAliasRefresh" = true;
    "browser.newtabpage.activity-stream.feeds.topsites" = false;
    "browser.newtabpage.activity-stream.showSponsored" = false;
    "browser.newtabpage.activity-stream.default.sites" = "";
    "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons" = false;
    "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features" = false;
    "browser.newtabpage.activity-stream.discoverystream.enabled" = false;
    "browser.newtabpage.activity-stream.discoverystream.endpointSpocsClear" = localhost;
    "browser.newtabpage.activity-stream.discoverystream.endpoints" = localhost;
    "browser.newtabpage.activity-stream.telemetry.structuredIngestion.endpoint" = localhost;
    "browser.newtabpage.activity-stream.feeds.sections" = false;
    "browser.newtabpage.activity-stream.feeds.snippets" = false;
    "browser.newtabpage.activity-stream.feeds.system.topsites" = false;
    "browser.newtabpage.activity-stream.feeds.system.topstories" = false;
    "browser.newtabpage.activity-stream.feeds.systemtick" = false;
    "browser.newtabpage.activity-stream.feeds.telemetry" = false;
    "security.OCSP.enabled" = 0;
    "security.OCSP.require" = false;
    "browser.discovery.containers.enabled" = false;
    "browser.discovery.enabled" = false;
    "browser.discovery.sites" = localhost;
    "services.sync.prefs.sync.browser.startup.homepage" = false;
    "browser.contentblocking.report.monitor.home_page_url" = localhost;
    "dom.ipc.plugins.flash.subprocess.crashreporter.enabled" = false;
    "browser.safebrowsing.enabled" = false;
    "browser.safebrowsing.downloads.remote.enabled" = false;
    "browser.safebrowsing.malware.enabled" = false;
    "browser.safebrowsing.provider.google.updateURL" = "";
    "browser.safebrowsing.provider.google.gethashURL" = "";
    "browser.safebrowsing.provider.google4.updateURL" = "";
    "browser.safebrowsing.provider.google4.gethashURL" = "";
    "browser.safebrowsing.provider.mozilla.gethashURL" = "";
    "browser.safebrowsing.provider.mozilla.updateURL" = "";
    "services.sync.privacyURL" = localhost;
    "services.sync.prefs.sync.signon.management.page.breach-alerts.enabled" = false;
    "social.enabled" = false;
    "social.remote-install.enabled" = false;
    "datareporting.policy.dataSubmissionEnabled" = false;
    "datareporting.healthreport.uploadEnabled" = false;
    "datareporting.healthreport.about.reportUrl" = localhost;
    "datareporting.healthreport.documentServerURI" = localhost;
    "healthreport.uploadEnabled" = false;
    "social.toast-notifications.enabled" = false;
    "datareporting.healthreport.service.enabled" = false;
    "browser.slowStartup.notificationDisabled" = true;
    "network.http.sendRefererHeader" = 2;
    "network.http.referer.spoofSource" = true;
    # We don't want to send the Origin header.
    "network.http.originextension" =  false;
    # http://grack.com/blog/2010/01/06/3rd-party-cookies-dom-storage-and-privacy/
    # "dom.storage.enabled" = false;
    "dom.event.clipboardevents.enabled" = false;
    "network.user_prefetch-next" = false;
    "network.dns.disablePrefetch" = true;
    "network.http.sendSecureXSiteReferrer" = false;
    "toolkit.telemetry.enabled" = false;
    "toolkit.telemetry.server" = "";
    "experiments.manifest.uri" = "";
    "toolkit.telemetry.unified" = false;
    # Make sure updater telemetry is disabled; see https://trac.torproject.org/25909.
    "toolkit.telemetry.updatePing.enabled" = false;
    # Do not tell what plugins do we have enabled: https://mail.mozilla.org/pipermail/firefox-dev/2013-November/001186.html.
    "plugins.enumerable_names" = "";
    "plugin.state.flash" = 0;
    # Do not autoupdate search engines.
    "browser.search.update" = false;
    # Warn when the page tries to redirect or refresh
    # "accessibility.blockautorefresh" = true;
    "dom.battery.enabled" = false;
    "device.sensors.enabled" = false;
    "camera.control.face_detection.enabled" = false;
    "camera.control.autofocus_moving_callback.enabled" = false;
    "network.http.speculative-parallel-limit" = 0;
    # No search suggestions.
    "browser.urlbar.userMadeSearchSuggestionsChoice" = true;
    "browser.search.suggest.enabled" = false;
    "browser.search.suggest.enabled.private" = false;
    "browser.urlbar.showSearchSuggestionsFirst" = false;
    "browser.urlbar.suggest.addons" = true;
    "browser.urlbar.suggest.bookmark" = true;
    "browser.urlbar.suggest.calculator" = false;
    "browser.urlbar.suggest.clipboard" = false;
    "browser.urlbar.suggest.engines" = false;
    "browser.urlbar.suggest.history" = true;
    "browser.urlbar.suggest.mdn" = false;
    "browser.urlbar.suggest.openpage" = false;
    "browser.urlbar.suggest.pocket" = false;
    "browser.urlbar.suggest.quicksuggest.nonsponsored" = false;
    "browser.urlbar.suggest.quicksuggest.sponsored" = false;
    "browser.urlbar.suggest.recentsearches" = true;
    "browser.urlbar.suggest.remotetab" = false;
    "browser.urlbar.suggest.searches" = false;
    "browser.urlbar.suggest.topsites" = false;
    "browser.urlbar.suggest.trending" = false;
    "browser.urlbar.suggest.weather" = false;
    "browser.urlbar.suggest.yelp" = false;
    "services.sync.prefs.sync.browser.urlbar.suggest.bookmark" = false;
    "services.sync.prefs.sync.browser.urlbar.suggest.engines" = false;
    "services.sync.prefs.sync.browser.urlbar.suggest.history" = false;
    "services.sync.prefs.sync.browser.urlbar.suggest.openpage" = false;
    "services.sync.prefs.sync.browser.urlbar.suggest.searches" = false;
    "services.sync.prefs.sync.browser.urlbar.suggest.topsites" = false;
    # Do not collect data from search suggestions!
    "browser.urlbar.quicksuggest.dataCollection.enabled" = false;
    # Always ask before restoring the browsing session.
    "browser.sessionstore.max_resumed_crashes" = 0;
    # Don't ping Mozilla for MitM detection, see https://bugs.torproject.org/32321.
    "security.certerrors.mitm.priming.enabled" = false;
    "security.certerrors.recordEventTelemetry" = false;
    # Disable shield/heartbeat.
    "extensions.shield-recipe-client.enabled" = false;
    # Always ask before restoring the browsing session.
    # Disable tracking protection since it makes you stick out.
    "privacy.trackingprotection.enabled" = false;
    "privacy.trackingprotection.pbmode.enabled" = false;
    "urlclassifier.trackingTable" = "test-track-simple,base-track-digest256,content-track-digest256";
    "privacy.donottrackheader.enabled" = false;
    "privacy.trackingprotection.introURL" = "https://www.mozilla.org/%LOCALE%/firefox/%VERSION%/tracking-protection/start/";
    # Ensure crash reports don't go through.
    "browser.crashReports.unsubmittedCheck.enabled" = false;
    "browser.tabs.crashReporting.includeURLfals" = false;
    "browser.tabs.crashReporting.sendReport" = false;
    # Disable geolocation.
    "geo.enabled" = false;
    "geo.wifi.uri" = "";
    "geo.provider.use_gpsd" = false;
    "geo.provider.use_geoclue" = false;
    "browser.search.geoip.url" = "";
    "browser.search.geoSpecificDefaults" = false;
    "browser.search.geoSpecificDefaults.url" = "";
    "browser.search.modernConfig" = false;
    # Disable captive portal detection.
    "captivedetect.canonicalURL" = "";
    "network.captive-portal-service.enabled" = false;
    # Disable shield/heartbeat and canvas fingerprint protection.
    # This also enables useragent spoofing.
    "privacy.resistFingerprinting" = true;
    "privacy.trackingprotection.cryptomining.enabled" = true;
    "privacy.trackingprotection.fingerprinting.enabled" = true;

    # Don't permit sending crash reports on my behalf.
    "browser.crashReports.unsubmittedCheck.autoSubmit2" = false;

    "browser.contentblocking.cryptomining.preferences.ui.enabled" = true;
    "browser.contentblocking.customBlockList.preferences.ui.enabled" = false;
    "browser.contentblocking.fingerprinting.preferences.ui.enabled" = true;
    "browser.contentblocking.reject-and-isolate-cookies.preferences.ui.enable" = true;

    # Disable channel updates.
    "app.update.enabled" = false;
    "app.update.auto" = false;

    # EME.
    "media.eme.enabled" = false;
    "media.eme.apiVisible" = false;

    "identity.fxaccounts.enabled" = false;

    # WebRTC.
    "media.peerconnection.enabled" = true;
    # Don't reveal your internal IP when WebRTC is enabled.
    "media.peerconnection.ice.no_host" = true;
    "media.peerconnection.ice.default_address_only" = true;

    # Use the proxy server to do DNS lookups when using SOCKS.
    # http://kb.mozillazine.org/Network.proxy.socks_remote_dns
    "network.proxy.socks_remote_dns" = true;

    # Services.
    "handlerService.schemes.mailto.1.uriTemplate" = "";
    "browser.contentHandlers.types.0.title" = "";
    "browser.contentHandlers.types.0.uri" = "";
    "browser.contentHandlers.types.1.title" = "";
    "browser.contentHandlers.types.1.uri" = "";
    "gecko.handlerService.schemes.mailto.0.name" = "";
    "gecko.handlerService.schemes.mailto.1.name" = "";
    "gecko.handlerService.schemes.mailto.0.uriTemplate" = "";
    "gecko.handlerService.schemes.webcal.0.name" = "";
    "gecko.handlerService.schemes.webcal.0.uriTemplate" = "";
    "gecko.handlerService.schemes.irc.0.name" = "";
    "gecko.handlerService.schemes.irc.0.uriTemplate" = "";

    "font.default.x-western" = "sans-serif";

    # Preferences for the Get Add-ons panel.
    "extensions.webservice.discoverURL" = localhost;
    "extensions.getAddons.search.url" = localhost;
    "extensions.getAddons.search.browseURL" = localhost;
    "extensions.getAddons.get.url" = localhost;
    "extensions.getAddons.link.url" = localhost;
    "extensions.getAddons.discovery.api_url" = localhost;

    "extensions.systemAddon.update.url" = "";
    "extensions.systemAddon.update.enabled" = false;

    # FIXME: find better URLs for these:
    "extensions.getAddons.langpacks.url" = localhost;
    "lightweightThemes.getMoreURL" = localhost;
    "browser.geolocation.warning.infoURL" = "";
    "browser.xr.warning.infoURL" = "";

    # Mobile.
    "privacy.announcements.enabled" = false;
    "browser.snippets.enabled" = false;
    "browser.snippets.syncPromo.enabled" = false;
    "identity.mobilepromo.android" = localhost;
    "browser.snippets.geoUrl" = localhost;
    "browser.snippets.updateUrl" = localhost;
    "browser.snippets.statsUrl" = localhost;
    "datareporting.policy.firstRunTime" = 0;
    "datareporting.policy.dataSubmissionPolicyVersion" = 2;
    "browser.webapps.checkForUpdates" = 0;
    "browser.webapps.updateCheckUrl" = localhost;
    "app.faqURL" = localhost;

    # PFS url.
    "pfs.datasource.url" = localhost;
    "pfs.filehint.url" = localhost;

    # Disable Gecko media plugins: https://wiki.mozilla.org/GeckoMediaPlugins.
    "media.gmp-manager.url.override" = "data:text/plain,";
    "media.gmp-manager.url" = "";
    "media.gmp-manager.updateEnabled" = false;
    "media.gmp-provider.enabled" = false;

    # Disable middle click content load, avoid loading urls by mistake.
    "middlemouse.contentLoadURL" = false;

    # Disable heartbeat.
    "browser.selfsupport.url" = "";

    # Disable Link to Firefox Marketplace, currently loaded with non-free "apps".
    "browser.apps.URL" = "";

    # Disable Firefox Hello.
    "loop.enabled" = false;

    # Use old style that allow javascript to be disabled.
    "browser.user_preferences.inContent" = false;

    # Don't download ads for the newtab page.
    "browser.newtabpage.directory.source" = "";
    "browser.newtabpage.directory.ping" = "";
    "browser.newtabpage.introShown" = true;
    "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;

    # Disable home snippets.
    "browser.aboutHomeSnippets.updateUrl" = "data:text/html";

    "browser.user_preferences.moreFromMozilla" = false;

    # Disable SSDP.
    "browser.casting.enabled" = false;

    # Disable directory service.
    "social.directories" = "";

    # Don't report TLS errors to Mozilla.
    "security.ssl.errorReporting.enabled" = false;

    # Crypto hardening
    # https://gist.github.com/haasn/69e19fc2fe0e25f3cff5
    # General settings.
    "security.tls.unrestricted_rc4_fallback" = false;
    "security.tls.insecure_fallback_hosts.use_static_list" = false;
    "security.tls.version.min" = 1;
    "security.ssl.require_safe_negotiation" = false;
    "security.ssl.treat_unsafe_negotiation_as_broken" = true;
    "security.ssl3.rsa_seed_sha" = true;

    # Avoid logjam attack.
    "security.ssl3.dhe_rsa_aes_128_sha" = false;
    "security.ssl3.dhe_rsa_aes_256_sha" = false;
    "security.ssl3.dhe_dss_aes_128_sha" = false;
    "security.ssl3.dhe_rsa_des_ede3_sha" = false;
    "security.ssl3.rsa_des_ede3_sha" = false;

    # Disable Pocket integration.
    "browser.pocket.enabled" = false;
    "extensions.pocket.enabled" = false;
    "extensions.pocket.api" = localhost;

    # This redirect is dead and potentially dangerous.
    "extensions.webextensions.identity.redirectDomain" = localhost;

    # Disable More from Mozilla.
    "browser.preferences.moreFromMozilla" = false;

    # Don't conceal preferences.
    "browser.preferences.experimental" = true;

    # Enable extensions by default in private mode.
    "extensions.allowPrivateBrowsingByDefault" = true;

    # Do not show unicode urls, see: https://www.xudongz.com/blog/2017/idn-phishing/.
    "network.IDN_show_punycode" = true;

    # Disable screenshots extension.
    "extensions.screenshots.disabled" = true;

    # Disable onboarding.
    "browser.onboarding.newtour" = "performance,private,addons,customize,default";
    "browser.onboarding.updatetour" = "performance,library,singlesearch,customize";
    "browser.onboarding.enabled" = false;

    # New tab settings.
    "browser.newtabpage.activity-stream.showTopSites" = false;
    "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
    "browser.newtabpage.activity-stream.disableSnippets" = true;
    "browser.newtabpage.activity-stream.tippyTop.service.endpoint" = "";

    # Enable xrender.
    "gfx.xrender.enabled" = true;

    # Disable push notifications.
    "dom.webnotifications.enabled" = false;
    "dom.webnotifications.serviceworker.enabled" = false;
    "dom.push.enabled" = false;

    # Disable recommended extensions.
    "browser.newtabpage.activity-stream.asrouter.useruser_prefs.cfr" = false;
    "extensions.htmlaboutaddons.discover.enabled" = false;
    "extensions.htmlaboutaddons.recommendations.enabled" = false;

    # Disable the settings server.
    "services.settings.server" = "";

    # Disable use of WiFi region/location information.
    "browser.region.network.scan" = false;
    "browser.region.network.url" = "";

    # Disable VPN/mobile promos.
    "browser.contentblocking.report.hide_vpn_banner" = true;
    "browser.contentblocking.report.mobile-ios.url" = "";
    "browser.contentblocking.report.mobile-android.url" = "";
    "browser.contentblocking.report.show_mobile_app" = false;
    "browser.contentblocking.report.vpn.enabled" = false;
    "browser.contentblocking.report.vpn.url" = "";
    "browser.contentblocking.report.vpn-promo.url" = "";
    "browser.contentblocking.report.vpn-android.url" = "";
    "browser.contentblocking.report.vpn-ios.url" = "";
    "browser.privatebrowsing.promoEnabled" = false;

    # Enable hardware acceleration.
    "media.ffmpeg.vaapi.enabled" = true;
    "media.ffvpx.enabled" = true;

    # Disable hardware acceleration.
    # "media.ffmpeg.vaapi.enabled" = false;
    # "media.ffvpx.enabled" = false;
    # "gfx.direct2d.disabled" = true;

    # Disable Form Autofill.
    "extensions.formautofill.addresses.enabled" = false;
    "extensions.formautofill.creditCards.enabled" = false;

    # Disable breach detection.
    "signon.management.page.breach-alerts.enabled" = false;
    "signon.management.page.breachAlertUrl" = localhost;

    # https://blog.privacyguides.org/2024/07/14/mozilla-disappoints-us-yet-again-2/
    "dom.private-attribution.submission.enabled" = false;
  };
  preferences-extended = {
    # Don't install openh264 codec.
    "media.gmp-gmpopenh264.enabled" = false;
    "media.gmp-eme-adobe.enabled" = false;

    # Disable AV1 codec.
    "media.av1.enabled " = false;

    # Disable WebGL
    "webgl.disabled" = true;
  };

  # We want to lock as many preferences as possible. Having the configuration
  # state be mutable is a light security risk, and conflicts with the goal of
  # immutability.
  # https://mozilla.github.io/policy-templates/#preferences
  policyNamespaces = [
    "accessibility."
    "alerts."
    "app.update."
    "browser."
    "datareporting.policy."
    "dom."
    "extensions."
    "general.autoScroll"
    "general.smoothScroll"
    "geo."
    "gfx."
    "intl."
    "keyword.enable"
    "layers."
    "layout."
    "media."
    "network."
    "pdfjs."
    "places."
    "pref."
    "print."
    "privacy.globalprivacycontrol.enabled"
    "privacy.userContext.enabled"
    "privacy.userContext.ui.enabled"
    "signon."
    "spellchecker."
    "toolkit.legacyUserProfileCustomizations.stylesheets"
    "ui."
    "widget."
    "xpinstall.signatures.required"
    "xpinstall.whitelist.required"

    "security.default_personal_cert"
    "security.disable_button.openCertManager"
    "security.disable_button.openDeviceManager"
    "security.insecure_connection_text.enabled"
    "security.insecure_connection_text.pbmode.enabled"
    "security.mixed_content.block_active_content"
    "security.mixed_content.block_display_content"
    "security.mixed_content.upgrade_display_content"
    "security.osclientcerts.autoload"
    "security.OCSP.enabled"
    "security.OCSP.require"
    "security.osclientcerts.assume_rsa_pss_support"
    "security.ssl.enable_ocsp_stapling"
    "security.ssl.errorReporting.enabled"
    "security.ssl.require_safe_negotiation"
    "security.tls.enable_0rtt_data"
    "security.tls.hello_downgrade_check"
    "security.tls.version.enable-deprecated"
    "security.warn_submit_secure_to_insecure"
  ];
  startsWith = prefix: str: builtins.substring 0 (builtins.stringLength prefix) str == prefix;
  preferenceAppliesToPolicies = preference: (
    lib.lists.foldl'
    (a: b: a || b)
    false
    (map (namespace: startsWith namespace preference) policyNamespaces)
  );

  mkPolicyPreferences = prefs:
    (lib.mapAttrs
      (key: value: lock value)
      (lib.filterAttrs (key: value: (preferenceAppliesToPolicies key)) prefs)
    );

  mkUserPreferences = prefs:
    (lib.mapAttrs
      (key: value: value)
      (lib.filterAttrs (key: value: !(preferenceAppliesToPolicies key)) prefs)
    );

  lock = value: {
    Value = value;
    Status = "locked";
    Type = {
      "int" = "number";
      "bool" = "boolean";
      "string" = "string";
      "float" = "number";
      "set" = "string";
    }.${builtins.typeOf value};
  };
  localhost = "http://127.0.0.1/";
in

{
  home.file.".mozilla/firefox/default/chrome/firefox-gnome-theme".source = inputs.firefox-gnome-theme;
  home.file.".mozilla/firefox/unsafe/chrome/firefox-gnome-theme".source = inputs.firefox-gnome-theme;
  programs.firefox = {
    enable = true;
    inherit package;
    inherit policies;
    inherit profiles;
  };
}

