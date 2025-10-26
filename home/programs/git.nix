{
  pkgs,
  ...
}: {
  programs.git = {
    enable = true;
    userName = "netcdf";
    userEmail = "netcdf@example.com";
  };
}
