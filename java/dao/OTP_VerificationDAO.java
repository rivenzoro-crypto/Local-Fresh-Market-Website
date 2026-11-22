package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import entity.OTP_Verification;
import util.DBConnection;

public class OTP_VerificationDAO {

	// create OTP verification record
	public Boolean createOTP(OTP_Verification otpVerification) {
		Boolean status = false;

		String query = "INSERT INTO otp_verification "
				+ "(email, otp, createdAt, expiredAt, used)"
				+ " VALUES (?,?,?,?,?);";

		try {
			Connection con = DBConnection.getConnection();
			PreparedStatement pstmt = con.prepareStatement(query);

			pstmt.setString(1, otpVerification.getEmail());
			pstmt.setString(2, otpVerification.getOtp());
			
			// Convert LocalDateTime to java.sql.Timestamp for JDBC
			pstmt.setTimestamp(3, otpVerification.getCreatedAt() != null ? Timestamp.valueOf(otpVerification.getCreatedAt()) : null);
			pstmt.setTimestamp(4, otpVerification.getExpiredAt() != null ? Timestamp.valueOf(otpVerification.getExpiredAt()) : null);
			pstmt.setBoolean(5, otpVerification.getUsed());

			if (pstmt.executeUpdate() > 0)
				status = true;

		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return status;
	}

	// getAllOTPs
	public List<OTP_Verification> getAllOTPs() {
		List<OTP_Verification> otpList = new ArrayList<OTP_Verification>();
		String query = "select * from otp_verification";

		try {
			Connection con = DBConnection.getConnection();
			Statement stmt = con.createStatement();

			ResultSet rs = stmt.executeQuery(query);

			while (rs.next()) {
				OTP_Verification otpVerification = new OTP_Verification();
				otpVerification.setId(rs.getLong("id"));
				otpVerification.setEmail(rs.getString("email"));
				otpVerification.setOtp(rs.getString("otp"));

				// Convert java.sql.Timestamp to LocalDateTime
				Timestamp createdAtTs = rs.getTimestamp("createdAt");
				if (createdAtTs != null) {
					otpVerification.setCreatedAt(createdAtTs.toLocalDateTime());
				}

				Timestamp expiredAtTs = rs.getTimestamp("expiredAt");
				if (expiredAtTs != null) {
					otpVerification.setExpiredAt(expiredAtTs.toLocalDateTime());
				}

				otpVerification.setUsed(rs.getBoolean("used"));

				otpList.add(otpVerification);
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return otpList;
	}

	// getOTPById
	public OTP_Verification getOTPById(Long id) {
		OTP_Verification otpVerification = null;
		String query = "select * from otp_verification where id=?";

		try {
			Connection con = DBConnection.getConnection();
			PreparedStatement pstmt = con.prepareStatement(query);

			pstmt.setLong(1, id);

			ResultSet rs = pstmt.executeQuery();

			if (rs.next()) {
				otpVerification = new OTP_Verification();
				otpVerification.setId(rs.getLong("id"));
				otpVerification.setEmail(rs.getString("email"));
				otpVerification.setOtp(rs.getString("otp"));

				// Convert java.sql.Timestamp to LocalDateTime
				Timestamp createdAtTs = rs.getTimestamp("createdAt");
				if (createdAtTs != null) {
					otpVerification.setCreatedAt(createdAtTs.toLocalDateTime());
				}

				Timestamp expiredAtTs = rs.getTimestamp("expiredAt");
				if (expiredAtTs != null) {
					otpVerification.setExpiredAt(expiredAtTs.toLocalDateTime());
				}

				otpVerification.setUsed(rs.getBoolean("used"));
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return otpVerification;
	}

	// getLatestOTPByEmail (useful for verifying the most recent OTP sent to a user)
	public OTP_Verification getLatestOTPByEmail(String email) {
		OTP_Verification otpVerification = null;
		String query = "select * from otp_verification where email=? order by createdAt desc limit 1";

		try {
			Connection con = DBConnection.getConnection();
			PreparedStatement pstmt = con.prepareStatement(query);

			pstmt.setString(1, email);

			ResultSet rs = pstmt.executeQuery();

			if (rs.next()) {
				otpVerification = new OTP_Verification();
				otpVerification.setId(rs.getLong("id"));
				otpVerification.setEmail(rs.getString("email"));
				otpVerification.setOtp(rs.getString("otp"));

				// Convert java.sql.Timestamp to LocalDateTime
				Timestamp createdAtTs = rs.getTimestamp("createdAt");
				if (createdAtTs != null) {
					otpVerification.setCreatedAt(createdAtTs.toLocalDateTime());
				}

				Timestamp expiredAtTs = rs.getTimestamp("expiredAt");
				if (expiredAtTs != null) {
					otpVerification.setExpiredAt(expiredAtTs.toLocalDateTime());
				}

				otpVerification.setUsed(rs.getBoolean("used"));
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return otpVerification;
	}

	// updateOTPStatus (useful to mark an OTP as used after successful verification)
	public Boolean updateOTPStatus(Long id, Boolean used) {
		Boolean status = false;

		String query = "UPDATE otp_verification SET used=? WHERE id=?";

		try {
			Connection con = DBConnection.getConnection();
			PreparedStatement pstmt = con.prepareStatement(query);

			pstmt.setBoolean(1, used);
			pstmt.setLong(2, id);

			if (pstmt.executeUpdate() > 0)
				status = true;

		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return status;
	}

	// deleteOTP
	public Boolean deleteOTP(Long id) {
		Boolean status = false;

		String query = "DELETE FROM otp_verification WHERE id=?";

		try {
			Connection con = DBConnection.getConnection();
			PreparedStatement pstmt = con.prepareStatement(query);

			pstmt.setLong(1, id);

			if (pstmt.executeUpdate() > 0)
				status = true;

		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return status;
	}

}