package kr.co.kalpa.olivia.model.openapi.holiday;

import java.util.List;
import javax.xml.bind.annotation.XmlElement;

import kr.co.kalpa.olivia.model.schedule.SpecialDay;
import lombok.Data;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;

@XmlAccessorType(XmlAccessType.FIELD)
@Data
public class ApiItems {
    @XmlElement(name = "item")
    private List<SpecialDay> item;

}
