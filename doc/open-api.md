# open api 정보

## 24절기
```
https://apis.data.go.kr/B090041/openapi/service/SpcdeInfoService/get24DivisionsInfo
?serviceKey=1ROBN6Q1t6iYO9fc2SbHVby0AruUb78%2Fjd0Ruzvyv33tgJKV7WcOyZ%2BSmhnNPIYmrR0%2FppqifPYDcrywywu9ZQ%3D%3D
&solYear=2024
&solMonth=02
&kst=0120
&sunLongitude=285
&numOfRows=10
&pageNo=1
&totalCount=210114
```
* 정상 결과
```
<response>
<header>
<resultCode>00</resultCode>
<resultMsg>NORMAL SERVICE.</resultMsg>
</header>
<body>
<items>
<item>
<dateKind>03</dateKind>
<dateName>백로</dateName>
<isHoliday>N</isHoliday>
<kst>0759 </kst>
<locdate>20150908</locdate>
<seq>1</seq>
<sunLongitude>165</sunLongitude>
</item>
<item>
<dateKind>03</dateKind>
<dateName>추분</dateName>
<isHoliday>N</isHoliday>
<kst>1720 </kst>
<locdate>20150923</locdate>
<seq>1</seq>
<sunLongitude>180</sunLongitude>
</item>
</items>
<numOfRows>10</numOfRows>
<pageNo>1</pageNo>
<totalCount>2</totalCount>
</body>
</response>
```

* 에러결과
```
<OpenAPI_ServiceResponse>
<cmmMsgHeader>
<errMsg>SERVICE ERROR</errMsg>
<returnAuthMsg>SERVICE_KEY_IS_NOT_REGISTERED_ERROR</returnAuthMsg>
<returnReasonCode>30</returnReasonCode>
</cmmMsgHeader>
</OpenAPI_ServiceResponse>