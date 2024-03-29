package kr.co.kalpa.olivia.model.openapi.holiday;

import javax.xml.bind.annotation.XmlElement;

import lombok.Data;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;

@XmlAccessorType(XmlAccessType.FIELD)
@Data
public class HolidayApiBody {
    @XmlElement(name = "items")
    private HolidayApiItems items;

}
