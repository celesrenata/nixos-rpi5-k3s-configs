{ ... }:
{
  nix.buildMachines = [
    {
      hostName = "goblin-1";
      systems = ["aarch64-linux"];
      protocol = "ssh-ng";
      maxJobs = 4;
      speedFactor = 2;
      supportedFeatures = [ "nixos-test" ];
    }
    {
      hostName = "goblin-3";
      systems = ["aarch64-linux"];
      protocol = "ssh-ng";
      maxJobs = 4;
      speedFactor = 2;
      supportedFeatures = [ "nixos-test" ];
    } 
 ];
  nix.distributedBuilds = true;
  nix.extraOptions = ''
    builders-use-substitutes = true
  '';
}
