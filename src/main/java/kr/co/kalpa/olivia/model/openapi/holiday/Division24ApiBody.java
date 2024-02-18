package kr.co.kalpa.olivia.model.openapi.holiday;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;

import lombok.Data;

@XmlAccessorType(XmlAccessType.FIELD)
@Data
public class Division24ApiBody {
    @XmlElement(name = "items")
    private Division24ApiItems items;

}
