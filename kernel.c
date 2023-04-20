void main() {
    // Pointer to top left text cell of screen
    const int WHITE_ON_BLACK= 0x0f;
    char* video_memory = (char*) 0xb8000;

    // Add offset to start printing on the next line after boot sect printed
    video_memory += (160 * 20);

    // Assign 'X' to address at pointer
    *video_memory = 'X';
    video_memory += 1;
    *video_memory = WHITE_ON_BLACK;


    // Figuring out screen dimensions

    // for (int i = 0; i < 80; i++) {
    //     // Assign 'X' to address at pointer
    //     *video_memory = 'X';
    //     // video_memory += 2;
    //     video_memory += (80 * 2);
    // }
}