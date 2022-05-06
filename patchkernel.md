# Patch Kernel for Lenovo D330
Download and unzip "tarball" source kernel from [Kernel.org](https://kernel.org/).<br>
Search following files and mod some lines

### vlv_dsi_pll.c
Find:
```
I915_WRITE(MIPIO_TXESC_CLK_DIV1, txesc1_div & GLK_TX_ESC_CLK_DIV1_MASK);
I915_WRITE(MIPIO_TXESC_CLK_DIV2, txesc2_div & GLK_TX_ESC_CLK_DIV2_MASK);
```
Replace:
```
I915_WRITE(MIPIO_TXESC_CLK_DIV1, (1 << (txesc1_div - 1)) & GLK_TX_ESC_CLK_DIV1_MASK);
I915_WRITE(MIPIO_TXESC_CLK_DIV2, (1 << (txesc2_div - 1)) & GLK_TX_ESC_CLK_DIV2_MASK);
```
