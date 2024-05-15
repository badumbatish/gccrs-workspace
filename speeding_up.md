# Speeding up

## Build speed up

There is different options of linker to speed up your build. You can use lld or mold instead of the normal GNU ld to speed up your linking.

For incremental build, use ccache to speed up your build.

From [First contributions](https://github.com/Rust-GCC/gccrs/wiki/First-contributions), your configuration of make might look like this

```
../configure CC="ccache clang" CXX="ccache clang++" CFLAGS="-O0 -g3" \
   CXXFLAGS="-O0 -g3" \
   LD_FLAGS="-fuse-ld=mold" \
   --disable-bootstrap --enable-multilib --enable-languages=rust path_to_your_src
```

This configuration will require additional tools but may speedup your workflow.
- ccache to cache build artifacts.
- clang because output is less convoluted and there are more warning.
- Debug informations are enabled.
- mold is used instead of ld for linking stage.

## Git speed up

After you have cloned your fork of gccrs, please run
```bash
bash git_optimization.sh
```

to speed up git operations