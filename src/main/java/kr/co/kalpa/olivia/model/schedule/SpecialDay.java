package kr.co.kalpa.olivia.model.schedule;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;

import lombok.Data;

@Data
@XmlAccessorType(XmlAccessType.FIELD)
public class SpecialDay {
    // 날짜
	@XmlElement(name = "locdate")
    private String locDate;

    // 순번
	@XmlElement(name = "seq")
    private int seq;

    // 종류
    @XmlElement(name = "dateKind")
    private String dateKind;

    // 공공기관 휴일여부 (Y: 휴일, N: 비휴일)
    @XmlElement(name = "isHoliday")
    private String holidayYn;

    // 명칭
    @XmlElement(name = "dateName")
    private String dateName;

    private String createdBy;
    
    private String createdOn;
}
