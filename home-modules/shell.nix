{ ... }:

{
  home.sessionVariables = {
    EDITOR = "nvim";
    PS1 = "\\[\\033[1;95m\\033[1m\\]\\w\\[\\033[0m\\]\\$ ";
  };

  home.shellAliases = {
    la = "ls -A";
    ll = "la -l -h";
  };

  programs.bash = {
    enable = true;
    initExtra = ''
      unset __HM_SESS_VARS_SOURCED
      . "/etc/profiles/per-user/$(whoami)/etc/profile.d/hm-session-vars.sh"
    '';
  };
}

