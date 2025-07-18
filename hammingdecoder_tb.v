`timescale 1ns / 1ps

module hammingdecoder_tb;

    reg  [12:0] encoded_in;
    wire [7:0]  data_out;
    wire [3:0]  syndrome;
    wire        word_parity;
    wire [1:0]  error_type;

    hammingdecoder uut (
        .encoded_in(encoded_in),
        .data_out(data_out),
        .syndrome(syndrome),
        .word_parity(word_parity),
        .error_type(error_type)
    );

    initial begin
        $display("\n================ Hamming Decoder Testbench ================\n");

        // Test Case 1: No error
        encoded_in = 13'b1000001111111;
        #10;
        $display("Test Case 1: No Error");
        $display("Input         : %b", encoded_in);
        $display("Syndrome      : %b", syndrome);
        $display("Word Parity   : %s", word_parity ? "Odd" : "Even");
        case (error_type)
            2'b00: $display("Error Type    : No Error");
            2'b01: $display("Error Type    : Word Parity Error");
            2'b10: $display("Error Type    : Single-bit Error");
            2'b11: $display("Error Type    : Multi-bit Error");
        endcase

        // Test Case 2: Word parity error
        encoded_in = 13'b0000001111111; // Only WP flipped
        #10;
        $display("\nTest Case 2: Word Parity Error");
        $display("Input         : %b", encoded_in);
        $display("Syndrome      : %b", syndrome);
        $display("Word Parity   : %s", word_parity ? "Odd" : "Even");
        case (error_type)
            2'b00: $display("Error Type    : No Error");
            2'b01: $display("Error Type    : Word Parity Error");
            2'b10: $display("Error Type    : Single-bit Error");
            2'b11: $display("Error Type    : Multi-bit Error");
        endcase

        // Test Case 3: Single-bit error 
        encoded_in = 13'b1000000111111;
        #10;
        $display("\nTest Case 3: Single-bit Error");
        $display("Input         : %b", encoded_in);
        $display("Syndrome      : %b", syndrome);
        $display("Word Parity   : %s", word_parity ? "Odd" : "Even");
        case (error_type)
            2'b00: $display("Error Type    : No Error");
            2'b01: $display("Error Type    : Word Parity Error");
            2'b10: $display("Error Type    : Single-bit Error");
            2'b11: $display("Error Type    : Multi-bit Error");
        endcase

        // Test Case 4: Multi-bit error 
        encoded_in = 13'b1000010111111;
        #10;
        $display("\nTest Case 4: Multi-bit Error");
        $display("Input         : %b", encoded_in);
        $display("Syndrome      : %b", syndrome);
        $display("Word Parity   : %s", word_parity ? "Odd" : "Even");
        case (error_type)
            2'b00: $display("Error Type    : No Error");
            2'b01: $display("Error Type    : Word Parity Error");
            2'b10: $display("Error Type    : Single-bit Error");
            2'b11: $display("Error Type    : Multi-bit Error");
        endcase

        $display("\n================ Testbench Complete ================\n");
        $finish;
    end

endmodule
