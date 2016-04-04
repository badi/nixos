
{

    serverLayoutSection = ''
      Screen      0  "Screen-nvidia[0]"
      Screen      0  "Screen1" LeftOf "Screen-nvidia[0]"
      Option         "Xinerama" "1"
      Option	     "RandR"    "off"
    '';

    deviceSection = ''
      BusID          "PCI:1:0:0"
      Driver         "nvidia"
      Screen         0
    '';

    monitorSection = ''
      Option         "DPMS"
      Option         "RandRRotation" "true"
      Option	     "RandR"    "off"
    '';

    screenSection = ''
      #Option         "TwinView" "0"
    '';


    config = ''
      Section "Device"
          Identifier     "Device1"
          Driver         "nvidia"
          VendorName     "NVIDIA Corporation"
          BoardName      "GeForce GT 430"
          BusID          "PCI:3:0:0"
	  Driver         "nvidia"
	  Screen         0
      EndSection

      Section "Monitor"
          Identifier     "Monitor1"
          VendorName     "Unknown"
          ModelName      "Unknown"
          HorizSync       28.0 - 33.0
          VertRefresh     43.0 - 72.0
          Option         "DPMS"
	  Option         "RandRRotation" "false"
      EndSection

      Section "Screen"
          Identifier     "Screen1"
          Device         "Device1"
          Monitor        "Monitor1"
          DefaultDepth    24
	  #Option         "TwinView" "0"
          SubSection     "Display"
              Depth       24
          EndSubSection
      EndSection

      '';

}