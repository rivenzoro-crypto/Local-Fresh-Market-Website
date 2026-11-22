package controller;

import java.io.IOException;
import java.time.LocalDateTime;

import dao.OrderDAO;
import dao.PaymentDAO;
import entity.Order;
import entity.Payment;
import entity.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/payments")
public class PaymentController extends HttpServlet {

    private final PaymentDAO paymentDAO = new PaymentDAO();
    private final OrderDAO orderDAO = new OrderDAO();


    @Override
    protected void doGet(HttpServletRequest req,
                         HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);

        User loginUser = session != null
                ? (User) session.getAttribute("loginUser")
                : null;

        if (loginUser == null) {
            resp.sendRedirect("users?mode=login");
            return;
        }

        String mode = req.getParameter("mode");

        if (mode == null) {
            mode = "pay";
        }

        switch (mode) {

            case "pay":
                showPaymentPage(req, resp, loginUser);
                break;

            case "success":
                showPaymentSuccess(req, resp, loginUser);
                break;

            default:
                resp.sendRedirect("orders?mode=list");
                break;
        }
    }


    // ==========================================
    // SHOW PAYMENT PAGE
    // ==========================================

    private void showPaymentPage(HttpServletRequest req,
                                 HttpServletResponse resp,
                                 User loginUser)
            throws ServletException, IOException {

        String idParam = req.getParameter("orderId");

        if (idParam == null || idParam.isEmpty()) {
            resp.sendRedirect("orders?mode=list");
            return;
        }

        Long orderId;

        try {
            orderId = Long.parseLong(idParam);
        } catch (NumberFormatException e) {
            resp.sendRedirect("orders?mode=list");
            return;
        }

        // Get order
        Order order = orderDAO.getOrderById(orderId);

        // Check order exists and belongs to logged-in user
        if (order == null
                || order.getUser() == null
                || !order.getUser().getId()
                        .equals(loginUser.getId())) {

            resp.sendRedirect("orders?mode=list");
            return;
        }

        // Check whether payment already exists
        Payment existingPayment =
                paymentDAO.getPaymentByOrderId(orderId);

        if (existingPayment != null) {

            // If already paid, go back to order
            if ("COMPLETED".equals(existingPayment.getPaymentStatus())) {

                resp.sendRedirect(
                        "orders?mode=detail&id=" + orderId
                );

                return;
            }
        }

        req.setAttribute("order", order);

        req.getRequestDispatcher("payment.jsp")
                .forward(req, resp);
    }


    // ==========================================
    // PROCESS PAYMENT
    // ==========================================

    @Override
    protected void doPost(HttpServletRequest req,
                          HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);

        User loginUser = session != null
                ? (User) session.getAttribute("loginUser")
                : null;

        if (loginUser == null) {
            resp.sendRedirect("users?mode=login");
            return;
        }

        String orderIdParam = req.getParameter("orderId");
        String paymentMethod =
                req.getParameter("paymentMethod");

        if (orderIdParam == null
                || paymentMethod == null
                || paymentMethod.isEmpty()) {

            resp.sendRedirect("orders?mode=list");
            return;
        }

        Long orderId;

        try {

            orderId = Long.parseLong(orderIdParam);

        } catch (NumberFormatException e) {

            resp.sendRedirect("orders?mode=list");
            return;
        }


        // ==========================================
        // GET ORDER
        // ==========================================

        Order order = orderDAO.getOrderById(orderId);

        if (order == null
                || order.getUser() == null
                || !order.getUser().getId()
                        .equals(loginUser.getId())) {

            resp.sendRedirect("orders?mode=list");

            return;
        }


        // ==========================================
        // PREVENT DUPLICATE PAYMENT
        // ==========================================

        Payment existingPayment =
                paymentDAO.getPaymentByOrderId(orderId);

        if (existingPayment != null) {

            resp.sendRedirect(
                    "orders?mode=detail&id=" + orderId
            );

            return;
        }


        // ==========================================
        // CREATE PAYMENT
        // ==========================================

        Payment payment = new Payment();

        payment.setOrder(order);
        payment.setPaymentMethod(paymentMethod);
        payment.setAmount(order.getTotalAmount());
        payment.setPaymentDate(LocalDateTime.now());


        // ==========================================
        // PAYMENT STATUS
        // ==========================================

        if ("CASH_ON_DELIVERY".equals(paymentMethod)) {

            payment.setPaymentStatus("PENDING");

        } else {

            // Demo payment simulation
            payment.setPaymentStatus("COMPLETED");
        }


        long generatedId = paymentDAO.createPayment(payment);
        boolean status = (generatedId > 0);


        if (status) {

            resp.sendRedirect(
                    "payments?mode=success&orderId=" + orderId
            );

        } else {

            req.setAttribute(
                    "msg",
                    "Payment failed. Please try again."
            );

            req.setAttribute("order", order);

            req.getRequestDispatcher("payment.jsp")
                    .forward(req, resp);
        }
    }


    // ==========================================
    // PAYMENT SUCCESS PAGE
    // ==========================================

    private void showPaymentSuccess(HttpServletRequest req,
                                    HttpServletResponse resp,
                                    User loginUser)
            throws ServletException, IOException {

        String idParam = req.getParameter("orderId");

        if (idParam == null) {
            resp.sendRedirect("orders?mode=list");
            return;
        }

        Long orderId;

        try {
            orderId = Long.parseLong(idParam);
        } catch (NumberFormatException e) {
            resp.sendRedirect("orders?mode=list");
            return;
        }

        Order order = orderDAO.getOrderById(orderId);

        if (order == null
                || order.getUser() == null
                || !order.getUser().getId()
                        .equals(loginUser.getId())) {

            resp.sendRedirect("orders?mode=list");
            return;
        }

        Payment payment =
                paymentDAO.getPaymentByOrderId(orderId);

        req.setAttribute("order", order);
        req.setAttribute("payment", payment);

        req.getRequestDispatcher("payment-success.jsp")
                .forward(req, resp);
    }
}