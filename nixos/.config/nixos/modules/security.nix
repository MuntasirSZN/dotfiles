# Security-related options.
{ ... }:

{
  security = {
    tpm2.enable = true;
    rtkit.enable = true;
    sudo-rs.enable = true;
  };
}
