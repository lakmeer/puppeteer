#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <libwebsockets.h>

#include "websocket_server.h"

void ws_init_server (struct ws_server_config Config, int Callback) {

  static struct libwebsocket_protocols Protocols[] = {
    { "http-only", Callback, 0 },
    { NULL,        NULL,     0 }
  };

  const char* Interface = NULL;
  struct libwebsocket_context* Context;

  // create libwebsocket context representing this server
  Context = libwebsocket_create_context(Config.port, Interface, Protocols,
                                        libwebsocket_internal_extensions,
                                        Config.cert_path, Config.key_path, -1,
                                        -1, Config.specialOptions);

  if (Context == NULL) {
    fprintf(stderr, "Libwebsocket init failed.\n");
    return;
  }

  printf("Starting server...\n");
}

