{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # comms and browsers
    slack
    element-desktop
    zoom-us
    google-chrome
    firefox
    protonvpn-gui
    ookla-speedtest

    # Development
    #minicom
    usbutils

    # Generic code
    cmake
    coreutils
    gnumake
    nodePackages_latest.nodejs
    llvm
    gcc
    nixos-generators
    clang-tools

    #IDE
    vim
    vscode

    #LLM 
    gemini-cli-bin
    claude-code
    
  ];

  services = {
    ssh-agent.enable = true;
  };
}
