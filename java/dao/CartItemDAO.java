package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import entity.CartItem;
import util.DBConnection;

public class CartItemDAO {

	// dependency injection
	private final CartDAO cartDAO = new CartDAO();
	private final ProductDAO productDAO = new ProductDAO();

	// createCartItem
	public Boolean createCartItem(CartItem cartItem) {
		Boolean status = false;

		String query = "INSERT INTO cartitem "
				+ "(cart_id, product_id, qty, price)"
				+ " VALUES (?,?,?,?);";

		try {
			Connection con = DBConnection.getConnection();
			PreparedStatement pstmt = con.prepareStatement(query);

			pstmt.setLong(1, cartItem.getCart().getId());
			pstmt.setLong(2, cartItem.getProduct().getId());
			pstmt.setInt(3, cartItem.getQty());
			pstmt.setDouble(4, cartItem.getPrice());

			if (pstmt.executeUpdate() > 0)
				status = true;

		} catch (SQLException e) {
			e.printStackTrace();
		}
		return status;
	}

	// getAllCartItems
	public List<CartItem> getAllCartItems() {
		List<CartItem> itemList = new ArrayList<CartItem>();
		String query = "SELECT * FROM cartitem";

		try {
			Connection con = DBConnection.getConnection();
			Statement stmt = con.createStatement();

			ResultSet rs = stmt.executeQuery(query);

			while (rs.next()) {
				CartItem cartItem = new CartItem();
				cartItem.setId(rs.getLong("id"));

				// cart & product objects
				cartItem.setCart(cartDAO.getCartById(rs.getLong("cart_id")));
				cartItem.setProduct(productDAO.getProductById(rs.getLong("product_id")));

				cartItem.setQty(rs.getInt("qty"));
				cartItem.setPrice(rs.getDouble("price"));

				itemList.add(cartItem);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return itemList;
	}

	// getCartItemById
	public CartItem getCartItemById(Long id) {
		CartItem cartItem = null;
		String query = "SELECT * FROM cartitem WHERE id=?";

		try {
			Connection con = DBConnection.getConnection();
			PreparedStatement pstmt = con.prepareStatement(query);

			pstmt.setLong(1, id);

			ResultSet rs = pstmt.executeQuery();

			if (rs.next()) {
				cartItem = new CartItem();
				cartItem.setId(rs.getLong("id"));

				// cart & product objects
				cartItem.setCart(cartDAO.getCartById(rs.getLong("cart_id")));
				cartItem.setProduct(productDAO.getProductById(rs.getLong("product_id")));

				cartItem.setQty(rs.getInt("qty"));
				cartItem.setPrice(rs.getDouble("price"));
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return cartItem;
	}

	// getAllCartItemsByCartId
	public List<CartItem> getAllCartItemsByCartId(Long cartId) {
		List<CartItem> itemList = new ArrayList<CartItem>();
		String query = "SELECT * FROM cartitem WHERE cart_id=?";

		try {
			Connection con = DBConnection.getConnection();
			PreparedStatement pstmt = con.prepareStatement(query);

			pstmt.setLong(1, cartId);

			ResultSet rs = pstmt.executeQuery();

			while (rs.next()) {
				CartItem cartItem = new CartItem();
				cartItem.setId(rs.getLong("id"));

				// cart & product objects
				cartItem.setCart(cartDAO.getCartById(rs.getLong("cart_id")));
				cartItem.setProduct(productDAO.getProductById(rs.getLong("product_id")));

				cartItem.setQty(rs.getInt("qty"));
				cartItem.setPrice(rs.getDouble("price"));

				itemList.add(cartItem);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return itemList;
	}

	// updateCartItem (updating quantity or price)
	public Boolean updateCartItem(CartItem cartItem) {
		Boolean status = false;

		String query = "UPDATE cartitem SET cart_id=?, product_id=?, qty=?, price=? WHERE id=?";

		try {
			Connection con = DBConnection.getConnection();
			PreparedStatement pstmt = con.prepareStatement(query);

			pstmt.setLong(1, cartItem.getCart().getId());
			pstmt.setLong(2, cartItem.getProduct().getId());
			pstmt.setInt(3, cartItem.getQty());
			pstmt.setDouble(4, cartItem.getPrice());
			pstmt.setLong(5, cartItem.getId());

			if (pstmt.executeUpdate() > 0)
				status = true;

		} catch (SQLException e) {
			e.printStackTrace();
		}
		return status;
	}

	// deleteCartItem
	public Boolean deleteCartItem(Long id) {
		Boolean status = false;

		String query = "DELETE FROM cartitem WHERE id=?";

		try {
			Connection con = DBConnection.getConnection();
			PreparedStatement pstmt = con.prepareStatement(query);

			pstmt.setLong(1, id);

			if (pstmt.executeUpdate() > 0)
				status = true;

		} catch (SQLException e) {
			e.printStackTrace();
		}
		return status;
	}

	// clearCartByCartId (removes all items from a single cart)
	public Boolean clearCartByCartId(Long cartId) {
		Boolean status = false;

		String query = "DELETE FROM cartitem WHERE cart_id=?";

		try {
			Connection con = DBConnection.getConnection();
			PreparedStatement pstmt = con.prepareStatement(query);

			pstmt.setLong(1, cartId);

			if (pstmt.executeUpdate() > 0)
				status = true;

		} catch (SQLException e) {
			e.printStackTrace();
		}
		return status;
	}

}