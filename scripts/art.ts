import decode from 'https://deno.land/x/wasm_image_decoder@v0.0.5/mod.js';

await Deno.copyFile(
	'assets/Argon128x128.png',
	'linux/debian/usr/share/icons/hicolor/128x128/argoninstaller.png'
);
await Deno.copyFile(
	'assets/Argon256x256.png',
	'linux/debian/usr/share/icons/hicolor/256x256/argoninstaller.png'
);
await Deno.run({
	cmd: 'ffmpeg -i assets/Argon256x256.png windows/runner/resources/icon.ico'.split(
		' '
	),
}).status();
