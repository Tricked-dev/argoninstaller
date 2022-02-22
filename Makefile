INNO_VERSION=6.2.0
TEMP_DIR=/tmp/tmodinstaller-tar
USR_SHARE=deb-struct/usr/share
BUNDLE_DIR=build/linux/x64/release/bundle
MIRRORLIST=${PWD}/build/mirrorlist
deb: 
		mkdir -p ${USR_SHARE}/tmodinstaller\
		&& mkdir -p $(USR_SHARE)/applications $(USR_SHARE)/icons/tmodinstaller $(USR_SHARE)/tmodinstaller $(USR_SHARE)/appdata\
		&& cp -r $(BUNDLE_DIR)/* $(USR_SHARE)/tmodinstaller\
		&& cp linux/tmodinstaller.desktop $(USR_SHARE)/applications/\
		&& cp linux/com.github.Tricked-dev.TModInstaller.appdata.xml $(USR_SHARE)/appdata/tmodinstaller.appdata.xml\
		&& cp assets/tmodinstaller-logo.png $(USR_SHARE)/icons/tmodinstaller\
		&& sed -i 's|com.github.Tricked-dev.TModInstaller|tmodinstaller|' $(USR_SHARE)/appdata/tmodinstaller.appdata.xml\
		&& dpkg-deb -b deb-struct/ build/TModInstaller-linux-x86_64.deb

tar:
		mkdir -p $(TEMP_DIR)\
		&& cp -r $(BUNDLE_DIR)/* $(TEMP_DIR)\
		&& cp linux/tmodinstaller.desktop $(TEMP_DIR)\
		&& cp assets/tmodinstaller-logo.png $(TEMP_DIR)\
		&& cp linux/com.github.Tricked-dev.TModInstaller.appdata.xml $(TEMP_DIR)\
		&& tar -cJf build/TModInstaller-linux-x86_64.tar.xz -C $(TEMP_DIR) .\
		&& rm -rf $(TEMP_DIR)

appimage:
				 appimage-builder --recipe AppImageBuilder.yml\
				 && mv TModInstaller-*-x86_64.AppImage build

aursrcinfo:
					 docker run -e EXPORT_SRC=1 -v ${PWD}/aur-struct:/pkg -v ${MIRRORLIST}:/etc/pacman.d/mirrorlist:ro whynothugo/makepkg

publishaur: 
					 echo '[Warning!]: you need SSH paired with AUR'\
					 && rm -rf build/tmodinstaller\
					 && git clone ssh://aur@aur.archlinux.org/tmodinstaller-bin.git build/tmodinstaller\
					 && cp aur-struct/PKGBUILD aur-struct/.SRCINFO build/tmodinstaller\
					 && cd build/tmodinstaller\
					 && git add .\
					 && git commit -m "${MSG}"\
					 && git push

innoinstall:
						powershell curl -o build\installer.exe http://files.jrsoftware.org/is/6/innosetup-${INNO_VERSION}.exe
		 				powershell build\installer.exe /verysilent /allusers /dir=build\iscc

inno:
		 powershell build\iscc\iscc.exe scripts\windows-setup-creator.iss

choco:
			powershell cp build\installer\TModInstaller-windows-x86_64-setup.exe choco-struct\tools
			powershell choco pack .\choco-struct\tmodinstaller.nuspec  --outputdirectory build

gensums:
				sh -c scripts/gensums.sh