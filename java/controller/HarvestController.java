package controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import dao.CategoryDAO;
import dao.ProductDAO;
import entity.Category;
import entity.Product;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import util.CsrfUtil;

@WebServlet("/harvest")
public class HarvestController extends HttpServlet {
    private final ProductDAO productDAO = new ProductDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(true);
        CsrfUtil.ensureToken(session);

        List<Category> categories = categoryDAO.getActiveCategories();
        List<Product> featured = productDAO.getActiveProducts(null, null);
        if (featured == null) featured = new ArrayList<>();
        if (featured.size() > 8) featured = new ArrayList<>(featured.subList(0, 8));

        req.setAttribute("categories", categories);
        req.setAttribute("featuredProducts", featured);
        req.getRequestDispatcher("harvest.jsp").forward(req, resp);
    }
}
