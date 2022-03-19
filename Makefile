INNO_VERSION=6.2.0
TEMP_DIR=/tmp/argoninstaller-tar
USR_SHARE=deb-struct/usr/share
BUNDLE_DIR=build/linux/x64/release/bundle
MIRRORLIST=${PWD}/build/mirrorlist
deb: 
		mkdir -p ${USR_SHARE}/argoninstaller\
		&& mkdir -p $(USR_SHARE)/applications $(USR_SHARE)/icons/argoninstaller $(USR_SHARE)/argoninstaller $(USR_SHARE)/appdata\
		&& cp -r $(BUNDLE_DIR)/* $(USR_SHARE)/argoninstaller\
		&& cp linux/argoninstaller.desktop $(USR_SHARE)/applications/\
		&& cp linux/com.github.Tricked-dev.ArgonInstaller.appdata.xml $(USR_SHARE)/appdata/argoninstaller.appdata.xml\
		&& cp assets/argoninstaller-logo.png $(USR_SHARE)/icons/argoninstaller\
		&& sed -i 's|com.github.Tricked-dev.ArgonInstaller|argoninstaller|' $(USR_SHARE)/appdata/argoninstaller.appdata.xml\
		&& dpkg-deb -b deb-struct/ build/ArgonInstaller-linux-x86_64.deb

tar:
		mkdir -p $(TEMP_DIR)\
		&& cp -r $(BUNDLE_DIR)/* $(TEMP_DIR)\
		&& cp linux/argoninstaller.desktop $(TEMP_DIR)\
		&& cp assets/argoninstaller-logo.png $(TEMP_DIR)\
		&& cp linux/com.github.Tricked-dev.ArgonInstaller.appdata.xml $(TEMP_DIR)\
		&& tar -cJf build/ArgonInstaller-linux-x86_64.tar.xz -C $(TEMP_DIR) .\
		&& rm -rf $(TEMP_DIR)

appimage:
				 appimage-builder --recipe AppImageBuilder.yml\
				 && mv ArgonInstaller-*-x86_64.AppImage build

aursrcinfo:
					 docker run -e EXPORT_SRC=1 -v ${PWD}/aur-struct:/pkg -v ${MIRRORLIST}:/etc/pacman.d/mirrorlist:ro whynothugo/makepkg

publishaur: 
					 echo '[Warning!]: you need SSH paired with AUR'\
					 && rm -rf build/argoninstaller\
					 && git clone ssh://aur@aur.archlinux.org/argoninstaller-bin.git build/argoninstaller\
					 && cp aur-struct/PKGBUILD aur-struct/.SRCINFO build/argoninstaller\
					 && cd build/argoninstaller\
					 && git add .\
					 && git commit -m "${MSG}"\
					 && git push

innoinstall:
						powershell curl -o build\installer.exe http://files.jrsoftware.org/is/6/innosetup-${INNO_VERSION}.exe
		 				powershell build\installer.exe /verysilent /allusers /dir=build\iscc

inno:
		 powershell build\iscc\iscc.exe scripts\windows-setup-creator.iss

choco:
			powershell cp build\installer\ArgonInstaller-windows-x86_64-setup.exe choco-struct\tools
			powershell choco pack .\choco-struct\argoninstaller.nuspec  --outputdirectory build

gensums:
				sh -c scripts/gensums.sh