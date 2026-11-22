package entity;

import java.time.LocalDate;
import java.time.LocalDateTime;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class Order {

	private Long id;
	// an order is related to a user
	private User user;// db user_id fk
	private LocalDateTime orderDate;
	private String status; // pending, confirmed, cancel, processing, shipping, delivered 
	private Double totalAmount;
	private String orderType; // RETAIL or WHOLESALE
    private String shippingCity;
    private String shippingTownship;
    private String shippingStreet;
    private String shippingDescription;
}
