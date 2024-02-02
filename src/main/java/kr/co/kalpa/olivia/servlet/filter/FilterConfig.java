package kr.co.kalpa.olivia.servlet.filter;

import org.springframework.boot.web.servlet.FilterRegistrationBean;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class FilterConfig {
    @Bean
    public FilterRegistrationBean<IpCheckFilter> ipCheckFilter() {
        FilterRegistrationBean<IpCheckFilter> registrationBean = new FilterRegistrationBean<>();
        registrationBean.setFilter(new IpCheckFilter());
        registrationBean.addUrlPatterns("/*"); // 모든 요청에 대해 필터 적용
        return registrationBean;
    }
}