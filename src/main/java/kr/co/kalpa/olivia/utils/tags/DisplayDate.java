package kr.co.kalpa.olivia.utils.tags;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.servlet.jsp.JspWriter;
import javax.servlet.jsp.tagext.SimpleTagSupport;

public class DisplayDate extends SimpleTagSupport  {

	
	private Date date;
	private String format ="yyyy-MM-dd HH:mm:ss" ;
	
	public Date getDate() {
		return date;
	}

	public void setDate(Date date) {
		this.date = date;
	}

    public String getFormat() {
		return format;
	}

	public void setFormat(String format) {
		this.format = format;
	}

	public String formatToYYYYMMDDHHMMSS(Date date) {
        // 포맷 지정
        SimpleDateFormat dateFormat = new SimpleDateFormat(this.format);
        
        // 날짜를 지정된 형식으로 포맷팅
        return dateFormat.format(date);
    }
    
	public void doTag() throws IOException {
		JspWriter out = getJspContext().getOut();
		String s = formatToYYYYMMDDHHMMSS(this.date);
		out.print(s);
	}
}

