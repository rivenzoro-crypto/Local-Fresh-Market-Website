package controller;

import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

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

@WebServlet(value = {
    "/admin-payments",
    "/admin/payments/add",
    "/admin/payments/update",
    "/admin/payments/delete"
})
public class AdminPaymentController extends HttpServlet {

    private final PaymentDAO paymentDAO = new PaymentDAO();
    private final OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {

        // Session and Admin Authentication Check
        HttpSession session = req.getSession(false);
        User loginUser = session != null ? (User) session.getAttribute("loginUser") : null;

        if (loginUser == null) {
            resp.sendRedirect(req.getContextPath() + "/users?mode=login");
            return;
        }

        String action = req.getRequestURI();

        if (action.endsWith("/delete")) {
            handleDeletePayment(req, resp);
        } else {
            showAdminPaymentPage(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        User loginUser = session != null ? (User) session.getAttribute("loginUser") : null;

        if (loginUser == null) {
            resp.sendRedirect(req.getContextPath() + "/users?mode=login");
            return;
        }

        String action = req.getRequestURI();

        if (action.endsWith("/add")) {
            handleAddPayment(req, resp);
        } else if (action.endsWith("/update")) {
            handleUpdatePayment(req, resp);
        } else {
            resp.sendRedirect(req.getContextPath() + "/admin-payments");
        }
    }

    private void showAdminPaymentPage(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        
        req.setAttribute("currentPage", "transactions");

        List<Payment> payments = paymentDAO.getAllPayments();

        // Calculate summary metrics for the dashboard cards
        double totalRevenue = 0.0;
        int pendingCount = 0;
        int completedCount = 0;

        for (Payment p : payments) {
            String status = p.getPaymentStatus();
            if ("COMPLETED".equals(status) || "PAID".equals(status)) {
                totalRevenue += p.getAmount();
                completedCount++;
            } else if ("PENDING".equals(status)) {
                pendingCount++;
            }
        }

        req.setAttribute("payments", payments);
        req.setAttribute("totalRevenue", String.format("%.2f", totalRevenue));
        req.setAttribute("pendingCount", pendingCount);
        req.setAttribute("completedCount", completedCount);
        
        req.getRequestDispatcher("/admin/admin-payments.jsp").forward(req, resp);
    }

    private void handleAddPayment(HttpServletRequest req, HttpServletResponse resp) 
            throws IOException {
        try {
            long orderId = Long.parseLong(req.getParameter("orderId"));
            double amount = Double.parseDouble(req.getParameter("amount"));
            String paymentMethod = req.getParameter("paymentMethod");
            String paymentStatus = req.getParameter("paymentStatus");
            String dateStr = req.getParameter("paymentDate");

            Order order = orderDAO.getOrderById(orderId);
            if (order != null) {
                Payment payment = new Payment();
                payment.setOrder(order);
                payment.setAmount(amount);
                payment.setPaymentMethod(paymentMethod);
                payment.setPaymentStatus(paymentStatus);

                if (dateStr != null && !dateStr.isEmpty()) {
                    payment.setPaymentDate(LocalDate.parse(dateStr).atStartOfDay());
                } else {
                    payment.setPaymentDate(LocalDateTime.now());
                }

                paymentDAO.createPayment(payment);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        resp.sendRedirect(req.getContextPath() + "/admin-payments");
    }

    private void handleUpdatePayment(HttpServletRequest req, HttpServletResponse resp) 
            throws IOException {
        try {
            long id = Long.parseLong(req.getParameter("id"));
            double amount = Double.parseDouble(req.getParameter("amount"));
            String paymentMethod = req.getParameter("paymentMethod");
            String paymentStatus = req.getParameter("paymentStatus");
            String dateStr = req.getParameter("paymentDate");

            Payment payment = new Payment();
            payment.setId(id);
            payment.setAmount(amount);
            payment.setPaymentMethod(paymentMethod);
            payment.setPaymentStatus(paymentStatus);

            if (dateStr != null && !dateStr.isEmpty()) {
                payment.setPaymentDate(LocalDate.parse(dateStr).atStartOfDay());
            }

            paymentDAO.updatePayment(payment);
        } catch (Exception e) {
            e.printStackTrace();
        }

        resp.sendRedirect(req.getContextPath() + "/admin-payments");
    }

    private void handleDeletePayment(HttpServletRequest req, HttpServletResponse resp) 
            throws IOException {
        try {
            String idParam = req.getParameter("id");
            if (idParam != null && !idParam.isEmpty()) {
                long id = Long.parseLong(idParam);
                paymentDAO.deletePayment(id);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        resp.sendRedirect(req.getContextPath() + "/admin-payments");
    }
}