#!/bin/bash

PKGLIST="$1"

if [[ $# -eq 0 ]]; then
    echo "provide package list (can be obtained via paru -Qqe)"
    exit 1
fi

# Create a backup of current installed packages
paru -Qqe > "$PKGLIST.bak"

# Get current packages
CURRENT=$(paru -Qqe | sort)

# Get desired packages (clean)
DESIRED=$(grep -v '^#' "$PKGLIST" | grep -v '^$' | sort)

# Confirmation function
confirm() {
    read -p "$1 (y/n) " -n 1 -r
    echo
    [[ $REPLY =~ ^[Yy]$ ]]
}

# Show packages to be removed and ask for confirmation
TO_REMOVE=$(comm -23 <(echo "$CURRENT") <(echo "$DESIRED"))
if [ -n "$TO_REMOVE" ]; then
    echo "The following packages will be REMOVED:"
    echo "$TO_REMOVE"
    if confirm "Proceed with removal?"; then
        echo "$TO_REMOVE" | paru -Rns --noconfirm -
    else
        echo "Removal skipped."
    fi
else
    echo "No packages to remove."
fi

# Show packages to be installed and ask for confirmation
TO_INSTALL=$(comm -13 <(echo "$CURRENT") <(echo "$DESIRED"))
if [ -n "$TO_INSTALL" ]; then
    echo "The following packages will be INSTALLED:"
    echo "$TO_INSTALL"
    if confirm "Proceed with installation?"; then
        echo "$TO_INSTALL" | xargs -r paru -S --needed --noconfirm --skipreview --asexplicit
    else
        echo "Installation skipped."
    fi
else
    echo "No packages to install."
fi
