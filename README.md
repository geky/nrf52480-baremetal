## Baremetal NRF52840 example

This is a minimal example of a baremetal NRF52840 project.

It depends on two small libraries:
- [CMSIS][CMSIS] - Provided by ARM
- [nrfx][nrfx] - Provided by Nordic

I've pinned the GitHub repos to make it easier to update. The CMSIS repo has
a lot of extra files when we really only need the core, so you could copy only
the CMSIS/Core/Include directory for a smaller source code footprint.

## Usage

This includes a Makefile that has served me well and contains a few tricks.

``` bash
$ make
```

To flash/debug, you will need to run a GDB server to communicate with the
device. The [JLink GDB server][JLinkGDB] works for the nrf52840 devkit. I've
included a script to launch this.

``` bash
$ ./gdbserver.sh
$ make build flash reset
$ make debug
```

The Makefile also has a number of variables that may be useful to override.

``` bash
$ make clean build DEBUG=1 CFLAGS+=-DNRFX_TIMER_ENABLED=1
$ make cat TTY=/dev/ttyACM0 BAUD=115200
$ make debug GDBPORT=1234
```

## Notes

- This is a very minimal example.
- nrfx provides drivers for Nordic's peripherals, while CMSIS provides useful
  intrinsics for ARM cores.
- nrfx_glue.h provides a binding between nrfx and CMSIS, feel free to override
  the bindings in there.
- nrfx relies on defines to enable specific peripherals, you may need to edit
  the makefile to enable more peripherals.

  ``` diff
  override CFLAGS += -DNRFX_TIMER_ENABLED=1
  override CFLAGS += -DNRFX_TIMER0_ENABLED=1
  override CFLAGS += -DNRFX_TIMER1_ENABLED=1
  ```

[CMSIS]: https://github.com/ARM-software/CMSIS_5
[nrfx]: https://github.com/NordicSemiconductor/nrfx
[JLinkGDB]: https://www.segger.com/products/debug-probes/j-link/tools/j-link-gdb-server/about-j-link-gdb-server/
