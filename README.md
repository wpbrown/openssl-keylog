# openssl-keylog

Add [`SSLKEYLOGFILE`](https://developer.mozilla.org/en-US/docs/Mozilla/Projects/NSS/Key_Log_Format) support to any dynamically linked app using OpenSSL 1.1+, including the .NET 5 runtime.

## Building

No dependencies. Just make it.

```
make
```

## Usage 

Start a network capture on `eth0` in the background. Run your command with the sslkeylogged script. If you don't set `SSLKEYLOGFILE` an value will be set and printed before running your command.

```
$ sudo dumpcap -i eth0 -w /tmp/output.pcapng &
$ sslkeylogged ./SimulatedDevice
*** SSLKEYLOGFILE set to /tmp/sslkeys-cOHTcLbk.txt ***
IoT Hub - Simulated Mqtt device.
Press control-C to exit.
02/24/2021 03:13:08 > Sending message: {"temperature":32.53831510550264,"humidity":63.50118943653125}
...
```

# Credit 

This code is forked from [sslkeylog.c](https://git.lekensteyn.nl/peter/wireshark-notes/tree/src/sslkeylog.c) by Peter Wu. Also thanks to Peter for his [StackExchange post](https://security.stackexchange.com/a/80174).