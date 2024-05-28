# nixos-rpi5-k3s-configs
This is a collection of resources I created in order to build kubernetes clusters out of RPI5s.

To configure the pi's initially, see my other [repo and branch](https://github.com/celesrenata/nix-flakes/tree/rpi5). Build out the SD card with the initial configuration provided in Step 18 of the [README.md](https://github.com/celesrenata/nix-flakes/blob/rpi5/README.md). You can then migrate over to NVME after the initial build after you complete upto step **28**. Pay attention to modify my partition table settings as described to match the `hardware-configuration.nix` from my configs

### Setup the OS
1. Copy down your UUIDs from `blkid` and import them into the `hardware-configuration.nix` after mimicking my configuration or just ignore my settings entirely and run `sudo nixos-generate-config`
2. Build out each `/etc/nixos` directory with the contents of *goblin-1, goblin-2, goblin-3* and run `sudo nixos-rebuild switch` on each machine.
3. Follow the guide from [Distributed Builds](https://nixos.wiki/wiki/Distributed_build) to allow your Pi's to share compute resources during updates or to use as a pool for other aarch64 build projects!

### Setup k3s
4. SSH into goblin-1
5. `sudo cat /etc/rancher/k3s/k3s.yaml` Copy this into your main computer's `~/.kube/config` **Make sure to edit 127.0.0.1 in the config to the actual IP of goblin-1**
#### Dashboard
7. `cd dashboard`
8. `./runmefirst.sh`  # configures your dashboard
9. `./access.sh`  # enables the tunnel to your dashboard
10. `kubectl get secret dashboard-admin -n kubernetes-dashboard -o jsonpath={".data.token"} | base64 -d`  # gets credentials
11. Navigate to: https://127.0.0.1:8443/ and input the credentials you exported
#### Longhorn
12. `cd longhorn`
13. `./runmefirst.sh` # automagically configures longhorn for NIXOS paths
14. `./access.sh`  # enables the tunnel to longhorn
15. Watch from the dashboard and give the cluster 3 or 4 minutes to sort things out.
16. If it fails after that time, give it a kick with `./cleanup-and-retry.sh`
17. Please give this a few more minutes, it usually works for me on the second try!
#### Accessible MariaDB and PhpMyAdmin
18. Edit the `mariadb-secret.yaml` file with the passwords you prefer
19. `cd mariadb`
20. `./runmefirst.sh`  # Installs mariadb-operator and a DB for you
21. Edit the phpmyadmin-ingress.yaml file to reflect the hostname you prefer
22. `cd ../phpmyadmin`
23. `./runmefirst.sh`  # Installs PhpMyAdmin
#### Accessible Wordpress Dev Environment
24. Edit the `runmefirst.sh` to reflect the default username and password you prefer
25. `cd wordpress`
26. `./runmefirst.sh` # Installs WordPress

# Good Luck!

![kube-1.png](https://github.com/celesrenata/nixos-rpi5-k3s-configs/raw/main/kube-1.png)
![kube-2.png](https://github.com/celesrenata/nixos-rpi5-k3s-configs/raw/main/kube-2.png)
![kube-3.png](https://github.com/celesrenata/nixos-rpi5-k3s-configs/raw/main/kube-3.png)
