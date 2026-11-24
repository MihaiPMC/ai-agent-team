# Contracts

The public interfaces between systems, so agents can work in parallel without guessing. Keep it short; update it in the same change that alters an interface.

## <System name>
- Owner: <agent/task>
- Public API: `<function / endpoint / message>(args) -> result`
- Data shape: `<fields and types>`
- Invariants: <what must always hold, who validates it>
- Consumers: <who calls it>
