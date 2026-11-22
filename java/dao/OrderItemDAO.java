package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import entity.OrderItem;
import util.DBConnection;

public class OrderItemDAO {

	// dependency injection
	private final OrderDAO orderDAO = new OrderDAO();
	private final ProductDAO productDAO = new ProductDAO();

	/** @deprecated Do not use as a separate checkout write; use CheckoutDAO.checkout(). */
	@Deprecated
	public Boolean createOrderItem(OrderItem orderItem) {
		Boolean status = false;

		String query = "INSERT INTO orderitem "
				+ "(order_id, product_id, qty, price)"
				+ " VALUES (?,?,?,?);";

		try {
			Connection con = DBConnection.getConnection();
			PreparedStatement pstmt = con.prepareStatement(query);

			pstmt.setLong(1, orderItem.getOrder().getId());
			pstmt.setLong(2, orderItem.getProduct().getId());
			pstmt.setInt(3, orderItem.getQty());
			pstmt.setDouble(4, orderItem.getPrice());

			if (pstmt.executeUpdate() > 0)
				status = true;

		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return status;
	}

	// getAllOrderItems
	public List<OrderItem> getAllOrderItems() {
		List<OrderItem> itemList = new ArrayList<OrderItem>();
		String query = "select * from orderitem";

		try {
			Connection con = DBConnection.getConnection();
			Statement stmt = con.createStatement();

			ResultSet rs = stmt.executeQuery(query);

			while (rs.next()) {
				OrderItem orderItem = new OrderItem();
				orderItem.setId(rs.getLong("id"));

				// order & product objects
				orderItem.setOrder(orderDAO.getOrderById(rs.getLong("order_id")));
				orderItem.setProduct(productDAO.getProductById(rs.getLong("product_id")));

				orderItem.setQty(rs.getInt("qty"));
				orderItem.setPrice(rs.getDouble("price"));

				itemList.add(orderItem);
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return itemList;
	}

	// getOrderItemById
	public OrderItem getOrderItemById(Long id) {
		OrderItem orderItem = null;
		String query = "select * from orderitem where id=?";

		try {
			Connection con = DBConnection.getConnection();
			PreparedStatement pstmt = con.prepareStatement(query);

			pstmt.setLong(1, id);

			ResultSet rs = pstmt.executeQuery();

			if (rs.next()) {
				orderItem = new OrderItem();
				orderItem.setId(rs.getLong("id"));

				// order & product objects
				orderItem.setOrder(orderDAO.getOrderById(rs.getLong("order_id")));
				orderItem.setProduct(productDAO.getProductById(rs.getLong("product_id")));

				orderItem.setQty(rs.getInt("qty"));
				orderItem.setPrice(rs.getDouble("price"));
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return orderItem;
	}

	// getAllOrderItemsByOrderId
	public List<OrderItem> getAllOrderItemsByOrderId(Long orderId) {
		List<OrderItem> itemList = new ArrayList<OrderItem>();
		String query = "select * from orderitem where order_id=?";

		try {
			Connection con = DBConnection.getConnection();
			PreparedStatement pstmt = con.prepareStatement(query);

			pstmt.setLong(1, orderId);

			ResultSet rs = pstmt.executeQuery();

			while (rs.next()) {
				OrderItem orderItem = new OrderItem();
				orderItem.setId(rs.getLong("id"));

				// order & product objects
				orderItem.setOrder(orderDAO.getOrderById(rs.getLong("order_id")));
				orderItem.setProduct(productDAO.getProductById(rs.getLong("product_id")));

				orderItem.setQty(rs.getInt("qty"));
				orderItem.setPrice(rs.getDouble("price"));

				itemList.add(orderItem);
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return itemList;
	}

	// updateOrderItem
	public Boolean updateOrderItem(OrderItem orderItem) {
		Boolean status = false;

		String query = "UPDATE orderitem SET order_id=?, product_id=?, qty=?, price=? WHERE id=?";

		try {
			Connection con = DBConnection.getConnection();
			PreparedStatement pstmt = con.prepareStatement(query);

			pstmt.setLong(1, orderItem.getOrder().getId());
			pstmt.setLong(2, orderItem.getProduct().getId());
			pstmt.setInt(3, orderItem.getQty());
			pstmt.setDouble(4, orderItem.getPrice());
			pstmt.setLong(5, orderItem.getId());

			if (pstmt.executeUpdate() > 0)
				status = true;

		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return status;
	}

	// deleteOrderItem
	public Boolean deleteOrderItem(Long id) {
		Boolean status = false;

		String query = "DELETE FROM orderitem WHERE id=?";

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