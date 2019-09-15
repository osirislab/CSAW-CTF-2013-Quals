#include <stdio.h>
#include <math.h>

// gcc solve.c -o solve -O4
// ./solve  # takes 8m2s on an Ubuntu 13.04 VM with a single core
// answer is " +kbvjg" (or "\x20\x2b\x6b\x62\x76\x6a\x67") on round 91282070002

void print_str(unsigned char str[], const int str_length)
{
    int i;

    for (i = 0; i < str_length; i++) {
        printf("\\x%2.2x", str[i]);
    }
}


int main (int argc, char* argv[])
{
    // variables for looking for an ascii-printable answer (most likely case)
    unsigned char str[7] = {0};
    const int str_length = (sizeof str) / (sizeof str[0]);
    const unsigned char min_char = 0x20;
    const unsigned char max_char = 0x7e;
    const unsigned char char_range = max_char - min_char + 1; 

    // variables for bruting the checksum
    unsigned int checksum = 0;
    unsigned long long round_start = 0;
    unsigned long long round_end = pow(char_range, str_length);
    unsigned long long round = 0;
    int i; 

    // initialize the string
    for (i = str_length - 1; i >= 0; i--) {
        str[i] = min_char;
    } 

    while (round < round_end)
    {
        // calculate the checksum for the current string
        round++;
        checksum = 1337;
        for (i = 0; i < str_length; ++i) {
            checksum += str[i] + 32 * checksum;
        } 

        // print an answer if we found it
        if (checksum == 4012782936) {
            printf("*** Found: ");
            print_str(str, str_length);
            printf("on round = %llu\n", round);
            break;
        } 

        // increment the input starting at the rightmost char
        for (i = str_length - 1; i >= 0; i--) {
            if (str[i] == max_char) {
                str[i] = min_char;
            } else {
              str[i]++;
              break;
            }
        } 

        if (round % 1000000000 == 0) {
            printf("At: ");
            print_str(str, str_length);
            printf(" on round = %llu\n", round);
        }
    } 

    printf("\nFinished!\n");
}
