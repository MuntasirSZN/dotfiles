# User accounts.
{ pkgs, ... }:

{
  users.users.muntasir = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "video"
      "input"
      "docker"
      "ydotool"
    ];
    shell = pkgs.fish;
  };
}
