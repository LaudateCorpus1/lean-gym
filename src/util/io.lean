import system.io
import tactic.gptf.utils.util

section io
open interaction_monad interaction_monad.result
namespace io

/-- verion of io.run_tactic' which does not suppress the exception msg -/
meta def run_tactic'' {α} (tac :tactic α) : io α := do {
  io.run_tactic $ do {
    result ← tactic.capture tac,
    match result with
    | (success val _) := pure val
    | (exception m_fmt pos _) := do {
      let fmt_msg := (m_fmt.get_or_else (λ _, format!"none")) (),
      let msg := format!"{fmt_msg}",
      tactic.trace msg,
      tactic.fail msg
    }
    end
  }
}

end io
end io


-- convenience function for command-line argument parsing
meta def list.nth_except {α} : list α → ℕ → string → io α := λ xs pos msg,
  match (xs.nth pos) with
  | (some result) := pure result
  | none := do
    io.fail' format!"must supply {msg} as argument {pos}"
  end


meta def option.to_io {α} (x : option α ) (exception_msg : string := "[option.to_io] failed") : io α := 
match x with
| (some val) := pure val
| none := io.fail exception_msg
end