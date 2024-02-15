package kr.co.kalpa.olivia.model.openapi.holiday;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;

import lombok.Data;

@XmlAccessorType(XmlAccessType.FIELD)
@Data
public class CmmMsgHeader {
    @XmlElement(name = "errMsg")
    private String errMsg;

    @XmlElement(name = "returnAuthMsg")
    private String returnAuthMsg;

    @XmlElement(name = "returnReasonCode")
    private String returnReasonCode;

    // getters and setters
}