open! Core

let%expect_test "decode error during memmove" =
  Perf_script.run ~trace_mode:Userspace_and_kernel "memmove_decode_error.perf";
  [%expect
    {|
    293415/293415 47170.086912824:   call                           40b06c itch_bbo::book::Book::add_order+0x51c =>     7ffff7327730 __memmove_avx_unaligned_erms+0x0
    293415/293415 47170.086912825:   return                   7ffff73277c7 __memmove_avx_unaligned_erms+0x97 =>           40b072 itch_bbo::book::Book::add_order+0x522
    ->     19ns BEGIN __memmove_avx_unaligned_erms
    293415/293415 47170.086912826:   call                           40b093 itch_bbo::book::Book::add_order+0x543 =>     7ffff7327730 __memmove_avx_unaligned_erms+0x0
    ->     20ns END   __memmove_avx_unaligned_erms
     instruction trace error type 1 time 47170.086912826 cpu -1 pid 293415 tid 293415 ip 0x7ffff7327730 code 7: Overflow packet
    ->     21ns BEGIN [decode error: Overflow packet]
    ->          END   [decode error: Overflow packet]
    ->      0ns BEGIN itch_bbo::book::Book::add_order [inferred start time]
    ->     21ns BEGIN __memmove_avx_unaligned_erms
    ->     31ns END   __memmove_avx_unaligned_erms
    ->     31ns END   itch_bbo::book::Book::add_order
    293415/293415 47170.086912872:   tr strt                             0 [unknown] =>     7ffff7327786 __memmove_avx_unaligned_erms+0x56
    293415/293415 47170.086912946:   return                   7ffff73277d4 __memmove_avx_unaligned_erms+0xa4 =>           40b099 itch_bbo::book::Book::add_order+0x549
    ->     67ns BEGIN __memmove_avx_unaligned_erms
    END
    ->     21ns BEGIN itch_bbo::book::Book::add_order [inferred start time]
    ->    141ns END   __memmove_avx_unaligned_erms
    ->    141ns END   itch_bbo::book::Book::add_order |}]
;;
