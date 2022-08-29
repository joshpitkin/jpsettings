export http_proxy=http://proxy-web.micron.com:80
export https_proxy=http://proxy-web.micron.com:80
export HTTP_PROXY=http://proxy-web.micron.com:80
export HTTPS_PROXY=http://proxy-web.micron.com:80
export NO_PROXY=.micron.com
if [ -e /home/jpitkin/.nix-profile/etc/profile.d/nix.sh ]; then . /home/jpitkin/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer
