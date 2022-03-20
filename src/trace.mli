open! Core
open! Async
open! Import

val command : Command.t

module Perf_tool_commands : sig
  module Backend = Perf_tool_backend

  type decode_opts =
    { output_config : Tracing_tool_output.t
    ; decode_opts : Backend.decode_opts
    ; verbose : bool
    }

  type record_opts =
    { backend_opts : Backend.record_opts
    ; use_filter : bool
    ; multi_snapshot : bool
    ; snap_symbol : Re.re
    ; record_dir : string
    ; executable : string
    ; snap_on_delay_over : Time_ns.Span.t option
    ; duration_thresh : Time_ns.Span.t option
    }

  type attachment =
    { recording : Backend.recording
    ; done_ivar : unit Ivar.t
    ; breakpoint_done : unit Deferred.t
    ; finalize_recording : unit -> unit
    }

  val attach : ?elf:Elf.t -> record_opts -> Pid.t -> attachment Deferred.Or_error.t
  val detach : attachment -> unit Deferred.Or_error.t

  val run_and_record
    :  ?elf:Elf.t
    -> command:string list
    -> record_opts
    -> unit Deferred.Or_error.t

  val attach_and_record : ?elf:Elf.t -> record_opts -> Pid.t -> unit Deferred.Or_error.t

  val record_flags
    : (default_executable:(unit -> string)
       -> f:(record_opts -> unit Deferred.Or_error.t)
       -> unit Deferred.Or_error.t)
      Command.Param.t

  val select_pid : unit -> Pid.t Deferred.Or_error.t
end

module For_testing : sig
  val write_trace_from_events
    :  ?debug_info:Elf.Addr_table.t
    -> Tracing.Trace.t
    -> (string * Breakpoint.Hit.t) list
    -> Backend_intf.Event.t Pipe.Reader.t
    -> unit Deferred.t
end
