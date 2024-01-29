package kr.co.kalpa.olivia.model.schedule;

import java.util.Date;

import lombok.Data;

@Data
public class Schedule{
    private Long id;
    private char lunarOrSolar;
    private char repeatOption;
    private String ymd;
    private String content;
    private String createdBy;
    private Date createdOn;
}    