# Time zone, locale, console settings.
{ ... }:

{
  time.timeZone = "Asia/Dhaka";

  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocales = [ "bn_BD/UTF-8" ];
  };

  console = {
    useXkbConfig = true;
    earlySetup = true;
  };
}
