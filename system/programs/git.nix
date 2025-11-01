{
  pkgs,
  ...
}: {
  programs.git = {
    enable = true;
    userName = "nix server";
    userEmail = "nix@example.com";
  };
}
