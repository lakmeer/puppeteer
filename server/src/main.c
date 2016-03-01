#if 1

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <signal.h>
#include <sys/time.h>

#include <libwebsockets.h>


int close_testing = 1;
int force_exit = 0;

struct lws_context *context;

enum demo_protocols {
  PROTOCOL_DUMB_INCREMENT = 0,
  DEMO_PROTOCOL_COUNT
};

struct per_session_data__dumb_increment {
  int number;
};


int callback_dumb_increment(struct lws *wsi,
                            enum lws_callback_reasons reason,
                            void *user, void *in, size_t len) {

  unsigned char buf[LWS_SEND_BUFFER_PRE_PADDING + 512];
  struct per_session_data__dumb_increment *pss;
  unsigned char *p = &buf[LWS_SEND_BUFFER_PRE_PADDING];
  int n, m;

  pss = (struct per_session_data__dumb_increment *)user;

  switch (reason) {

    case LWS_CALLBACK_ESTABLISHED:
      printf("LWS_CALLBACK_ESTABLISHED\n");
      pss->number = 0;
      break;

    case LWS_CALLBACK_SERVER_WRITEABLE:
      printf("LWS_CALLBACK_SERVER_WRITEABLE\n");

      n = sprintf((char *)p, "%d", pss->number++);
      m = lws_write(wsi, p, n, LWS_WRITE_TEXT);

      if (m < n) {
        lwsl_err("ERROR %d writing to di socket\n", n);
        return -1;
      }

      if (close_testing && pss->number == 50) {
        lwsl_info("close tesing limit, closing\n");
        return -1;
      } break;

    case LWS_CALLBACK_RECEIVE:
      printf("LWS_CALLBACK_RECEIVE\n");

      if (len < 6) { break; }

      if (strcmp((const char *)in, "reset\n") == 0) {
        pss->number = 0;
      }

      if (strcmp((const char *)in, "closeme\n") == 0) {
        lwsl_notice("dumb_inc: closing as requested\n");
        lws_close_reason(wsi, LWS_CLOSE_STATUS_GOINGAWAY, (unsigned char *)"seeya", 5);
        return -1;
      } break;

    case LWS_CALLBACK_FILTER_PROTOCOL_CONNECTION:
      printf("LWS_CALLBACK_FILTER_PROTOCOL_CONNECTION\n");
      break;

    case LWS_CALLBACK_WS_PEER_INITIATED_CLOSE:
      printf("LWS_CALLBACK_WS_PEER_INITIATED_CLOSE\n");
      lwsl_notice("LWS_CALLBACK_WS_PEER_INITIATED_CLOSE: len %d\n", len);

      for (n = 0; n < (int)len; n++) {
        lwsl_notice(" %d: 0x%02X\n", n, ((unsigned char *)in)[n]);
      } break;

    default:
      break;
  }

  return 0;
}

static struct lws_protocols protocols[] = {
  {
    "dumb-increment-protocol",
    callback_dumb_increment,
    sizeof(struct per_session_data__dumb_increment),
    10
  },
  { NULL, NULL, 0, 0 }
};


void sighandler(int sig) {
  force_exit = 1;
  lws_cancel_service(context);
}


int main(int argc, char **argv) {

  int opts = 0;
  int n = 0;
  unsigned int ms, oldms = 0;

  struct lws_context_creation_info info;

  memset(&info, 0, sizeof info);

  info.port = 9999;
  info.protocols = protocols;
  info.ssl_cert_filepath = NULL;
  info.ssl_private_key_filepath = NULL;
  info.extensions = NULL; // lws_get_internal_extensions deprecated. Replacement unknown?
  info.gid = -1;
  info.uid = -1;
  info.max_http_header_pool = 1;
  info.options = opts;

  signal(SIGINT, sighandler);

  context = lws_create_context(&info);

  if (context == NULL) {
    lwsl_err("libwebsocket init failed\n");
    return -1;
  }

  n = 0;

  while (n >= 0 && !force_exit) {
    struct timeval tv;

    gettimeofday(&tv, NULL);

    /* This provokes the LWS_CALLBACK_SERVER_WRITEABLE for every
     * live websocket connection using the DUMB_INCREMENT protocol,
     * as soon as it can take more packets (usually immediately) */

    ms = (tv.tv_sec * 1000) + (tv.tv_usec / 1000);

    if ((ms - oldms) > 50) {
      lws_callback_on_writable_all_protocol(context, &protocols[PROTOCOL_DUMB_INCREMENT]);
      oldms = ms;
    }

    n = lws_service(context, 50);
  }

  lws_context_destroy(context);

  return 0;

}

#endif

#if 0
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#include "twitchie.h"
#include "keyhook_osx.c"
#include "websocket_server.c"


// Config

struct ws_server_config Config = wsNewServerConfig();


int websocketCallback(struct libwebsocket_context *context,
    struct libwebsocket *wsi,
    enum libwebsocket_callback_reasons reason,
    void *user, void *in, size_t len) {

  switch (reason) {
    case LWS_CALLBACK_HTTP: {
                              void *universal_response = "Hello, World!";
                              libwebsocket_write(wsi, universal_response, strlen(universal_response), LWS_WRITE_HTTP);
                              break;
                              default:
                              printf("Unhandled callback!\n");
                            }
  }

  printf("WS Callback.\n");
  return 0;
}



// Main

int main (int argc, const char * argv[]) {

  /* THEORETICAL FLOW

     - Init WS server
     - Establish callbacks:

     / - Serve theatre html, set mode to 'PERFORMANCE'
     /editor - Serve editor html, set mode 'EDITOR'
     /assets/ - serve static files based on mimetype
     /config/name - load and send character config json

     SAVE config - persist config as json

     - Init hooks
     - Establish hook callbacks
     Keyboard - generate ws description packet
     Mouse    - generate ws description packet
     - Run loop

     - Join hooks to websockets if not running in editor mode
     */

  ws_init_server(Config, websocketCallback);

  if (enableLogfileMode) {
    createEventTap(logfileEventCallback);
    logFile = fopen("/var/log/keystroke.log", "a");
  } else {
    createEventTap(printoutEventCallback);
  }

  // Init hook loop
  //CFRunLoopRun();

  // Init ws server loop
  while (1) {
    libwebsocket_service(context, Config.pollRate);
  }

  libwebsocket_context_destroy(context);

  return 0;
}
#endif
