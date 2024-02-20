package kr.co.kalpa.olivia;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.EnableAutoConfiguration;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.ComponentScan;


@SpringBootApplication
@ComponentScan(basePackages = "kr.co.kalpa.olivia")
@EnableAutoConfiguration
@MapperScan(basePackageClasses = OliviaApplication.class)
public class OliviaApplication {

	public static void main(String[] args) {
		SpringApplication.run(OliviaApplication.class, args);
	}
	
	//public class ChatServer extends WebSocketServer {

//    @Override
//    public void run(String... args) throws Exception {
//    	WebSocketServer server = new AlramServer(8887);
//        server.start();
//        System.out.println("WebSocket server started on port 8887.");
//    }

}
