# Changelog

## 0.3.3 - 2026-10-14

Released from the fork `bobzhang/elk`.

### Fixed

- Layered: the connected components of a graph share its random number
  generator, as in ELK, instead of each seeding one of its own.
- Layered: edge labels are written back by the label they came from, not
  by their position in the list, which swapped a centre label with a head
  or tail label.
- Layered: the labels of a self loop stack by the direction the graph was
  given (they were placed side by side in left-to-right graphs).
- Layered: node margins use `NodeMarginCalculator`'s bounding-box
  arithmetic, which removes last-bit differences from elkjs with groups.

## 0.3.2 (bobzhang/elk) - 2026-10-14

- The module is named `bobzhang/elk`; it is `moon_elk` 0.3.2 with the
  elkjs 0.9.3 parity fixes that mermaid's graphs need.

## 0.3.0 - 2026-09-18

### Added

- Integrated DisCo and Topdown Packing into the core JSON engine.
- Added Graphviz DOT model serialization and byte parsing.
- Added Graphviz family registration for `dot`, `neato`, `fdp`, `sfdp`,
  `twopi`, and `circo`.
- Added Graphviz text runner process adapters and one-step registration.
- Added Libavoid transport, text runner, server output protocol parsing, and
  explicit engine registration.
- Added a runnable minimal JSON layout example.
- Added a multi-target CI matrix for wasm, wasm-gc, js, and native.

### Changed

- Removed unused package imports and enabled `moon check --deny-warn`.
- Made Graphviz and Libavoid opt-in capabilities instead of default engine
  algorithms.
- Replaced Graphviz provider serializer/parser test stubs with real DOT
  serialization and parsing.

### Fixed

- Fixed DisCo related-port movement after component compaction.
- Fixed Libavoid cluster child coordinate conversion.

### Known Limits

- Graphviz and Libavoid executables are supplied by the host runtime.
- Native process adapters remain host-provided through synchronous runner or
  process factory APIs.
- Windows CI remains disabled for the full repository build.
