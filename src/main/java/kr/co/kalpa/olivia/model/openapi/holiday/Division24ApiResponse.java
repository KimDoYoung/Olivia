package kr.co.kalpa.olivia.model.openapi.holiday;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;

import lombok.Data;

@XmlRootElement(name = "response")
@XmlAccessorType(XmlAccessType.FIELD)
@Data
public class Division24ApiResponse {
	  @XmlElement(name = "body")
	    private Division24ApiBody body;
}
