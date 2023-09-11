#include "screen.h"
#include "../kernel/low_level.h"
#include "../kernel/utils.h"

void print_at(char *message, int col, int row) {
    if (col >= 0 && row >= 0) {
        set_cursor(get_screen_offset(col, row)); // Set the cursor at the start of printing if not printing where the cursor already was
        // It also gets updated at the end of printing to leave it just after the last pirnted character
    }

    int i = 0;
    while (message[i] != 0) {
        print_char(message[i], -1, -1, WHITE_ON_BLACK);
        i++; // We can technically increment after passing in on the previous line with i++, but I find that less readable
    }
}

void print(char *message) {
    print_at(message, -1, -1); // Passing in negative positions means use the cursor position to print
    print_char('\n', -1, -1, WHITE_ON_BLACK); // Add trailing newline
}

void clear_screen() {
    for (int row = 0; row < MAX_ROWS; row++) {
        for (int col = 0; col < MAX_COLS; col++) {
            print_char(' ', col, row, WHITE_ON_BLACK);
        }
    }

    set_cursor(get_screen_offset(0, 0));
}

void print_char(char character, int col, int row, char attribute_byte) {
    unsigned char *vidmem = (unsigned char *) VIDEO_ADDRESS;

    if (!attribute_byte) {
        attribute_byte = WHITE_ON_BLACK;
    }

    int offset; // Calculating video memory offset for screen position
    if (col >= 0 && row >= 0) {
        // If col and row are non-negative use them
        offset = get_screen_offset(col, row);
    } else {
        // If they're negative, use the cursor position
        offset = get_cursor();
    }

    if (character == '\n') {
        // To implement newline characters, we're just going to move the cursor to tthe end of the current row
        // Could maybe implement this with the "\r\n" format we tried in the kernel? But we still need to move the cursor
        // so it's maybe not worth it
        int rows = offset / (2 * MAX_COLS);
        offset = get_screen_offset(79, rows);
    } else {
        vidmem[offset] = character;
        vidmem[offset + 1] = attribute_byte;
    }

    // Update offset to next cell, two bytes along
    offset += 2;
    offset = handle_scrolling(offset); // If we reach the bottom of the screen we need to handle scrolling
    set_cursor(offset);
}

int get_screen_offset(int col, int row) {
    // MAX_COLS is the number of cells in one row, multiply by row to get number of cells in multiple rows
    // Add col to get the position on the row
    // Multiply by 2 as each ell is two bytes
    int offset = ((row * MAX_COLS) + col) * 2;
    return offset;
}

int get_cursor() {
    // Screen controller uses registers 14 and 15 for the high and low byte of the cursor offset
    // Send the register number to CTRL port to select register
    // Read from DATA port to get the offset
    port_byte_out(REG_SCREEN_CTRL, 14);
    int offset = port_byte_in(REG_SCREEN_DATA) << 8; // bit shift left by a byte as this is the high byte of the offset word
    port_byte_out(REG_SCREEN_CTRL, 15);
    offset += port_byte_in(REG_SCREEN_DATA); // Low byte doesn't need to be shifted

    return offset * 2; // Times 2 to get vidmem position from cell position
}

void set_cursor(int offset) {
    // Same as get_cursor but in reverse
    offset /= 2; // Divide by 2 to get mem position from cell position
    port_byte_out(REG_SCREEN_CTRL, 14);
    port_byte_out(REG_SCREEN_DATA, (unsigned char)(offset >> 8)); // Cast to char for a byte, and bit shift left a byte to get the high byte and discrad the low byte
    port_byte_out(REG_SCREEN_CTRL, 15);
    port_byte_out(REG_SCREEN_DATA, (unsigned char)offset); // Not sure if the high byte gets truncated off when we cast to char
}

int handle_scrolling(int offset) {
    if (offset < MAX_ROWS * MAX_COLS * 2) {
        return offset;
    }
    
    int i; // Define at this scope as we use it in multiple loops
    // Copy every line to the line above
    for (i = 0; i < MAX_ROWS; i++) {
        memory_copy(
            (char *)get_screen_offset(0, i) + VIDEO_ADDRESS,
            (char *)get_screen_offset(0, i - 1) + VIDEO_ADDRESS,
            MAX_COLS * 2
        );
    }

    // Clear the last line which was duplicated because nothing overwrote it
    char *last_line = (char *)get_screen_offset(0, MAX_ROWS - 1) + VIDEO_ADDRESS;
    for (i = 0; i < MAX_COLS * 2; i++) {
        last_line[i] = 0;
    }

    // Move the offset back one row, so it's no longer off the bottom
    offset -= 2 * MAX_COLS;
    return offset;
}
