# openssl-keylog

Add [`SSLKEYLOGFILE`](https://developer.mozilla.org/en-US/docs/Mozilla/Projects/NSS/Key_Log_Format) support to any dynamically linked app using OpenSSL 1.1.1+, including .NET 5 applications.

## Building

No dependencies. Just make it.

```shell
$ sudo apt install git build-essential
$ git clone https://github.com/wpbrown/openssl-keylog
$ cd openssl-keylog
$ make
cc sslkeylog.c -shared -o libsslkeylog.so -fPIC -ldl
```

The `.so` is built next to the `sslkeylogged` script. Add the project directory to your path.

```shell
$ export PATH=/home/foo/openssl-keylog:$PATH
```


## Usage 

Start a network capture on `eth0` in the background (your interface name may be different). Run your command with the sslkeylogged script. If you don't set `SSLKEYLOGFILE`, a value will be set and printed before running your command.

```shell
$ sudo dumpcap -q -i eth0 -w /tmp/output.pcapng &
$ sslkeylogged ./SimulatedDevice
*** SSLKEYLOGFILE set to /tmp/sslkeys-cOHTcLbk.txt ***
IoT Hub - Simulated Mqtt device.
Press control-C to exit.
02/24/2021 03:13:08 > Sending message: {"temperature":32.53831510550264,"humidity":63.50118943653125}
...
```

Set the `sslkeys` text file in your Wireshark [preferences](https://wiki.wireshark.org/TLS) before you open the capture file to see the decrypted TLS traffic.

# Credit 

This code is forked from [sslkeylog.c](https://git.lekensteyn.nl/peter/wireshark-notes/tree/src/sslkeylog.c) by Peter Wu. Also thanks to Peter for his [StackExchange post](https://security.stackexchange.com/a/80174).