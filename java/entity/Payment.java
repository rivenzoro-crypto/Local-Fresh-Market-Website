package entity;


import java.time.LocalDateTime;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class Payment {
	
	private Long id;
	// cartItem must have its own cart
	private Order order; // db cart_id fk
	private String paymentMethod;
	private Double amount;
	private String paymentStatus;
	private String transactionId;
	private LocalDateTime paymentDate;
}
