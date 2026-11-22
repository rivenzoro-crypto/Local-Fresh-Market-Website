package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import entity.Address;
import entity.User;
import util.DBConnection;

public class AddressDAO {
	
	//dependency injection
	private final UserDAO userDAO=new UserDAO();
	
	//crud
	public Boolean createAddress(Address address) {
		Boolean status=false;
		
		String query="INSERT INTO address"
				+ " (user_id,street,city,region,postalCode)"
				+ " VALUES (?,?,?,?,?);";
		
		try {
				Connection con=DBConnection.getConnection();
				PreparedStatement pstmt=con.prepareStatement(query);
				
				pstmt.setLong(1, address.getUser().getId());
				pstmt.setString(2, address.getStreet());
				pstmt.setString(3, address.getCity());
				pstmt.setString(4, address.getRegion());
				pstmt.setString(5, address.getPostalCode());
				
				if (pstmt.executeUpdate() > 0)
					status=true;
				
			
			} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return status;
	}
	
	
	//read all
	public List<Address> getAllAddress(){
		List<Address> addLst=new ArrayList<Address>();
		String query="select * from address";
		
		try {
			Connection con=DBConnection.getConnection();
			Statement stmt=con.createStatement();
			
			ResultSet rs=stmt.executeQuery(query);
			
			while(rs.next()) {
				Address address=new Address();
				address.setId(rs.getLong("id"));
				
				// user object (new concept)				
//				Long userId=rs.getLong("user_id");
//				User user=userDAO.getUserById(userId);
//				address.setUser(user);
				
				// user object (new concept)
				address.setUser(userDAO.getUserById(rs.getLong("user_id")));
				
				address.setCity(rs.getString("city"));
				address.setStreet(rs.getString("street"));
				address.setPostalCode(rs.getString("postalCode"));
				address.setRegion(rs.getString("region"));
				
				addLst.add(address);
				
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return addLst;
		
	}

	public Address getAddressById(Long id){
		Address address=new Address();
		String query="select * from address where id=?";
		
		try {
			Connection con=DBConnection.getConnection();
			PreparedStatement pstmt=con.prepareStatement(query);
			
			pstmt.setLong(1, id);
			
			ResultSet rs=pstmt.executeQuery();
			
			if(rs.next()) {
				
				address.setId(rs.getLong("id"));
				
				// user object (new concept)
				address.setUser(userDAO.getUserById(rs.getLong("user_id")));
				
				address.setCity(rs.getString("city"));
				address.setStreet(rs.getString("street"));
				address.setPostalCode(rs.getString("postalCode"));
				address.setRegion(rs.getString("region"));
				
				
				
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return address;
		
	}
	
	//lab test
	//public List<Address> getAddressByUserId(Long userId)
	// query= "selet * from address where user_id=?"
	public List<Address> getAllAddressByUserId(Long userId){
		List<Address> addLst=new ArrayList<Address>();
		String query="select * from address where user_id=?";
		
		try {
			Connection con=DBConnection.getConnection();
			PreparedStatement pstmt=con.prepareStatement(query);
			
			pstmt.setLong(1, userId);
			
			ResultSet rs=pstmt.executeQuery();
			
			while(rs.next()) {
				Address address=new Address();
				address.setId(rs.getLong("id"));
				
				
				// user object (new concept)
				address.setUser(userDAO.getUserById(rs.getLong("user_id")));
				
				address.setCity(rs.getString("city"));
				address.setStreet(rs.getString("street"));
				address.setPostalCode(rs.getString("postalCode"));
				address.setRegion(rs.getString("region"));
				
				addLst.add(address);
				
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return addLst;
		
	}
	
	//hw
		//updateAddress
		public Boolean updateAddress(Address address) {
			Boolean status=false;
			
			String query="UPDATE address SET user_id=?, street=?, city=?, region=?, postalCode=? WHERE id=?";
			
			try {
				Connection con=DBConnection.getConnection();
				PreparedStatement pstmt=con.prepareStatement(query);
				
				pstmt.setLong(1, address.getUser().getId());
				pstmt.setString(2, address.getStreet());
				pstmt.setString(3, address.getCity());
				pstmt.setString(4, address.getRegion());
				pstmt.setString(5, address.getPostalCode());
				pstmt.setLong(6, address.getId());
				
				if (pstmt.executeUpdate() > 0)
					status=true;
				
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			return status;
		}
		
	
	
}
