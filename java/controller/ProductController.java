package controller;

import java.io.IOException;

import dao.CategoryDAO;
import dao.ProductDAO;
import entity.Product;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import util.CsrfUtil;

@WebServlet("/products")
public class ProductController extends HttpServlet {
    private final ProductDAO productDAO = new ProductDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String mode = req.getParameter("mode");
        if (mode == null || "view".equals(mode)) {
            showProduct(req, resp);
            return;
        }
        resp.sendError(HttpServletResponse.SC_NOT_FOUND);
    }

    private void showProduct(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        long productId;
        try {
            productId = Long.parseLong(req.getParameter("id"));
            if (productId <= 0) throw new NumberFormatException("Product ID must be positive");
        } catch (NumberFormatException ex) {
            resp.sendRedirect(req.getContextPath() + "/home");
            return;
        }

        Product product = productDAO.getActiveProductById(productId);
        if (product == null) {
            req.setAttribute("msg", "This product is unavailable or no longer exists.");
            req.setAttribute("categories", categoryDAO.getActiveCategories());
            req.getRequestDispatcher("product-not-found.jsp").forward(req, resp);
            return;
        }

        HttpSession session = req.getSession(true);
        CsrfUtil.ensureToken(session);
        req.setAttribute("product", product);
        req.setAttribute("categories", categoryDAO.getActiveCategories());
        Object flash = session.getAttribute("cartMessage");
        if (flash != null) {
            req.setAttribute("msg", flash.toString());
            Object flashType = session.getAttribute("cartMessageType");
            req.setAttribute("msgType", flashType == null ? "info" : flashType.toString());
            session.removeAttribute("cartMessage");
            session.removeAttribute("cartMessageType");
        }
        req.getRequestDispatcher("product-detail.jsp").forward(req, resp);
    }
}
