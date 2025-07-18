module hammingdecoder (
    input  [12:0] encoded_in,        // 13-bit input: WP | D8..P1
    output reg [7:0] data_out,       // Corrected 8-bit output data
    output reg [3:0] syndrome,       // 4-bit syndrome
    output reg word_parity,          // 1 if odd, 0 if even
    output reg [1:0] error_type      // 00: No error, 01: WP error, 10: Single-bit, 11: Multi-bit
);
    wire [11:0] bits;
    wire calc_wp;
    reg [11:0] corrected_bits;
    integer i;

    // Extract Hamming bits (excluding WP) and actual Word Parity (MSB)
    assign bits = encoded_in[11:0];
    assign calc_wp = ^bits;
    
    always @(*) begin
        // --- Syndrome Calculation ---
        syndrome[0] = bits[0] ^ bits[2] ^ bits[4] ^ bits[6] ^ bits[8] ^ bits[10]; // P1
        syndrome[1] = bits[1] ^ bits[2] ^ bits[5] ^ bits[6] ^ bits[9] ^ bits[10]; // P2
        syndrome[2] = bits[3] ^ bits[4] ^ bits[5] ^ bits[6] ^ bits[11];           // P4
        syndrome[3] = bits[7] ^ bits[8] ^ bits[9] ^ bits[10] ^ bits[11];          // P8

        // --- Word Parity ---
        word_parity = ^encoded_in;

        // --- Correction Logic ---
        corrected_bits = bits;

        if (syndrome != 4'b0000 && word_parity == 1'b1) begin
            // Single-bit error: correct the bit at position syndrome
            if (syndrome <= 12)
                corrected_bits[syndrome] = ~bits[syndrome];
            error_type = 2'b10; // Single-bit error
        end
        else if (syndrome == 4'b0000 && word_parity == 1'b1) begin
            // Word parity error only
            corrected_bits = bits; // leave as-is
            error_type = 2'b01;
        end
        else if (syndrome != 4'b0000 && word_parity == 1'b0) begin
            // Multi-bit error, uncorrectable
            corrected_bits = bits;
            error_type = 2'b11;
        end
        else begin
            // No error
            corrected_bits = bits;
            error_type = 2'b00;
        end

        // Extract original data bits from corrected_bits:
        // Position mapping (Hamming standard layout):
        // [2]  = D1 -> data_out[0]
        // [4]  = D2 -> data_out[1]
        // [5]  = D3 -> data_out[2]
        // [6]  = D4 -> data_out[3]
        // [8]  = D5 -> data_out[4]
        // [9]  = D6 -> data_out[5]
        // [10] = D7 -> data_out[6]
        // [11] = D8 -> data_out[7]

        data_out[0] = corrected_bits[2];
        data_out[1] = corrected_bits[4];
        data_out[2] = corrected_bits[5];
        data_out[3] = corrected_bits[6];
        data_out[4] = corrected_bits[8];
        data_out[5] = corrected_bits[9];
        data_out[6] = corrected_bits[10];
        data_out[7] = corrected_bits[11];
    end

endmodule
