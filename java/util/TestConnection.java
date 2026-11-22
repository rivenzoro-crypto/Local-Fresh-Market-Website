package util;

import java.sql.Connection;
import java.sql.SQLException;

public class TestConnection {

	public static void main(String[] args) {
		// TODO Auto-generated method stub
		try {
			Connection con=DBConnection.getConnection();
			System.out.println("DB Connection Success");
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			System.err.println("DB Connection Fail");
			e.printStackTrace();
		}
	}

}
