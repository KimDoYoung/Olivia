package kr.co.kalpa.olivia.servlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.time.LocalDate;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@WebServlet("/alram")
public class AlarmServlet extends HttpServlet {

    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

//	@Override
//    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
//        response.setContentType("text/event-stream;charset=UTF-8");
//        response.setHeader("Cache-Control", "no-cache");
//        response.setHeader("Connection", "keep-alive");
//        String msg = request.getParameter("msg");
//        log.debug("Servlet : {}", msg);
//        PrintWriter out = response.getWriter();
//        try {
//            // 메시지 전송
//            out.print("data: " +  LocalDate.now().toString() +" 시스템으로부터의 알람입니다 " + msg + "\n\n");
//            out.flush();
//        } finally {
//            out.close();
//        }
//    }
	
	@Override
  protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
      response.setContentType("text/event-stream;charset=UTF-8");
      response.setHeader("Cache-Control", "no-cache");
      response.setHeader("Connection", "keep-alive");
      String msg = request.getParameter("msg");
      log.debug("Servlet : {}", msg);
      PrintWriter out = response.getWriter();
      try {
          // 메시지 전송
          out.print("data: " +  LocalDate.now().toString() +" 시스템으로부터의 알람입니다 " + msg + "\n\n");
          out.flush();
      } finally {
          out.close();
      }
  }
}
