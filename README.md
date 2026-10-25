# CPU Scheduling Simulator (CSE513 Assignment 1)

A browser-based simulator for four CPU scheduling algorithms: **FCFS**, **SJF** (non-preemptive), **SRTF** (preemptive) and **Round Robin** with a configurable quantum.

**Live site:** https://goktugali.github.io/cse513-hw1-cpu-scheduling-simulator/

## Running it locally

There are no dependencies and no build step. The whole simulator (HTML, CSS and JavaScript) is a single file.

1. Download or clone this repository.
2. Open `index.html` in a modern browser (Chrome, Edge, Firefox or Safari) by double-clicking it.

Everything runs in the browser. There is no backend, database or network request, so it works offline and from `file://`.

## Using it

- **Processes:** add, edit, reorder (↑ ↓) and remove processes. Each process has an ID, an arrival time and a CPU burst. The input order is the final tie-breaker.
- **Algorithm and quantum:** choose FCFS, SJF, SRTF or RR. The quantum is used only by RR.
- **Example workloads:** load Workloads A and B from the assignment, the three additional test cases C, D and E, or three worked examples from the Lecture 2 slides.
- **Fast run mode:** results are recomputed on every valid change.
- **Simulate mode:** step through the schedule (play, pause, step, slider). Each step shows the not-yet-arrived processes, the ready queue in selection order (FIFO for RR), the CPU and the completed processes, with an explanation of the decision.
- **Outputs:**
  - a labelled Gantt chart with idle intervals, arrival markers and numbered RR slices
  - a results table (arrival, burst, first start, completion, turnaround, waiting, response) and averages
  - correctness checks
  - a comparison of all algorithms on the same workload
  - a decision trace

### URL parameters

A specific example can be opened directly, for example `index.html?w=B&algo=RR&q=2&mode=sim`.

| Parameter | Values |
|---|---|
| `w` | `A`, `B`, `C`, `D`, `E`, `L1`, `L2`, `L3` |
| `algo` | `FCFS`, `SJF`, `SRTF`, `RR` |
| `q` | the quantum |
| `mode` | `fast`, `sim` |
| `view=output` | shows only the Gantt chart and results |
| `theme` | `light`, `dark` |

## Scheduling rules implemented

- **FCFS:** the earliest-arriving ready process runs to completion.
- **SJF:** when the CPU becomes free, the ready process with the shortest CPU burst runs to completion.
- **SRTF:** the ready process with the shortest remaining time runs. A running process is preempted only by a strictly shorter remaining time. On an equal remaining time it keeps the CPU.
- **Tie-breaking:** earlier arrival first, then earlier position in the input list.
- **Round Robin:** FIFO ready queue. Arrivals join the tail. At a quantum boundary, processes arriving at that exact time are enqueued before the preempted process is re-enqueued. A completed process never rejoins.
- An empty ready queue produces an idle interval until the next arrival.
- A process running from time 2 to time 5 receives 3 units of CPU time.
- Turnaround = Completion − Arrival, Waiting = Turnaround − Burst, Response = First start − Arrival.

## Testing

- **Built-in self-tests:** open the "Built-in self-tests" section at the bottom of the page. The page runs 59 tests on load:
  - Workloads A and B for all four algorithms against hand-calculated results
  - the Lecture 2 worked examples
  - test cases C, D and E
  - rule and edge cases (ties, RR boundary order, idle gaps)
  - input validation
- **Command line (macOS):** `sh tests/run-tests.sh` runs the same tests with JavaScriptCore.
- **Correctness checks:** every simulation is checked against these properties:
  - each process receives exactly its burst
  - no process runs before its arrival
  - no two processes overlap on the CPU
  - waiting and response times are nonnegative
  - the CPU is never idle while a process is ready
  - every step of the step-by-step view agrees with the timeline

## Limitations

- **One CPU burst per process:** there is no I/O and no context-switch cost, as the assignment specifies.
- **Process count:** at most 50 processes.
- **Timeline length:** every value, and the whole timeline (latest arrival + total CPU burst), is limited to 1000 time units so the Gantt chart and the step-by-step view stay readable. Larger inputs are rejected with an explanation.
- **Process IDs:** IDs use 1–12 letters, digits, `-` or `_`. They are unique without regard to case.
- **Inputs:** times must be whole numbers. Leading zeros, a leading `+` and surrounding spaces are accepted. Decimals, negative values, scientific notation and text are rejected.
- **Not a real OS scheduler:** this simulator models scheduling policies. It does not reproduce the Linux or Ubuntu scheduler, and it uses exact burst lengths instead of predictions.
