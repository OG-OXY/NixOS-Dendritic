#config.nix
{
  pkgs,
  lib,
  inputs,
  self,
  ...
}:

{
  imports = [
    ./systemModules.nix
  ];

  # Bootloader + GRUB parameters.
  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
    };
    grub = {
      enable = true;
      device = "nodev";
      efiSupport = true;
      useOSProber = true;
      configurationLimit = 30;
    };
  };

  # NIX-PKG-Manager parameters.
  nix = {
    settings = {
      auto-optimise-store = true;
      download-buffer-size = 536870912;
      max-substitution-jobs = 128;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
    # Garbage collection.
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 5d";
    };
  };

  # User account.
  security = {
    polkit.enable = true;
    doas = {
      enable = true;
      extraRules = [
        {
          users = [ "ty" ];
          noPass = true;
          keepEnv = true;
        }
      ];
    };
    sudo = {
      enable = true;
      extraRules = [
        {
          groups = [ "wheel" ];
          commands = [
            {
              command = "ALL";
              options = [ "NOPASSWD" ];
            }
          ];
        }
      ];
    };
  };

  # User parameters.
  users = {
    mutableUsers = true;
    users.root.shell = pkgs.fish;
    users.ty = {
      shell = pkgs.fish;
      isNormalUser = true;
      extraGroups = [
        "wheel"
        "networkmanager"
        "video"
        "render"
        "input"
        "audio"
        "docker"
        "libvirtd"
        "vboxusers"
        "wireshark"
        "tcpdump"
      ];
    };
  };

  # Networking PKGS + parameters.
  networking = {
    hostName = "nixos";
    networkmanager = {
      enable = true;
      wifi.backend = "iwd";
      dns = "dnsmasq";
    };
    firewall = {
      allowedTCPPorts = [ 22 ];
      trustedInterfaces = [ "tailscale0" ];
    };
    wireless.enable = false;
  };

  # Install PKGS with system parameters.
  programs = {
    hyprland = {
      enable = true;
      withUWSM = true;
      xwayland.enable = true;
    };
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    fish.enable = true;
    zoxide.enable = true;
    gamemode.enable = true;
    steam.enable = true;
    virt-manager.enable = true;
    nano.enable = false;
  };

  fonts = {
    packages = with pkgs; [
      nerd-fonts.jetbrains-mono
      nerd-fonts.fira-code
      font-awesome
      inter
    ];
    fontconfig = {
      enable = true;
      defaultFonts = {
        monospace = [
          "JetBrainsMono Nerd Font"
          "Font Awesome 6 Free"
          "Font Awesome 6 Brands"
          "FiraCode Nerd Font"
          "Inter"
        ];
        sansSerif = [
          "Inter"
          "Font Awesome 6 Free"
          "Font Awesome 6 Brands"
          "JetBrainsMono Nerd Font"
          "FiraCode Nerd Font"
        ];
        serif = [
          "Inter"
          "Font Awesome 6 Free"
          "Font Awesome 6 Brands"
          "JetBrainsMono Nerd Font"
          "FiraCode Nerd Font"
        ];
      };
      #localConf = ''
      #
      #'';
    };
  };

  # Install system PKGS.
  environment = {
    shells = with pkgs; [ fish ];
    variables = {
      CPATH = "/run/current-system/sw/include";
      LIBRARY_PATH = "/run/current-system/sw/lib";
    };
    sessionVariables = {
      NIXOS_OZONE_WL = "1";
      WLR_NO_HARDWARE_CURSORS = "1";
      EDITOR = "nvf";
      VISUAL = "nvf";
      SSH_AUTH_SOCK = "$HOME/.bitwarden-ssh-agent.sock";
      SECRETSPEC_PROVIDER = "keyring";
      GOOGLE_API_KEY = "AQ.Ab8RN6IaaXJOK7QowOW5CTMiwx6n5gVKoXwfG2UCwDwVzCChJA";
      GEMINI_API_KEY = "AQ.Ab8RN6IaaXJOK7QowOW5CTMiwx6n5gVKoXwfG2UCwDwVzCChJA";
      ANTHROPIC_API_KEY = "local";
      ANTHROPIC_AUTH_TOKEN = "ollama";
      ANTHROPIC_BASE_URL = "http://127.0.0.1:11434";
      ANTHROPIC_DEFAULT_SONNET_MODEL = "qwen-32b";
      ANTHROPIC_DEFAULT_OPUS_MODEL = "qwen2.5-coder";
      ANTHROPIC_DEFAULT_HAIKU_MODEL = "qwen2.5-coder";
      OLLAMA_CONTEXT_LENGTH = "32768";
      CLAUDE_CODE_ATTRIBUTION_HEADER = "0";
      CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC = "1";
      NODE_OPTIONS = "--dns-result-order=ipv4first";
    };
    systemPackages =
      with pkgs;
      [
        stdenv.cc
        binutils
        gnumake
        cmake
        pkg-config
        gdb
        valgrind
        hyprpolkitagent
        watchman
        pinentry-gnome3
        waybar
        mako
        wofi
        ghostty
        yazi
        hyprpaper
        bitwarden-desktop
        vesktop
        pavucontrol
        qalculate-gtk
        #CLI-Tools.
        git
        gh
        nix-output-monitor
        nvd
        nh
        just
        fh
        rbw
        secretspec
        rofi-rbw-wayland
        mpd
        mpv
        imv
        hyprshot
        hyprpicker
        btop
        tree
        dysk
        tealdeer
        wl-clipboard
        cliphist
        wtype
        curl
        w3m
        wget
        wget2
        fzf
        ripgrep
        herdr
        llama-cpp
        aider-chat
        fd
        bun
        devenv
        starship
        atuin
        # Formatters.
        nixfmt
        jq
      ]
      ++ [
        inputs.zen-browser.packages.${pkgs.system}.default
        inputs.nvf.packages.${pkgs.system}.default
        inputs.llm-agents.packages.${pkgs.system}.default
        #pkgs.cudaPackages.cuda_nvcc
        #pkgs.cudaPackages.cudatoolkit
      ];
    etc = {
    };
  };

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
    config.common.default = "*";
  };

  hardware = {
    i2c.enable = true;
    keyboard.qmk.enable = true;
    bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings.General.Experimental = true;
    };
  };

  # Display Manager.
  services = {
    displayManager.regreet = {
      enable = true;
      cageArgs = [
        "-s"
        "-m"
        "clone"
      ];
      settings = {
        background = {
          path = "/etc/nixos/wallpaper.png";
          fit = "Cover";
        };
        #theme = {
        #  package = "";
        #  name = "";
        #};
        #iconTheme = {
        #  package = "";
        #  name = "";
        #};
        #cursorTheme = {
        #  package = "";
        #  name = "";
        #};
        #GTK = {
        #  theme_name = "Adwaita-dark";
        #  icon_theme_name = "Adwaita";
        #  cursor_theme_name = "";
        #  font_name = lib.mkDefault "Inter 11";
        #};
        commands = {
          reboot = [
            "doas"
            "reboot"
            "now"
          ];
          shutdown = [
            "doas"
            "shutdown"
            "now"
          ];
        };
        #extraCss = ''
        #'';
      };
    };
    greetd.enable = true;
    kmscon.enable = true;
    tailscale.enable = true;
    gnome.gnome-keyring.enable = true;
    power-profiles-daemon.enable = true;
    hardware.openrgb = {
      enable = true;
      package = pkgs.openrgb-with-all-plugins;
      motherboard = "amd";
    };
    logind.settings = {
      Login = {
        IdleAction = "ignore";
        HandleLidSwitch = "ignore";
        HandleLidSwitchExternalPower = "ignore";
      };
    };
    pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
    };
    zram-generator = {
      enable = true;
      settings = {
        zram0 = {
          compression-algorithm = "lz4";
          zram-size = 16384;
        };
      };
    };
    openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
        PermitRootLogin = "no";
      };
    };
    ollama = {
      enable = true;
      package =
        (pkgs.ollama-cuda.override {
        }).overrideAttrs
          (oldAttrs: {
            cmakeFlags = (oldAttrs.cmakeFlags or [ ]) ++ [
              "-DCMAKE_CUDA_ARCHITECTURES=61"
            ];
          });
    };
    llama-cpp = {
      enable = true;
      settings = {
        hf-repo = "Qwen/Qwen2.5-Coder-32B-Instruct-GGUF";
        hf-file = "qwen2.5-coder-32b-instruct-q4_k_m.gguf";
        host = "0.0.0.0";
        port = 8012;
        jinja = true;
        flash-attn = "on";
        ctx-size = 32768;
        cache-type-k = "q8_0";
        cache-type-v = "q8_0";
        n-gpu-layers = 40;
      };
      package =
        (pkgs.llama-cpp.override {
          cudaSupport = true;
        }).overrideAttrs
          (oldAttrs: {
            cmakeFlags = (oldAttrs.cmakeFlags or [ ]) ++ [
              "-DCMAKE_CUDA_ARCHITECTURES=61"
            ];
          });
    };
    resolved.enable = false;
    libinput.enable = false;
    printing.enable = false;
  };

  powerManagement.cpuFreqGovernor = "performance";

  systemd = {
    targets = {
      sleep.enable = false;
      suspend.enable = false;
      hibernate.enable = false;
      hybrid-sleep.enable = false;
    };
    services = {
      ollama.wantedBy = pkgs.lib.mkForce [ ];
      llama-cpp.wantedBy = pkgs.lib.mkForce [ ];
    };
    user.services = {
      waybar = {
        unitConfig = {
          After = [ "graphical-session.target" ];
          Requires = [ "dbus.socket" ];
        };
        serviceConfig = {
          ExecStartPre = "${pkgs.glib}/bin/gdbus wait --system net.hadess.PowerProfiles";
        };
      };
      rbw-autounlock = {
        description = "Securely unlock Bitwarden Vault on Hyprland Startup";
        wantedBy = [ "graphical-session.target" ];
        unitConfig = {
          After = [ "graphical-session.target" ];
          PartOf = [ "graphical-session.target" ];
        };
        serviceConfig = {
          Type = "oneshot";
          Environment = [
            "WAYLAND_DISPLAY=wayland-0"
            "DISPLAY=:0"
          ];
          ExecStart = "${pkgs.rbw}/bin/rbw unlock";
          RemainAfterExit = false;
        };
      };
    };
  };

  # NixOS VM sandbox.
  virtualisation = {
    vmVariant = {
      users.users = {
        ty.password = "test";
        root.password = "test";
      };
      virtualisation = {
        memorySize = 8192;
        cores = 8;
        qemu.options = [ "-device virtio-vga-gl -display gtk,gl=on" ];
      };
    };
    libvirtd = {
      enable = true;
      onBoot = "ignore";
      onShutdown = "shutdown";
      qemu = {
        package = pkgs.qemu_kvm;
        runAsRoot = true;
      };
    };
    podman = {
      enable = true;
      dockerCompat = true;
    };
    containers.enable = true;
    oci-containers = {
      backend = "podman";
      containers = {
        #unsloth-proxy = {
        # image = "docker.io/unsloth/unsloth:latest";
        # autoStart = true;
        # ports = [ "4000:4000" ];
        # extraOptions = [ "--network=host" ];
        # cmd = [
        #   "unsloth run \
        #    -H 127.0.0.1 \
        #     -p 4000"
        #  ];
        #};
      };
    };
  };

  # Time zone.
  time.timeZone = "America/New_York";

  # Origin NixOS install version, NEVER CHANGE.
  system = {
    stateVersion = "26.05";
    configurationRevision = lib.mkIf (self ? rev) self.rev;
    systemBuilderCommands = ''
      ln -s ${self} $out/src
    '';
  };
}
