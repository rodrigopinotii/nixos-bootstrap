{ pkgs, ... }:
{
  systemd.services.restic-backup = {
    description = "Restic backup to S3";
    serviceConfig = {
      Type = "oneshot";
      User = "rodrigo";
      ExecStart = "${pkgs.bash}/bin/bash /home/rodrigo/.dotfiles/scripts/backup.sh";
    };
    path = with pkgs; [ restic git findutils coreutils ];
  };

  systemd.timers.restic-backup = {
    description = "Daily restic backup";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "daily";
      Persistent = true;
      RandomizedDelaySec = "1h";
    };
  };
}
