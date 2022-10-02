# Build Kernel for Lenovo D330

## Download
Go to [Kernel.org](https://kernel.org/) and download the last longterm tarball release.

| Version | Status in D330 |
| :--- | :--- |
| 5.15.x | not tested |
| 5.10.x | not working |
| 5.4.x | *recommended* |
| 4.19.x | works |
| 4.14.x | not tested |
| 4.9.x | not tested |


## Patch
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

## Dependencies

Install
```
sudo apt install libncurses-dev flex bison openssl libssl-dev dkms libelf-dev dwarves liblz4-tool -y
```

## Config
Open terminal and go into kernel folder, type:
```
make localmodconfig
```
Press ENTER to everything, then type:

```
make menuconfig
```
1- Go to "Processor type and features" and remove all AMD options with SPACE key<br>
2- Go into "General setup", into "local version" type "-d330"<br>
3- Save and Exit

##  Make
Type:
```
make -j2 deb-pkg
```
Wait for about 1 hour