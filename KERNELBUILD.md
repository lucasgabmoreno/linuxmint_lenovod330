# Build Kernel for Lenovo D330

## Download
Go to [Kernel.org](https://kernel.org/) and download the last longterm tarball release.

| Version | Status in D330 |
| :--- | :--- |
| 5.4.x | *recommended* |
| 4.19.x | works |


## Patchs (last kernels has this patchs)
Unzip, search following files and modify. 

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

## Dependencies

Install
```
sudo apt install libncurses-dev flex bison openssl libssl-dev dkms libelf-dev dwarves liblz4-tool -y
```

## Config
Open terminal and go into kernel folder, type:
```
sudo cp -v /boot/config-$(uname -r) .config
make localmodconfig
```
Press ENTER to everything, then type:

```
make menuconfig
```
Save and Exit<br>


##  Make
Type:
```
make -j$(nproc) deb-pkg
```
Wait for about 1 hour

## Credits:
- [Locos por Linux](https://youtu.be/YNo9ereeao4)
- [GLK-DSI patch](https://patchwork.freedesktop.org/patch/317041/)
- [Panel orientation Quirk](https://lore.kernel.org/all/20211115165317.459447985@linuxfoundation.org/)
