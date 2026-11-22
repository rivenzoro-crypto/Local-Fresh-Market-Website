package controller;

import java.io.IOException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

import dao.CheckoutDAO;
import dao.OrderDAO;
import dao.OrderItemDAO;
import entity.Order;
import entity.OrderItem;
import entity.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import util.CsrfUtil;
import util.MailUtil;

@WebServlet("/orders")
public class OrdersController extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(OrdersController.class.getName());

    private final OrderDAO orderDAO = new OrderDAO();
    private final OrderItemDAO orderItemDAO = new OrderItemDAO();
    private final CheckoutDAO checkoutDAO = new CheckoutDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        User loginUser = session == null ? null : (User) session.getAttribute("loginUser");

        if (loginUser == null) {
            resp.sendRedirect(req.getContextPath() + "/users?mode=login");
            return;
        }

        String mode = req.getParameter("mode");
        if (mode == null || mode.isEmpty()) {
            mode = "list";
        }

        switch (mode) {
            case "list":
                showUserOrders(req, resp, loginUser);
                break;
            case "detail":
                viewUserOrderDetail(req, resp, loginUser);
                break;
            case "address":
                CsrfUtil.ensureToken(session);
                req.getRequestDispatcher("order-address.jsp").forward(req, resp);
                break;
            case "create":
                // Checkout must be POST-only. This also prevents refresh/replay of a GET URL.
                session.setAttribute("cartMessage", "Please use the Place Order button in your cart.");
                resp.sendRedirect(req.getContextPath() + "/carts?mode=view");
                break;
            default:
                showUserOrders(req, resp, loginUser);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        User loginUser = session == null ? null : (User) session.getAttribute("loginUser");

        if (loginUser == null) {
            resp.sendRedirect(req.getContextPath() + "/users?mode=login");
            return;
        }

        if (!CsrfUtil.isValid(req, session)) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Invalid or expired form token.");
            return;
        }

        if (!"create".equals(req.getParameter("mode"))) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Unsupported order action.");
            return;
        }

        String city = trim(req.getParameter("city"));
        String township = trim(req.getParameter("township"));
        String street = trim(req.getParameter("street"));
        String description = trim(req.getParameter("description"));
        if (!"Mandalay".equalsIgnoreCase(city) || township.isEmpty() || street.isEmpty()
                || township.length() > 100 || street.length() > 255 || description.length() > 500) {
            req.setAttribute("addressError", "Please select Mandalay and complete Township and Street. Description must be 500 characters or fewer.");
            req.setAttribute("city", "Mandalay");
            req.setAttribute("township", township);
            req.setAttribute("street", street);
            req.setAttribute("description", description);
            CsrfUtil.ensureToken(session);
            req.getRequestDispatcher("order-address.jsp").forward(req, resp);
            return;
        }

        CheckoutDAO.CheckoutResult result = checkoutDAO.checkout(loginUser.getId(), city, township, street, description);

        if (!result.isSuccessful()) {
            session.setAttribute("cartMessage", result.getMessage());
            resp.sendRedirect(req.getContextPath() + "/carts?mode=view");
            return;
        }

        // The checkout transaction has committed and the cart is empty now.
        session.setAttribute("itemCount", 0);
        session.removeAttribute("cart");

        // Email is deliberately sent AFTER commit. An email failure must not undo a valid order.
        try {
            MailUtil.sendOrderMail(loginUser.getEmail(), "Order Submitted Successfully");
        } catch (Exception ex) {
            LOGGER.log(Level.WARNING, "Order was created, but confirmation email could not be sent.", ex);
        }

        resp.sendRedirect(req.getContextPath() + "/orders?mode=detail&id=" + result.getOrderId());
    }

    private String trim(String value) {
        return value == null ? "" : value.trim();
    }

    private void showUserOrders(HttpServletRequest req, HttpServletResponse resp, User loginUser)
            throws ServletException, IOException {

        List<Order> userOrders = orderDAO.getAllOrdersByUserId(loginUser.getId());
        req.setAttribute("orders", userOrders);
        req.getRequestDispatcher("orders.jsp").forward(req, resp);
    }

    private void viewUserOrderDetail(HttpServletRequest req, HttpServletResponse resp, User loginUser)
            throws ServletException, IOException {

        Long orderId;
        try {
            orderId = Long.parseLong(req.getParameter("id"));
            if (orderId <= 0) {
                throw new NumberFormatException("Order ID must be positive.");
            }
        } catch (NumberFormatException ex) {
            resp.sendRedirect(req.getContextPath() + "/orders?mode=list");
            return;
        }

        Order order = orderDAO.getOrderById(orderId);
        if (order == null || order.getUser() == null || order.getUser().getId() == null
                || !order.getUser().getId().equals(loginUser.getId())) {
            req.setAttribute("msg", "Order not found or access denied.");
            showUserOrders(req, resp, loginUser);
            return;
        }

        List<OrderItem> orderItems = orderItemDAO.getAllOrderItemsByOrderId(orderId);
        req.setAttribute("order", order);
        req.setAttribute("orderItems", orderItems);
        req.getRequestDispatcher("order-detail.jsp").forward(req, resp);
    }
}
