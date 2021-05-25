import tactic
import tactic.core
import util.io
import system.io
import basic.control

open tactic

namespace tactic

meta def set_goal_to (goal : expr) : tactic unit :=
mk_meta_var goal >>= set_goals ∘ pure

end tactic


section add_open_namespace

meta def add_open_namespace : name → tactic unit := λ nm, do
env ← tactic.get_env, tactic.set_env (env.execute_open nm)

meta def add_open_namespaces (nms : list name) : tactic unit :=
nms.mmap' add_open_namespace

end add_open_namespace


section hashing

meta def tactic_hash : tactic ℕ := do {                                                                 
  gs ← tactic.get_goals,                                                                                
  hs ← gs.mmap $ λ g, do {                                                                              
    tactic.set_goal_to g,                                                                               
    es ← (::) <$> tactic.target <*> tactic.local_context,                                               
    pure $ es.foldl (λ acc e, acc + e.hash) 0},                                                         
  pure $ hs.sum                                                                                         
}         

end hashing


section option
meta def option.to_tactic {α} (x : option α ) (exception_msg : string := "[option.to_tactic] failed") : tactic α := 
match x with
| (some val) := pure val
| none := tactic.fail exception_msg
end

-- run_cmd ((none : option ℕ).to_tactic "FAILURE") -- errors with "FAILURE"
-- run_cmd ((some 42 : option ℕ).to_tactic >>= tactic.trace) -- 42
end option