# openssl-keylog

Add SSLKEYLOGFILE support to any dynamically linked app using OpenSSL 1.1+, including the .NET 5 runtime.

## Building

No dependencies. Just make it.

```
make
```

## Usage 

Start a network capture on `some_interface` in the background. Export the path to the key log output and the path to this library. Run your command.

```
sudo dumpcap -i some_interface -w /path/to/output.pcapng &
sslkeylogged command_to_trace
```

# Credit 

This code is forked from [sslkeylog.c](https://git.lekensteyn.nl/peter/wireshark-notes/tree/src/sslkeylog.c) by Peter Wu. Also thanks to Peter for his [StackExchange post](https://security.stackexchange.com/a/80174).