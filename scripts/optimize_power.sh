#!/bin/bash

sudo systemctl enable --now power-profiles-daemon
powerprofilesctl list
powerprofilesctl set performance