#include "../drivers/screen.h"

void main() {
    // Baby's first OS program!
    clear_screen();
    print("Hello world!"); // We updated the cursor position when we switched to 32 bit, so this'll print from the correct position
}