{ ... }:

{
  services.xserver.videoDrivers = [ "nvidia" ];

  # https://wiki.archlinux.org/index.php/NVIDIA/Troubleshooting#Avoid_screen_tearing
  services.xserver.screenSection = ''
    Option "metamodes" "nvidia-auto-select +0+0 {ForceCompositionPipeline=On, ForceFullCompositionPipeline=On}"
    Option "TipleBuffer" "on"
    Option "AllowIndirectGLXProtocol" "off"
  '';

}
