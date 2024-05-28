# nixos-rpi5-k3s-configs
This is a collection of resources I created in order to build kubernetes clusters out of RPI5s.

To configure the pi's initially, see my other [repo and branch](https://github.com/celesrenata/nix-flakes/tree/rpi5). Build out the SD card with the initial configuration provided in Step 18 of the [README.md](https://github.com/celesrenata/nix-flakes/blob/rpi5/README.md). You can then migrate over to NVME after the initial build after you complete upto step **28**. Pay attention to modify my partition table settings as described to match the `hardware-configuration.nix` from my configs

1. Copy down your UUIDs from `blkid` and import them into the `hardware-configuration.nix` after mimicking my configuration or just ignore my settings entirely and run `sudo nixos-generate-config`
2. Build out each `/etc/nixos` directory with the contents of *goblin-1, goblin-2, goblin-3* and run `sudo nixos-rebuild switch` on each machine.
3. Follow the guide from [Distributed Builds](https://nixos.wiki/wiki/Distributed_build) to allow your Pi's to share compute resources during updates or to use as a pool for other aarch64 build projects!
4. 
