package kr.co.kalpa.olivia.servlet;

import java.net.InetSocketAddress;

import org.java_websocket.WebSocket;
import org.java_websocket.handshake.ClientHandshake;
import org.java_websocket.server.WebSocketServer;
import org.springframework.stereotype.Component;

import lombok.extern.slf4j.Slf4j;

@Slf4j
public class AlramServer extends WebSocketServer {

	public AlramServer(int port) {
		super(new InetSocketAddress(port));
	}

	@Override
	public void onOpen(WebSocket conn, ClientHandshake handshake) {
		log.debug("☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★");
		log.debug("Alram서버 :  Open ....");
		log.debug("☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★");
		
	}

	@Override
	public void onClose(WebSocket conn, int code, String reason, boolean remote) {
		log.debug("☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★");
		log.debug("Alram서버 :  Close ....");
		log.debug("☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★");
	}

	@Override
	public void onMessage(WebSocket conn, String message) {
		log.debug("☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★");
		log.debug("Alram서버 :  onMessage....");
		log.debug("☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★");
		broadcast(message);
	}

	@Override
	public void onError(WebSocket conn, Exception ex) {
		log.debug("☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★");
		log.debug("Alram서버 :  onError....");
		log.debug("☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★");
	}

	@Override
	public void onStart() {
		log.debug("☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★");
		log.debug("Alram서버 :  onStart....");
		log.debug("☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★");
	} 

}
