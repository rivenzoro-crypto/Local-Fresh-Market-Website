package controller;

import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.Arrays;
import java.util.List;
import java.util.Locale;

import dao.CheckoutDAO;
import dao.OrderDAO;
import dao.OrderItemDAO;
import entity.Order;
import entity.OrderItem;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import util.AppLogger;
import util.CsrfUtil;

@WebServlet("/admin-orders")
public class AdminOrderController extends HttpServlet {

    private static final List<String> ALLOWED_STATUSES = Arrays.asList(
            "pending", "confirmed", "processing", "shipping", "delivered", "cancelled");

    private final OrderDAO orderDAO = new OrderDAO();
    private final OrderItemDAO orderItemDAO = new OrderItemDAO();
    private final CheckoutDAO checkoutDAO = new CheckoutDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String mode = req.getParameter("mode");
        if ("detail".equalsIgnoreCase(mode)) {
            viewOrderDetail(req, resp);
            return;
        }
        showAdminOrderPage(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        if (!CsrfUtil.isValid(req, req.getSession(false))) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Your session token is invalid. Refresh the page and try again.");
            return;
        }

        String mode = req.getParameter("mode");
        if ("updateStatus".equalsIgnoreCase(mode)) {
            updateOrderStatus(req, resp);
        } else if ("delete".equalsIgnoreCase(mode)) {
            deleteOrder(req, resp);
        } else {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Unsupported order action.");
        }
    }

    private void showAdminOrderPage(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String keyword = clean(req.getParameter("keyword"));
        String status = clean(req.getParameter("filterStatus"));
        String orderType = clean(req.getParameter("filterOrderType"));
        if (orderType == null) orderType = clean(req.getParameter("orderType"));
        if (status == null && !"updateStatus".equalsIgnoreCase(req.getParameter("mode"))) {
            status = clean(req.getParameter("status"));
        }
        String fromValue = clean(req.getParameter("dateFrom"));
        String toValue = clean(req.getParameter("dateTo"));
        String minValue = clean(req.getParameter("minAmount"));
        String maxValue = clean(req.getParameter("maxAmount"));

        LocalDate dateFrom = null;
        LocalDate dateTo = null;
        BigDecimal minAmount = null;
        BigDecimal maxAmount = null;
        String filterError = null;

        if (status != null && !"all".equalsIgnoreCase(status)
                && !ALLOWED_STATUSES.contains(status.toLowerCase(Locale.ROOT))) {
            filterError = "Please choose a valid order status.";
            status = "all";
        }

        if (orderType != null && !"all".equalsIgnoreCase(orderType)
                && !"retail".equalsIgnoreCase(orderType) && !"wholesale".equalsIgnoreCase(orderType)) {
            filterError = "Please choose a valid order type.";
            orderType = "all";
        }

        try {
            if (fromValue != null) dateFrom = LocalDate.parse(fromValue);
            if (toValue != null) dateTo = LocalDate.parse(toValue);
            if (dateFrom != null && dateTo != null && dateFrom.isAfter(dateTo)) {
                throw new IllegalArgumentException("Start date must not be after end date.");
            }
            if (minValue != null) minAmount = new BigDecimal(minValue);
            if (maxValue != null) maxAmount = new BigDecimal(maxValue);
            if ((minAmount != null && minAmount.signum() < 0)
                    || (maxAmount != null && maxAmount.signum() < 0)) {
                throw new IllegalArgumentException("Amounts cannot be negative.");
            }
            if (minAmount != null && maxAmount != null && minAmount.compareTo(maxAmount) > 0) {
                throw new IllegalArgumentException("Minimum amount must not exceed maximum amount.");
            }
        } catch (DateTimeParseException ex) {
            filterError = "Please enter valid dates.";
        } catch (NumberFormatException ex) {
            filterError = "Please enter valid order amounts.";
        } catch (IllegalArgumentException ex) {
            filterError = ex.getMessage();
        }

        List<Order> orders;
        if (filterError == null) {
            orders = orderDAO.searchOrders(keyword, status, orderType, dateFrom, dateTo, minAmount, maxAmount);
        } else {
            orders = orderDAO.getAllOrders();
            req.setAttribute("filterError", filterError);
        }

        req.setAttribute("orders", orders);
        req.setAttribute("matchingOrderCount", orders.size());
        req.setAttribute("keyword", keyword == null ? "" : keyword);
        req.setAttribute("statusFilter", status == null ? "all" : status);
        req.setAttribute("orderTypeFilter", orderType == null ? "all" : orderType.toUpperCase(Locale.ROOT));
        req.setAttribute("dateFrom", fromValue == null ? "" : fromValue);
        req.setAttribute("dateTo", toValue == null ? "" : toValue);
        req.setAttribute("minAmount", minValue == null ? "" : minValue);
        req.setAttribute("maxAmount", maxValue == null ? "" : maxValue);
        req.setAttribute("currentPage", "orders");
        req.setAttribute("csrfToken", CsrfUtil.ensureToken(req.getSession()));
        req.getRequestDispatcher("admin/admin-orders.jsp").forward(req, resp);
    }

    private void viewOrderDetail(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        Long orderId = parseId(req.getParameter("id"));
        if (orderId == null) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid order ID.");
            return;
        }

        Order order = orderDAO.getOrderById(orderId);
        if (order == null) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND, "Order not found.");
            return;
        }

        List<OrderItem> orderItems = orderItemDAO.getAllOrderItemsByOrderId(orderId);
        req.setAttribute("order", order);
        req.setAttribute("orderItems", orderItems);
        req.setAttribute("currentPage", "orders");
        req.getRequestDispatcher("admin/admin-order-detail.jsp").forward(req, resp);
    }

    private void updateOrderStatus(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        Long id = parseId(req.getParameter("id"));
        String newStatus = clean(req.getParameter("status"));
        if (id == null || newStatus == null
                || !ALLOWED_STATUSES.contains(newStatus.toLowerCase(Locale.ROOT))) {
            req.setAttribute("msg", "Invalid order or status.");
            showAdminOrderPage(req, resp);
            return;
        }

        newStatus = newStatus.toLowerCase(Locale.ROOT);
        Order order = orderDAO.getOrderById(id);
        if (order == null) {
            req.setAttribute("msg", "Order not found.");
        } else if (newStatus.equalsIgnoreCase(order.getStatus())) {
            req.setAttribute("msg", "No status change was needed.");
        } else if ("cancelled".equalsIgnoreCase(newStatus)) {
            boolean updated = checkoutDAO.cancelOrderAndRestock(id);
            req.setAttribute("msg", updated ? "Order cancelled and stock restored." : "Could not cancel this order.");
        } else if ("cancelled".equalsIgnoreCase(order.getStatus())) {
            req.setAttribute("msg", "A cancelled order cannot be reopened automatically.");
        } else {
            order.setStatus(newStatus);
            boolean updated = Boolean.TRUE.equals(orderDAO.updateOrder(order));
            req.setAttribute("msg", updated ? "Order status updated successfully." : "Could not update this order.");
        }
        showAdminOrderPage(req, resp);
    }

    private void deleteOrder(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        Long id = parseId(req.getParameter("id"));
        Order order = id == null ? null : orderDAO.getOrderById(id);

        if (order == null || !"cancelled".equalsIgnoreCase(order.getStatus())) {
            req.setAttribute("msg", "Cancel the order before deleting it so inventory can be restored safely.");
            showAdminOrderPage(req, resp);
            return;
        }

        List<OrderItem> items = orderItemDAO.getAllOrderItemsByOrderId(id);
        for (OrderItem item : items) {
            orderItemDAO.deleteOrderItem(item.getId());
        }

        boolean deleted = Boolean.TRUE.equals(orderDAO.deleteOrder(id));
        req.setAttribute("msg", deleted ? "Order deleted successfully." : "Failed to delete order. It may be referenced by another record.");
        showAdminOrderPage(req, resp);
    }

    private Long parseId(String value) {
        try {
            return value == null ? null : Long.valueOf(value);
        } catch (NumberFormatException ex) {
            AppLogger.warning(AdminOrderController.class, "Received an invalid order ID.");
            return null;
        }
    }

    private String clean(String value) {
        if (value == null || value.trim().isEmpty()) return null;
        return value.trim();
    }
}
