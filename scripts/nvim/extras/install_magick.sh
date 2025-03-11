#!/usr/bin/env sh
# WARN: Only compatible with x86-64 Linux.
if ! command -v magick &> /dev/null; then
	echo "ImageMagick could not be found. Installing in ~/.local"
	mkdir -p ~/.local
	curl -s https://api.github.com/repos/ImageMagick/ImageMagick/releases/latest \
		| grep "browser_download_url.*ImageMagick-.*-gcc-x86_64.AppImage" \
		| cut -d : -f 2,3 \
		| tr -d \" \
		| wget -qi - -O magick.appimage
	chmod +x magick.appimage
	./magick.appimage --appimage-extract
	# NOTE: installing libglib will break the system's package manager.
	# Many apps depend on it and it won't work.
	# We need to remove libglib from the extracted AppImage.
	rm squashfs-root/usr/lib/libglib-2.0.so.0
	rsync -a squashfs-root/usr/ ~/.local/
	rm magick.appimage
	rm -rf squashfs-root
else
	echo "ImageMagick found at $(which magick). Skipping installation."
fi
