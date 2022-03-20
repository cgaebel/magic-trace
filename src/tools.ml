open! Core
open! Async
open! Import

module Perf_with_symbols : sig
  val command : Command.t
end = struct
  let collect () = return ()

  let collect_command =
    Command.async
      ~summary:"Collect a perf trace and annotate it with symbols. Outputs to stdout."
      (Command.Param.return collect)
  ;;

  let to_trace () = return ()

  let to_trace_command =
    Command.async
      ~summary:"Converts the output of [collect] into a perfetto trace."
      (Command.Param.return to_trace)
  ;;

  let command =
    Command.group
      ~summary:"Step by step, annotates perf traces with what magic-trace is thinking."
      [ "collect", collect_command; "to-trace", to_trace_command ]
  ;;
end

let command =
  Command.group
    ~summary:"Tools that help developers of magic-trace develop magic-trace."
    [ "perf-with-symbols", Perf_with_symbols.command ]
;;
