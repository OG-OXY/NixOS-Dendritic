{
  ...
}:
{
  programs.jujutsu = {
    enable = true;
    settings = {
      user = {
        name = "Ty";
        email = "ogoxy.yt@gmail.com";
      };
      git = {
        auto-local-bookmark = true;
        push-revset = [ "master" ];
        default-push = "master";
      };
      signing = {
        sign-all = true;
        backend = "ssh";
        key = "~/.ssh/id_ed25519.pub";
      };
      ui = {
        editor = "nvf";
        paginate = "never"; # or "auto"
      };
      fsmonitor = {
        backend = "watchman";
      };
      revsets = {
        immutable-heads = "tracked_remote_bookmarks()";
      };
      aliases = {
        s = [ "status" ];
        l = [
          "log"
          "-r"
          "all()"
        ];
        d = [ "diff" ];

      };
    };
  };
}
