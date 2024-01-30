package kr.co.kalpa.olivia.model.schedule;

import lombok.Data;

@Data
public class SpecialDay {
    // 날짜
    private String locDate;

    // 순번
    private int seq;

    // 종류
    private String dateKind;

    // 공공기관 휴일여부 (Y: 휴일, N: 비휴일)
    private String holidayYn;

    // 명칭
    private String dateName;

    private String createdBy;
    
    private String createdOn;
}
