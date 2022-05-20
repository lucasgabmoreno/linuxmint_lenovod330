# Patch Kernel for Lenovo D330
Download and unzip "tarball" source kernel from [Kernel.org](https://kernel.org/).<br>
Search following files and mod some lines
<br><br>
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
*Source: https://patchwork.freedesktop.org/patch/317041/*
<br><br>
### drm_panel_orientation_quirks.c
Find:
```
 		  DMI_EXACT_MATCH(DMI_PRODUCT_VERSION, "Lenovo MIIX 320-10ICR"),
 		},
 		.driver_data = (void *)&lcd800x1280_rightside_up,
```
Replace:
```
 		  DMI_EXACT_MATCH(DMI_PRODUCT_VERSION, "Lenovo MIIX 320-10ICR"),
 		},
 		.driver_data = (void *)&lcd800x1280_rightside_up,
 	}, {	/* Lenovo Ideapad D330-10IGM (HD) */
 		.matches = {
 		  DMI_EXACT_MATCH(DMI_SYS_VENDOR, "LENOVO"),
 		  DMI_EXACT_MATCH(DMI_PRODUCT_VERSION, "Lenovo ideapad D330-10IGM"),
 		},
 		.driver_data = (void *)&lcd800x1280_rightside_up,
 	}, {	/* Lenovo Ideapad D330-10IGM (FHD) */
 		.matches = {
 		  DMI_EXACT_MATCH(DMI_SYS_VENDOR, "LENOVO"),
 		  DMI_EXACT_MATCH(DMI_PRODUCT_VERSION, "Lenovo ideapad D330-10IGM"),
 		},
 		.driver_data = (void *)&lcd1200x1920_rightside_up,
 	}, {	/* Lenovo Ideapad D330-10IGL (HD) */
 		.matches = {
 		  DMI_EXACT_MATCH(DMI_SYS_VENDOR, "LENOVO"),
 		  DMI_EXACT_MATCH(DMI_PRODUCT_VERSION, "Lenovo ideapad D330-10IGL"),
 		},
 		.driver_data = (void *)&lcd800x1280_rightside_up,
```

*Source: https://lore.kernel.org/all/20211115165317.459447985@linuxfoundation.org/*
