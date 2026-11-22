package dao;

import entity.WholesaleApplication;
import util.AppLogger;
import util.DBConnection;
import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class WholesaleApplicationDAO {
    private static final String BASE_SELECT =
        "SELECT wa.*, u.name applicant_name, u.email applicant_email, r.name reviewer_name " +
        "FROM wholesale_application wa " +
        "JOIN `user` u ON u.id = wa.user_id " +
        "LEFT JOIN `user` r ON r.id = wa.reviewed_by ";

    public boolean createApplication(WholesaleApplication a) {
        if (a == null || a.getUserId() == null) return false;
        if (hasPendingOrApproved(a.getUserId())) return false;
        String sql = "INSERT INTO wholesale_application (user_id,business_name,business_type,business_address,business_phone,registration_number,status) VALUES (?,?,?,?,?,?,'PENDING')";
        try (Connection c = DBConnection.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setLong(1, a.getUserId()); ps.setString(2, a.getBusinessName()); ps.setString(3, a.getBusinessType());
            ps.setString(4, a.getBusinessAddress()); ps.setString(5, a.getBusinessPhone()); ps.setString(6, a.getRegistrationNumber());
            return ps.executeUpdate() == 1;
        } catch (SQLException e) { AppLogger.error(getClass(), "Unable to create wholesale application", e); return false; }
    }

    public WholesaleApplication getLatestByUserId(Long userId) {
        if (userId == null) return null;
        return getOne(BASE_SELECT + " WHERE wa.user_id = ? ORDER BY wa.id DESC LIMIT 1", userId);
    }
    public WholesaleApplication getById(Long id) { return id == null ? null : getOne(BASE_SELECT + " WHERE wa.id = ?", id); }

    public List<WholesaleApplication> getApplications(String status) {
        List<WholesaleApplication> out = new ArrayList<>();
        String sql = BASE_SELECT + ((status == null || status.isBlank() || "ALL".equalsIgnoreCase(status)) ? " ORDER BY wa.applied_at DESC" : " WHERE wa.status = ? ORDER BY wa.applied_at DESC");
        try (Connection c = DBConnection.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            if (sql.contains("wa.status = ?")) ps.setString(1, status.toUpperCase());
            try (ResultSet rs = ps.executeQuery()) { while (rs.next()) out.add(map(rs)); }
        } catch (SQLException e) { AppLogger.error(getClass(), "Unable to load wholesale applications", e); }
        return out;
    }

    public int countByStatus(String status) {
        String sql = "SELECT COUNT(*) FROM wholesale_application WHERE status = ?";
        try (Connection c = DBConnection.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, status); try (ResultSet rs = ps.executeQuery()) { return rs.next() ? rs.getInt(1) : 0; }
        } catch (SQLException e) { AppLogger.error(getClass(), "Unable to count wholesale applications", e); return 0; }
    }

    public boolean approve(Long id, Long adminId) { return review(id, adminId, "APPROVED", null); }
    public boolean reject(Long id, Long adminId, String reason) {
        if (reason == null || reason.trim().isEmpty()) return false;
        return review(id, adminId, "REJECTED", reason.trim());
    }

    private boolean review(Long id, Long adminId, String status, String reason) {
        if (id == null || adminId == null) return false;
        String sql = "UPDATE wholesale_application SET status=?, rejection_reason=?, reviewed_at=?, reviewed_by=? WHERE id=? AND status='PENDING'";
        try (Connection c = DBConnection.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1,status); ps.setString(2,reason); ps.setTimestamp(3,Timestamp.valueOf(LocalDateTime.now())); ps.setLong(4,adminId); ps.setLong(5,id);
            return ps.executeUpdate() == 1;
        } catch (SQLException e) { AppLogger.error(getClass(), "Unable to review wholesale application", e); return false; }
    }

    private boolean hasPendingOrApproved(Long userId) {
        String sql = "SELECT 1 FROM wholesale_application WHERE user_id=? AND status IN ('PENDING','APPROVED') LIMIT 1";
        try (Connection c=DBConnection.getConnection(); PreparedStatement ps=c.prepareStatement(sql)) { ps.setLong(1,userId); try(ResultSet rs=ps.executeQuery()){return rs.next();} }
        catch(SQLException e){AppLogger.error(getClass(),"Unable to validate wholesale application",e); return true;}
    }
    private WholesaleApplication getOne(String sql, Long id) {
        try (Connection c=DBConnection.getConnection(); PreparedStatement ps=c.prepareStatement(sql)) { ps.setLong(1,id); try(ResultSet rs=ps.executeQuery()){return rs.next()?map(rs):null;} }
        catch(SQLException e){AppLogger.error(getClass(),"Unable to load wholesale application",e); return null;}
    }
    private WholesaleApplication map(ResultSet rs) throws SQLException {
        WholesaleApplication a=new WholesaleApplication();
        a.setId(rs.getLong("id")); a.setUserId(rs.getLong("user_id")); a.setApplicantName(rs.getString("applicant_name")); a.setApplicantEmail(rs.getString("applicant_email"));
        a.setBusinessName(rs.getString("business_name")); a.setBusinessType(rs.getString("business_type")); a.setBusinessAddress(rs.getString("business_address")); a.setBusinessPhone(rs.getString("business_phone")); a.setRegistrationNumber(rs.getString("registration_number"));
        a.setStatus(rs.getString("status")); a.setRejectionReason(rs.getString("rejection_reason"));
        Timestamp ap=rs.getTimestamp("applied_at"), rv=rs.getTimestamp("reviewed_at"); if(ap!=null)a.setAppliedAt(ap.toLocalDateTime()); if(rv!=null)a.setReviewedAt(rv.toLocalDateTime());
        long reviewer=rs.getLong("reviewed_by"); if(!rs.wasNull())a.setReviewedBy(reviewer); a.setReviewerName(rs.getString("reviewer_name")); return a;
    }
}
