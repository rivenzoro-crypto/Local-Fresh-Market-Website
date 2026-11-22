package entity;


import java.time.LocalDateTime;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class OTP_Verification {
	
	private Long id;
	private String email;
	private String otp;
	private LocalDateTime createdAt;
	private LocalDateTime expiredAt;
	private Boolean used;

}
