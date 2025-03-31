# Tenable Nessus Authenticated Scan User Deployment

This project automates the deployment of a dedicated `nessus` SSH user to multiple Linux systems for Tenable authenticated scanning.

## 📦 Features

- **SSH Key Pair Generation:** Easily generate a secure key pair for authentication.
- **User Creation:** Automatically create a `nessus` user on target hosts.
- **SSH Key Installation:** Adds the public key to the target's authorized keys.
- **Password Locking:** Locks the user’s password to enforce key-based authentication.
- **Passwordless Sudo:** Configures passwordless sudo for the `nessus` user.
- **PS1 Configuration:** Sets the shell prompt (PS1) to a compatible format for fast scan performance.
- **Mass Deployment:** Deploys the above configuration to multiple hosts using a single script.

## 🛠 Requirements

- A Linux-based admin machine with SSH access to all target hosts.
- Root or passwordless sudo access on target systems.
- For testing purposes, [Vagrant](https://www.vagrantup.com/) is recommended.

## 🚀 Usage

### 1. Generate SSH Keys

Run the following script to generate the SSH key pair:

```bash
./scripts/create_keys.sh

The keys are stored in the keys/ directory:
	•	Private key: keys/nessus_id_ecdsa
	•	Public key: keys/nessus_id_ecdsa.pub

2. Configure Target Hosts
	•	Edit the hosts/hosts.txt file to include the IP addresses of your target Linux hosts.

3. Mass Deployment

Deploy the nessus user to all target hosts:

./scripts/mass_deploy.sh

This script reads the list of target hosts and installs the nessus user along with the necessary configurations on each one.

4. Verify Deployment

Test the setup by logging in as the nessus user from your admin machine:

ssh -i keys/nessus_id_ecdsa nessus@<TARGET_IP> "id && sudo whoami"

Expected output should display the user’s details and confirm that sudo returns root.

⸻

🐳 Testing with Vagrant

You can test the deployment scripts locally using Vagrant by setting up a few virtual Linux machines. This lets you simulate target hosts in a controlled environment.

Vagrant Setup
	1.	Create a Vagrantfile in your project root with the following content:

Vagrant.configure("2") do |config|
  # Target VM: host1
  config.vm.define "host1" do |host1|
    host1.vm.box = "ubuntu/focal64"
    host1.vm.hostname = "host1"
    host1.vm.network "private_network", ip: "192.168.56.10"
    host1.vm.provision "shell", inline: <<-SHELL
      sudo apt-get update
      sudo apt-get install -y openssh-server
      sudo systemctl enable ssh
      sudo systemctl start ssh
    SHELL
  end

  # Target VM: host2
  config.vm.define "host2" do |host2|
    host2.vm.box = "ubuntu/focal64"
    host2.vm.hostname = "host2"
    host2.vm.network "private_network", ip: "192.168.56.11"
    host2.vm.provision "shell", inline: <<-SHELL
      sudo apt-get update
      sudo apt-get install -y openssh-server
      sudo systemctl enable ssh
      sudo systemctl start ssh
    SHELL
  end

  # Control VM: where you run the mass deployment script
  config.vm.define "control" do |control|
    control.vm.box = "ubuntu/focal64"
    control.vm.hostname = "control"
    control.vm.network "private_network", ip: "192.168.56.20"
    control.vm.provision "shell", inline: <<-SHELL
      sudo apt-get update
      sudo apt-get install -y openssh-client git
    SHELL
    # Mount the project folder for easy access
    control.vm.synced_folder ".", "/home/vagrant/tenable-user-deploy"
  end
end


	2.	Update hosts/hosts.txt:
Modify the file to list the target VM IP addresses:

192.168.56.10
192.168.56.11


	3.	Adjust the Remote User:
In the scripts/mass_deploy.sh file, ensure the REMOTE_USER variable is set to vagrant (as Vagrant VMs typically use vagrant for SSH access).

Testing Steps
	1.	Bring Up the Vagrant Environment:

vagrant up


	2.	SSH into the Control VM:

vagrant ssh control


	3.	Generate SSH Keys (if not already done):
Navigate to the project directory on the control VM:

cd /home/vagrant/tenable-user-deploy
./scripts/create_keys.sh


	4.	Deploy the Nessus User:
Run the mass deployment script from the control VM:

./scripts/mass_deploy.sh


	5.	Test the Deployment:
From the control VM, log into one of the target VMs as the nessus user:

ssh -i keys/nessus_id_ecdsa nessus@192.168.56.10 "id && sudo whoami"

You should see output confirming the nessus user and that it can execute sudo commands.

	6.	Cleanup:
When finished testing, you can destroy the Vagrant VMs:

vagrant destroy -f



⸻

🔐 Configuring Tenable Nessus

In your Nessus scan policy, set the following:
	•	Authentication Method: SSH
	•	Username: nessus
	•	Private Key: keys/nessus_id_ecdsa
	•	Privilege Escalation: sudo (no password required)
	•	Use sudo if available: Checked

Happy scanning!

