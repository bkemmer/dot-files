# i
Download binaries for blink engine: https://github.com/saghen/blink.cmp/releases/tag/v1.0.0
and save on this path
# Linux
$VIMCONFIG/pack/plugins/start/blink.cmp/target/release/libblink_cmp_fuzzy.so

# Mac
$VIMCONFIG/pack/plugins/start/blink.cmp/target/release/libblink_cmp_fuzzy.dylib

To remove the message:
xattr -d com.apple.quarantine <path to dylib file> 

<!--# Windows-->
<!--~/Appdata/Local/nvim/lazy/blink.cmp/target/release/libblink_cmp_fuzzy.dll-->
