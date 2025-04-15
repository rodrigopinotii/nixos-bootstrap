# SPDX-License-Identifier: Apache-2.0
_: {
  users.users = {
    rodrigo = {
      isNormalUser = true;
      home = "/home/rodrigo";
      description = "Rodrigo Pino";
      openssh.authorizedKeys.keys = [
      ];
      extraGroups = [
        "networkmanager"
        "wheel"
        "dialout"
        "plugdev"
      ];
      shell = "/run/current-system/sw/bin/bash";
      uid = 1000;
      initialHashedPassword = "$y$j9T$DPoCoAI27lx.H47gokYUy.$q1zeyr8QS5A/tw6cc7omDAc4TLA7PR08d671VFdRID7";
    };
  };
}
