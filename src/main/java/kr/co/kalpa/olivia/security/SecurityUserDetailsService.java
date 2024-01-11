package kr.co.kalpa.olivia.security;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import kr.co.kalpa.olivia.model.User;

@Service
public class SecurityUserDetailsService implements UserDetailsService {

//	@Autowired
//	private Sys01UserService userService;
	
	@Autowired
	private PasswordEncoder passwordEncoder;
	
	@Override
	public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
		
		//admin userid로 로그인한 경우 ROLE_ADMIN을 부여한다. 
		String role = "ROLE_MEMBER";
		User foundUser;
		if("admin".equals(username)) {
			foundUser = new User();
			foundUser.setUserId(username);
			foundUser.setUserName("관리자");
			role = "ROLE_ADMIN";
		}else {
			foundUser = new User();
			foundUser.setUserId(username);
			foundUser.setUserName("손님");
		}
		
		List<GrantedAuthority> authorites = new ArrayList<GrantedAuthority>();
		authorites.add(new SimpleGrantedAuthority(role));
		
		return UserPrincipal.builder()
		.userId(foundUser.getUserId())
		.username(foundUser.getUserName())
		.password("1111")
		.user(foundUser)
		.authorites(authorites)
 		.build();	
	}

}
