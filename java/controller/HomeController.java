package controller;

import java.io.IOException;
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

@WebServlet(urlPatterns = {"", "/home", "/index"})
public class HomeController extends HttpServlet {
    private final ProductDAO productDAO = new ProductDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(true);
        CsrfUtil.ensureToken(session);

        String categorySlug = trimToNull(req.getParameter("category"));
        String searchQuery = trimToNull(req.getParameter("q"));
        if (searchQuery != null && searchQuery.length() > 80) {
            searchQuery = searchQuery.substring(0, 80);
        }

        List<Category> categories = categoryDAO.getActiveCategories();
        Category selectedCategory = categorySlug == null ? null
                : categoryDAO.getActiveCategoryBySlug(categorySlug);

        if (categorySlug != null && selectedCategory == null) {
            req.setAttribute("catalogError", "That category is unavailable. Showing all available products.");
            categorySlug = null;
        }
        
        List<Product> specialSales = productDAO.getActiveSpecialSaleProducts();
        req.setAttribute("specialSales", specialSales);

        List<Product> products = productDAO.getActiveProducts(categorySlug, searchQuery);
        if (products == null) {
            req.setAttribute("catalogError", "We could not load products right now. Please refresh the page.");
            products = java.util.Collections.emptyList();
        }

        req.setAttribute("categories", categories);
        req.setAttribute("products", products);
        req.setAttribute("selectedCategory", selectedCategory);
        req.setAttribute("selectedCategorySlug", categorySlug == null ? "" : categorySlug);
        req.setAttribute("searchQuery", searchQuery == null ? "" : searchQuery);
        req.setAttribute("productCount", products.size());

        Object forwardedMessage = req.getAttribute("msg");
        if (forwardedMessage == null) {
            Object flash = session.getAttribute("cartMessage");
            if (flash != null) {
                req.setAttribute("msg", flash.toString());
                Object flashType = session.getAttribute("cartMessageType");
                req.setAttribute("msgType", flashType == null ? "info" : flashType.toString());
                session.removeAttribute("cartMessage");
                session.removeAttribute("cartMessageType");
            }
        }

        req.getRequestDispatcher("index.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        // The catalog is read-only. Keep search and category selection on GET.
        resp.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
    }

    private String trimToNull(String value) {
        if (value == null || value.trim().isEmpty()) return null;
        return value.trim();
    }
}
