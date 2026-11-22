package entity;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class OrderItem {
	
//	private Long id;
//	// orderItem must have its own order
//	private Order order; // db order_id fk
//	// an orderItem is realated to a product
//	private Product product; // db prodcut_id fk
//	private Integer qty;
//	private Double price;
	
	private long id;
    private Order order;
    private Product product;
    private Integer qty;
    private Double price;
}
