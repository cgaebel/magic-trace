open! Core
open! Async
open! Magic_trace_core

(* Reads the contents of a file in the test directory, as a string. *)
val resolve_file : string -> string

(* Runs some perf script end-to-end through the perf_tool_backend and the trace_writer, printing
   out generated traces as a string.

   To generate these scripts, run magic-trace with a working directory (say, /tmp/wd). Then, run:

   $ perf script -i /tmp/wd/perf.data/data --ns --itrace=b -F pid,tid,time,flags,ip,addr,sym,symoff

   and save that output to a file in test/. See hello_world_with_kernel_tracing.ml for an example
   of turning that saved perf output into an expect test that you can play around with.

   If you're trying to demonstrate a bug, reduce your perf output to just the problematic section.
   It's hard to keep people engaged when reading diffs of massive tests. *)
val run
  :  ?debug:bool
  -> ?events_writer:Magic_trace_lib.Tracing_tool_output.events_writer
  -> ?ocaml_exception_info:Ocaml_exception_info.t
  -> trace_scope:Trace_scope.t
  -> Filename.t
  -> unit Deferred.t
