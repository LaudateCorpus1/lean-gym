import data.nat.basic
import data.real.basic
theorem mathd_numbertheory_136
  (n : ℕ)
  (h₀ : 123 * n + 17 = 39500) : n = 321 :=
begin
  linarith,
end
