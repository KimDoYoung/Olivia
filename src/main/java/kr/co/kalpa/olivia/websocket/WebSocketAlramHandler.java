package kr.co.kalpa.olivia.websocket;

import java.util.ArrayList;
import java.util.List;

import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;

import lombok.extern.slf4j.Slf4j;

@Slf4j
public class WebSocketAlramHandler extends TextWebSocketHandler  {

	private List<WebSocketSession> sessions = new ArrayList<>();
	
	@Override
	public void afterConnectionEstablished(WebSocketSession session) throws Exception {
		log.debug("connected  : {}", session);
		sessions.add(session);
	}

    @Override
    protected void handleTextMessage(WebSocketSession session, TextMessage message) throws Exception {
    	log.debug("message : {}", message.getPayload());
        for (WebSocketSession s : sessions) {
            if (!s.equals(session)) {
                s.sendMessage(message);
            }
        }
    }
    
    /*** 복잡한 데이터를 보낸다. */
//    @Override
//    protected void handleTextMessage(WebSocketSession session, TextMessage message) throws Exception {
//        log.debug("message : {}", message.getPayload());
//
//        // 메시지 객체 생성
//        Message msgObj = new Message();
//        msgObj.setSender("senderName"); // 예시 값
//        msgObj.setDate("2023-01-01T12:00:00"); // 예시 값
//        msgObj.setContent(message.getPayload());
//
//        // ObjectMapper를 사용하여 객체를 JSON 문자열로 변환
//        ObjectMapper mapper = new ObjectMapper();
//        String jsonMsg = mapper.writeValueAsString(msgObj);
//
//        // 모든 세션에 JSON 형태의 메시지 전송
//        for (WebSocketSession s : sessions) {
//            if (!s.equals(session)) {
//                s.sendMessage(new TextMessage(jsonMsg));
//            }
//        }
//    }    

	@Override
	public void afterConnectionClosed(WebSocketSession session, CloseStatus closeStatus) throws Exception {
		log.debug("closed: {}", session);
	    sessions.remove(session); // 세션 제거
	}
}
