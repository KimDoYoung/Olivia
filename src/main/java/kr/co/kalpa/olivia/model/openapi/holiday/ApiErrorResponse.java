package kr.co.kalpa.olivia.model.openapi.holiday;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;

import lombok.Data;

@Data
@XmlRootElement(name = "OpenAPI_ServiceResponse")
@XmlAccessorType(XmlAccessType.FIELD)
public class ApiErrorResponse {

    @XmlElement(name = "cmmMsgHeader")
    private CmmMsgHeader cmmMsgHeader;
}
