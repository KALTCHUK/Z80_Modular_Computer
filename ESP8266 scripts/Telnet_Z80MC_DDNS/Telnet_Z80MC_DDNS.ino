/*
  Telnet for Z80 Modular Computer
*/
#include <string.h>
#if defined(ESP8266)
  #include "ESP8266WiFi.h"
  #include "ESP8266HTTPClient.h"
#elif defined(ESP32)
  #include "WiFi.h"
  #include "HTTPClient.h"
#endif

#include <EasyDDNS.h>
#include <algorithm> // std::min

#ifndef STASSID
#define STASSID ""
#define STAPSK  ""
#endif

#define BAUD_SERIAL 250000
#define RXBUFFERSIZE 1024
#define STACK_PROTECTOR  512 // bytes
#define MAX_SRV_CLIENTS 2

#define POWER_RELAY 0
#define READY_LED 2

const char* ssid = STASSID;
const char* password = STAPSK;
const int port = 23;

WiFiServer server(port);
WiFiClient serverClients[MAX_SRV_CLIENTS];

void setup() {
  pinMode(POWER_RELAY,OUTPUT);
  digitalWrite(POWER_RELAY,HIGH);
  pinMode(READY_LED,OUTPUT);
  digitalWrite(READY_LED,HIGH);
  
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

  EasyDDNS.service("duckdns");
  EasyDDNS.client("", "");	// domain and token

  digitalWrite(READY_LED,LOW);
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
      serviceString[j] = serverClients[1].read();
      serverClients[1].write(serviceString[j++]);
    }

    switch (serviceString[0]) {
      case '0':
        digitalWrite(POWER_RELAY,HIGH);
        serverClients[1].println("\n\rPOWER OFF");
        break;
      case '1':
        digitalWrite(POWER_RELAY,LOW);
        serverClients[1].println("\n\rPOWER ON");
        break;
      default:
        serverClients[1].println("\n\rUse: 1   to turn power on");
        serverClients[1].println(    "     0   to turn power off");
    }
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
