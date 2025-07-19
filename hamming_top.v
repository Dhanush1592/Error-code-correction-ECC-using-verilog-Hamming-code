`timescale 1ns / 1ps
module hamming_top (
    input  [7:0] data_in,
    input  [12:0] corrupted_input,  // Optionally use this instead of encoded_out
    input        use_corrupted,     // If 1, use corrupted_input directly for decoding
    output [12:0] encoded_out,
    output [7:0] corrected_data,
    output [3:0] syndrome,
    output word_parity,
    output [1:0] error_type
);
    wire [12:0] internal_encoded;

    hammingencoder encoder (
        .data_in(data_in),
        .encoded_out(internal_encoded)
    );

    assign encoded_out = internal_encoded;

    // Use either encoded output or externally injected corrupted data
    wire [12:0] decode_input = (use_corrupted) ? corrupted_input : internal_encoded;

    hammingdecoder decoder (
        .encoded_in(decode_input),
        .data_out(corrected_data),
        .syndrome(syndrome),
        .word_parity(word_parity),
        .error_type(error_type)
    );

endmodule
