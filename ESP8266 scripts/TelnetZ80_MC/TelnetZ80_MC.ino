/*
  Telnet for Z80 Modular Computer
*/
#include <string.h>
#include <ESP8266WiFi.h>

#include <algorithm> // std::min

#ifndef STASSID
#define STASSID ""
#define STAPSK  ""
//#define STASSID ""
//#define STAPSK  ""
#endif

#define BAUD_SERIAL 250000
#define RXBUFFERSIZE 1024
#define STACK_PROTECTOR  512 // bytes
#define MAX_SRV_CLIENTS 2

#define POWER_RELAY 2
#define RESET_RELAY 0

const char* ssid = STASSID;
const char* password = STAPSK;
const int port = 23;

WiFiServer server(port);
WiFiClient serverClients[MAX_SRV_CLIENTS];

void setup() {
  pinMode(POWER_RELAY,OUTPUT);
  digitalWrite(POWER_RELAY,LOW);
  pinMode(RESET_RELAY,OUTPUT);
  digitalWrite(RESET_RELAY,LOW);
  
  Serial.begin(BAUD_SERIAL);
  Serial.setRxBufferSize(RXBUFFERSIZE);

  WiFi.mode(WIFI_STA);
  
  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
  }
  Serial.print("\n\rIP = ");
  Serial.println(WiFi.localIP());

  //start server
  server.begin();
  server.setNoDelay(true);
}

void loop() {
  char  serviceString[80];
  int   j;

  //check if there are any new clients
  if (server.hasClient()) {
    //find free/disconnected spot
    int i;
    for (i = 0; i < MAX_SRV_CLIENTS; i++)
      if (!serverClients[i]) { // equivalent to !serverClients[i].connected()
        serverClients[i] = server.available();
        if (i == 0)
          serverClients[i].println("\n\r*** Console Session ***");
        if (i == 1)
          serverClients[i].println("\n\r*** Service Session ***");
        break;
      }
  }

  //check Console Session client for data
  while (serverClients[0].available() && Serial.availableForWrite() > 0) {
    Serial.write(serverClients[0].read());
  }
  //check Service Session client for data
  if (serverClients[1].available()) {
    j = 0;
    while (serverClients[1].available()) {
      serviceString[j++] = serverClients[1].read();
    }
    serviceString[5] = 0;
    if ((strcmp("reset", serviceString) == 0) || (strcmp("RESET", serviceString) == 0)) {
      digitalWrite(RESET_RELAY,HIGH);
      delay(500);
      digitalWrite(RESET_RELAY,LOW);
      serverClients[1].println("\n\r*** OK");
    }
    serviceString[3] = 0;
    if ((strcmp("off", serviceString) == 0) || (strcmp("OFF", serviceString) == 0)) {
      digitalWrite(POWER_RELAY,LOW);
      serverClients[1].println("\n\r*** POWER OFF");
    }
    serviceString[2] = 0;
    if ((strcmp("on", serviceString) == 0) || (strcmp("ON", serviceString) == 0)) {
      digitalWrite(POWER_RELAY,HIGH);
      serverClients[1].println("\n\r*** POWER ON");
    } else {
      serverClients[1].println("\n\rUse: on    (to turn power on)");
      serverClients[1].println(    "     off   (to turn power off)");
      serverClients[1].println(    "     reset (to reset Z80)");
    }
    serviceString[0] = 0;
  }

  // determine maximum output size "fair TCP use"
  // client.availableForWrite() returns 0 when !client.connected()
  int maxToTcp = 0;
  for (int i = 0; i < MAX_SRV_CLIENTS; i++)
    if (serverClients[i]) {
      int afw = serverClients[i].availableForWrite();
      if (afw) {
        if (!maxToTcp) {
          maxToTcp = afw;
        } else {
          maxToTcp = std::min(maxToTcp, afw);
        }
      }
    }

  //check UART for data
  size_t len = std::min(Serial.available(), maxToTcp);
  len = std::min(len, (size_t)STACK_PROTECTOR);
  if (len) {
    uint8_t sbuf[len];
    int serial_got = Serial.readBytes(sbuf, len);
    // push UART data to Service Session
    if (serverClients[0].availableForWrite() >= serial_got) {
      size_t tcp_sent = serverClients[0].write(sbuf, serial_got);
    }
  }
}
