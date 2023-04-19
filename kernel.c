void main() {
    // Pointer to top left text cell of screen
    char* video_memory = (char*) 0xb8000;
    // Assign 'X' to address at pointer
    *video_memory = 'X';
}