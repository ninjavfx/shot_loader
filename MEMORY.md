# Shot Loader handoff

## Purpose

Shot Loader is derived from xStudio's Python Filesystem Browser plug-in. It
loads files and image sequences, locates a matching per-shot `.ccc` sidecar,
and sets OCIO context metadata on the resulting media source.

Example supported layout:

```text
example_shot_v001/
  example_shot_v001.ccc
  frames/
    example_shot_v001.1001.exr
```

The sidecar must be named `<sequence-stem>.ccc`. The preference file permits
searching the frame directory, its parent, or both.

## OCIO requirements

The target OCIO configuration needs `CDL_dir` and `VERSION` environment
variables, a context-aware search path, and a CDL-enabled `FileTransform`:

```yaml
environment:
  CDL_dir: ""
  VERSION: ""
search_path: luts:${CDL_dir}:${CDL_dir}/..

- !<FileTransform>
  src: ${VERSION}.ccc
  cccid: "0"
  direction: forward
```

## Important implementation details

- `_sequence_stem()` uses `fileseq` to handle compact frame-range syntax.
- `_apply_cdl_context()` retries source metadata and colour-pipeline refreshes
  for roughly three seconds after loading; xStudio can construct its initial
  shader before the metadata is visible.
- The QML preview timer suppresses the release event following a double-click,
  preventing a preview source from replacing the intentionally loaded source.
- Directory symlinks are followed by both the browser tree and background
  scanner. The scanner tracks resolved ancestors per traversal branch so a
  symlink cycle cannot recurse indefinitely, while separate aliases remain
  independently browsable.
- Some SMB shares report server-side directory symlinks as regular files through
  Python's cached `DirEntry` type methods. Directory discovery therefore falls
  back to path-based `os.path.isdir()` checks for ambiguous/non-media entries.
- **Shift+S** toggles Shot Loader's xStudio-managed pop-out window.

## Publishing notes

- `shot_loader.log` is temporary diagnostics and should not be committed.
- `__pycache__` is generated automatically and should not be committed.
