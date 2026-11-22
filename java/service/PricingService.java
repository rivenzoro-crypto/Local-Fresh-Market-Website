package service;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDateTime;

/**
 * Centralized server-side pricing rules.
 * Priority: approved wholesale tier -> active special sale -> retail price.
 * Special-sale and wholesale discounts never stack.
 */
public class PricingService {

    public BigDecimal resolvePrice(Connection con, long userId, long productId, int quantity,
                                   BigDecimal retailPrice, boolean specialSale,
                                   String discountType, BigDecimal discountValue,
                                   LocalDateTime saleStartDate, LocalDateTime saleEndDate) throws SQLException {
        if (retailPrice == null) return BigDecimal.ZERO;

        BigDecimal wholesale = findEligibleWholesalePrice(con, userId, productId, quantity);
        if (wholesale != null) return wholesale.setScale(2, RoundingMode.HALF_UP);

        if (isSaleActive(specialSale, saleStartDate, saleEndDate) && discountType != null && discountValue != null) {
            if ("PERCENT".equalsIgnoreCase(discountType)) {
                BigDecimal factor = BigDecimal.ONE.subtract(
                        discountValue.divide(BigDecimal.valueOf(100), 6, RoundingMode.HALF_UP));
                BigDecimal result = retailPrice.multiply(factor);
                return result.max(BigDecimal.ZERO).setScale(2, RoundingMode.HALF_UP);
            }
            if ("FIXED".equalsIgnoreCase(discountType)) {
                return retailPrice.subtract(discountValue).max(BigDecimal.ZERO).setScale(2, RoundingMode.HALF_UP);
            }
        }
        return retailPrice.setScale(2, RoundingMode.HALF_UP);
    }

    public boolean isWholesaleApproved(Connection con, long userId) throws SQLException {
        String sql = "SELECT 1 FROM wholesale_application WHERE user_id=? AND UPPER(status)='APPROVED' LIMIT 1";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, userId);
            try (ResultSet rs = ps.executeQuery()) { return rs.next(); }
        }
    }

    private BigDecimal findEligibleWholesalePrice(Connection con, long userId, long productId, int quantity) throws SQLException {
        if (quantity <= 0 || !isWholesaleApproved(con, userId)) return null;
        String sql = "SELECT wholesale_price FROM product_wholesale_pricing " +
                "WHERE product_id=? AND active=1 AND min_quantity<=? " +
                "ORDER BY min_quantity DESC LIMIT 1";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, productId);
            ps.setInt(2, quantity);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getBigDecimal("wholesale_price") : null;
            }
        }
    }

    private boolean isSaleActive(boolean specialSale, LocalDateTime start, LocalDateTime end) {
        if (!specialSale) return false;
        LocalDateTime now = LocalDateTime.now();
        return (start == null || !now.isBefore(start)) && (end == null || !now.isAfter(end));
    }
}
