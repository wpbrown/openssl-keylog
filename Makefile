libsslkeylog.so : sslkeylog.c
	$(CC) sslkeylog.c $(CFLAGS) -shared -o libsslkeylog.so -fPIC -ldl $(LDFLAGS)

clean : 
	$(RM) libsslkeylog.so