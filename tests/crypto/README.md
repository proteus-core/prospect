**Warning:** These benchmark were compiled for a former version of Proteus, where secret boundaries were hardcoded directly in the processor. Therefore, while secrets are placed in a dedicated `.secret` section, the boundaries of this region are not loaded in CSRs. Please look at the [synthetic_benchmark](../synthetic_benchmark) for an example of how to load the boundaries of the secret region in the CSRs.

If you decide to recompile these benchmarks, please note that the assembly code was manually patched to clear secret values from registers after declassification (see [`clear.S`](./curve25519/clear.S) files). You'll likely have to do this too if you want to declassify secrets.

If you want to experiment with these programs on Proteus, you'll need to fix this compatibility issue. If you do so, we'll be happy to take a pull request. 
