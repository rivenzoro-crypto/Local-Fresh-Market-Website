package entity;

import lombok.AllArgsConstructor;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class Address {
	
	private Long id;
	private User user;// db user_id fk
	private String street;
	private String city;
	private String region;
	private String postalCode;

}
