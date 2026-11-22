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
public class Product {
    private long id;
    private String name;
    private String description;
    private double price;
    private int stock;
    private String imageUrl;
    private boolean active;
    private Long categoryId;
    private String categoryName;
    private String categorySlug;
    private Boolean specialSale;
    private String discountType;
    private Double discountValue;
    private LocalDateTime saleStartDate;
    private LocalDateTime saleEndDate;
    
    
    public double getEffectivePrice() {
        if (!Boolean.TRUE.equals(specialSale) || discountType == null || discountValue == null) {
            return price;
        }
        
        // Auto Sale Date Check
        java.time.LocalDateTime now = java.time.LocalDateTime.now();
        if (saleStartDate != null && now.isBefore(saleStartDate)) return price;
        if (saleEndDate != null && now.isAfter(saleEndDate)) return price;

        if ("PERCENT".equals(discountType)) {
            return price - (price * (discountValue / 100.0));
        } else if ("FIXED".equals(discountType)) {
            return Math.max(0, price - discountValue);
        }
        return price;
    }

    public boolean isCurrentlyOnSale() {
        if (!Boolean.TRUE.equals(specialSale)) return false;
        java.time.LocalDateTime now = java.time.LocalDateTime.now();
        if (saleStartDate != null && now.isBefore(saleStartDate)) return false;
        if (saleEndDate != null && now.isAfter(saleEndDate)) return false;
        return true;
    }
    
}
