package controller;

import java.io.IOException;
import dao.DashboardDAO;
import entity.AdminSearchResults;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/admin-search")
public class AdminSearchController extends HttpServlet {
    private final DashboardDAO dashboardDAO = new DashboardDAO();
    @Override protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String q = req.getParameter("q");
        AdminSearchResults results = dashboardDAO.search(q);
        req.setAttribute("q", q == null ? "" : q.trim());
        req.setAttribute("results", results);
        req.setAttribute("currentPage", "search");
        req.getRequestDispatcher("admin/admin-search.jsp").forward(req, resp);
    }
}
