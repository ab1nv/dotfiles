#!/bin/bash

yay -S cloudflare-warp-bin --needed --noconfirm
sudo systemctl start warp-svc
warp-cli registration new
warp-cli connect
warp-cli mode doh
warp-cli dns families off
curl https://www.cloudflare.com/cdn-cgi/trace/
sudo systemctl enable warp-svc
