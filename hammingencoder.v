module hammingencoder (
    input  [7:0] data_in,         // 8-bit input
    output [12:0] encoded_out     // 13-bit encoded output as per required order
);
    wire [11:0] hamming_bits;
    wire p1, p2, p4, p8;
    wire wp;

    // Assign input bits to Hamming standard positions
    // Bit positions [1-12]:
    // [2]  = D1 = data_in[0]
    // [4]  = D2 = data_in[1]
    // [5]  = D3 = data_in[2]
    // [6]  = D4 = data_in[3]
    // [8]  = D5 = data_in[4]
    // [9]  = D6 = data_in[5]
    // [10] = D7 = data_in[6]
    // [11] = D8 = data_in[7]

    assign hamming_bits[2]  = data_in[0]; // D1
    assign hamming_bits[4]  = data_in[1]; // D2
    assign hamming_bits[5]  = data_in[2]; // D3
    assign hamming_bits[6]  = data_in[3]; // D4
    assign hamming_bits[8]  = data_in[4]; // D5
    assign hamming_bits[9]  = data_in[5]; // D6
    assign hamming_bits[10] = data_in[6]; // D7
    assign hamming_bits[11] = data_in[7]; // D8

    // Calculate Hamming parity bits
    assign p1 = hamming_bits[2] ^ hamming_bits[4] ^ hamming_bits[6] ^ hamming_bits[8] ^ hamming_bits[10];
    assign p2 = hamming_bits[2] ^ hamming_bits[5] ^ hamming_bits[6] ^ hamming_bits[9] ^ hamming_bits[10];
    assign p4 = hamming_bits[4] ^ hamming_bits[5] ^ hamming_bits[6] ^ hamming_bits[11];
    assign p8 = hamming_bits[8] ^ hamming_bits[9] ^ hamming_bits[10] ^ hamming_bits[11];

    assign hamming_bits[0] = p1;
    assign hamming_bits[1] = p2;
    assign hamming_bits[3] = p4;
    assign hamming_bits[7] = p8;

    // Word parity is parity of all 12 bits
    assign wp = ^hamming_bits;

    // Final output assignment as per your required order:
    assign encoded_out = {
        wp,              // [12] WP
        hamming_bits[11],// [11] D8
        hamming_bits[10],// [10] D7
        hamming_bits[9], // [9]  D6
        hamming_bits[8], // [8]  D5
        hamming_bits[7], // [7]  P8
        hamming_bits[6], // [6]  D4
        hamming_bits[5], // [5]  D3
        hamming_bits[4], // [4]  D2
        hamming_bits[3], // [3]  P4
        hamming_bits[2], // [2]  D1
        hamming_bits[1], // [1]  P2
        hamming_bits[0]  // [0]  P1
    };

endmodule
