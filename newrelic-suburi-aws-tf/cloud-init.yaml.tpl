#cloud-config

timezone: Asia/Tokyo
package_update: true
packages:
  - ansible
  - neovim
  - git
  - jq
  - tmux
  - tree
  - psmisc
  - net-tools
  - nginx

# psmisc: pstreeのため
# net-tools: ifconfigのため

runcmd:
  - hostnamectl set-hostname ${hostname}

# git clone https://github.com/sunakan/isucon-suburi.git
