#import "raylib";
#load "snek.jai";

main :: () {
	init();
	while !WindowShouldClose() {
		update();
		render();
	}
}
