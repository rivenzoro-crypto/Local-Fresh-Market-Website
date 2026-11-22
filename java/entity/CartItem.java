package entity;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class CartItem {
	
	private Long id;
	// cartItem must have its own cart
	private Cart cart; // db cart_id fk
	// a cartItem is realated to a product
	private Product product; // db prodcut_id fk
	private Integer qty;
	private Double price;
}
