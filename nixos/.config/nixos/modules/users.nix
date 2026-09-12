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
      "i2c"
      "render"
      "uinput"
    ];
    shell = pkgs.fish;
  };
}
