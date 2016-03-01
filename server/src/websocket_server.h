
struct ws_server_config {
  int port;           // 8081
  char* cert_path;    // NULL
  char* key_path;     // NULL
  int specialOptions; // 0
  int pollRate;       // 50
};

struct ws_server_config wsNewServerConfig () {
  struct ws_server_config Config = { 8081, NULL, NULL, 0, 50 };
  return Config;
}

