package controller;

import java.io.IOException;
import dao.DashboardDAO;
import entity.DashboardStats;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/admin-dashboard")
public class AdminDashboardController extends HttpServlet {
    private final DashboardDAO dashboardDAO = new DashboardDAO();
    @Override protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        DashboardStats stats = dashboardDAO.getDashboardStats();
        req.setAttribute("dashboardStats", stats);
        req.setAttribute("currentPage", "dashboard");
        req.getRequestDispatcher("admin/dashboard.jsp").forward(req, resp);
    }
}
