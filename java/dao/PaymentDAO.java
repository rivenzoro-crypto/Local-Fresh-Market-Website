package dao;

import util.DBConnection;
import entity.Order;
import entity.Payment;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class PaymentDAO {

    private Connection conn;

    public PaymentDAO() {
        try {
            conn = DBConnection.getConnection();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }


    // ==========================================
    // CREATE PAYMENT
    // ==========================================

    public long createPayment(Payment payment) {

        String sql = """
                INSERT INTO payment
                (order_id, payment_method, amount,
                 payment_status, transaction_id)
                VALUES (?, ?, ?, ?, ?)
                """;

        try (
                PreparedStatement ps =
                        conn.prepareStatement(
                                sql,
                                Statement.RETURN_GENERATED_KEYS
                        )
        ) {

            ps.setLong(1, payment.getOrder().getId());
            ps.setString(2, payment.getPaymentMethod());
            ps.setDouble(3, payment.getAmount());
            ps.setString(4, payment.getPaymentStatus());
            ps.setString(5, payment.getTransactionId());

            int affectedRows = ps.executeUpdate();

            if (affectedRows > 0) {

                ResultSet rs =
                        ps.getGeneratedKeys();

                if (rs.next()) {
                    return rs.getLong(1);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return 0;
    }


    // ==========================================
    // GET PAYMENT BY ORDER ID
    // ==========================================

    public Payment getPaymentByOrderId(long orderId) {

        Payment payment = null;

        String sql = """
                SELECT * FROM payment
                WHERE order_id = ?
                """;

        try (
                PreparedStatement ps =
                        conn.prepareStatement(sql)
        ) {

            ps.setLong(1, orderId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                payment = new Payment();

                payment.setId(rs.getLong("id"));

                Order order = new Order();
                order.setId(rs.getLong("order_id"));

                payment.setOrder(order);

                payment.setPaymentMethod(
                        rs.getString("payment_method")
                );

                payment.setAmount(
                        rs.getDouble("amount")
                );

                payment.setPaymentStatus(
                        rs.getString("payment_status")
                );

                payment.setTransactionId(
                        rs.getString("transaction_id")
                );

                java.sql.Timestamp paymentDateTs = rs.getTimestamp("payment_date");
                if (paymentDateTs != null) {
                    payment.setPaymentDate(paymentDateTs.toLocalDateTime());
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return payment;
    }

    // ==========================================
    // UPDATE PAYMENT STATUS
    // ==========================================

    public boolean updatePaymentStatus(
            long paymentId,
            String status,
            String transactionId
    ) {

        String sql = """
                UPDATE payment
                SET payment_status = ?,
                    transaction_id = ?
                WHERE id = ?
                """;

        try (
                PreparedStatement ps =
                        conn.prepareStatement(sql)
        ) {

            ps.setString(1, status);
            ps.setString(2, transactionId);
            ps.setLong(3, paymentId);

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }
    
    
    
 // ==========================================
    // GET ALL PAYMENTS (FOR ADMIN)
    // ==========================================

    public java.util.List<Payment> getAllPayments() {
        java.util.List<Payment> payments = new java.util.ArrayList<>();
        String sql = "SELECT * FROM payment ORDER BY id DESC";

        try (
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()
        ) {
            while (rs.next()) {
                Payment payment = new Payment();
                payment.setId(rs.getLong("id"));

                Order order = new Order();
                order.setId(rs.getLong("order_id"));
                payment.setOrder(order);

                payment.setPaymentMethod(rs.getString("payment_method"));
                payment.setAmount(rs.getDouble("amount"));
                payment.setPaymentStatus(rs.getString("payment_status"));
                payment.setTransactionId(rs.getString("transaction_id"));

                java.sql.Timestamp paymentDateTs = rs.getTimestamp("payment_date");
                if (paymentDateTs != null) {
                    payment.setPaymentDate(paymentDateTs.toLocalDateTime());
                }

                payments.add(payment);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return payments;
    }


    // ==========================================
    // UPDATE PAYMENT (FULL DETAILS)
    // ==========================================

    public boolean updatePayment(Payment payment) {
        String sql = """
                UPDATE payment
                SET payment_method = ?,
                    amount = ?,
                    payment_status = ?,
                    payment_date = ?
                WHERE id = ?
                """;

        try (
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {
            ps.setString(1, payment.getPaymentMethod());
            ps.setDouble(2, payment.getAmount());
            ps.setString(3, payment.getPaymentStatus());
            
            if (payment.getPaymentDate() != null) {
                ps.setTimestamp(4, java.sql.Timestamp.valueOf(payment.getPaymentDate()));
            } else {
                ps.setNull(4, java.sql.Types.TIMESTAMP);
            }
            
            ps.setLong(5, payment.getId());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }


    // ==========================================
    // DELETE PAYMENT
    // ==========================================

    public boolean deletePayment(long id) {
        String sql = "DELETE FROM payment WHERE id = ?";

        try (
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {
            ps.setLong(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }
}