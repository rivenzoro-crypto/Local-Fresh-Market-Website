package controller;

import dao.ProductDAO;
import dao.WholesalePricingDAO;
import entity.Product;
import entity.User;
import entity.WholesalePricing;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import util.CsrfUtil;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin-wholesale-pricing")
public class AdminWholesalePricingController extends HttpServlet {
    private final WholesalePricingDAO pricingDAO = new WholesalePricingDAO();
    private final ProductDAO productDAO = new ProductDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if (!isAdmin(req)) { resp.sendError(HttpServletResponse.SC_FORBIDDEN); return; }
        HttpSession session = req.getSession();
        CsrfUtil.ensureToken(session);
        List<Product> products = productDAO.getAllActiveProducts();
        req.setAttribute("products", products);
        req.setAttribute("pricingTiers", pricingDAO.getAll());
        req.setAttribute("currentPage", "wholesale-pricing");
        Object msg = session.getAttribute("wholesalePricingMsg");
        if (msg != null) { req.setAttribute("msg", msg); session.removeAttribute("wholesalePricingMsg"); }
        req.getRequestDispatcher("/admin/admin-wholesale-pricing.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession(false);
        if (!isAdmin(req) || session == null || !CsrfUtil.isValid(req, session)) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Invalid or expired form token."); return;
        }
        String action = req.getParameter("action");
        boolean ok = false;
        String message;
        try {
            if ("create".equals(action)) {
                WholesalePricing p = readCreate(req);
                ok = pricingDAO.create(p);
                message = ok ? "Wholesale pricing tier created." : "Could not create tier. A tier with the same product and MOQ may already exist.";
            } else if ("update".equals(action)) {
                WholesalePricing p = readUpdate(req);
                ok = pricingDAO.update(p);
                message = ok ? "Wholesale pricing tier updated." : "Could not update pricing tier.";
            } else if ("delete".equals(action)) {
                long id = positiveLong(req.getParameter("id"));
                ok = pricingDAO.delete(id);
                message = ok ? "Wholesale pricing tier removed." : "Could not remove pricing tier.";
            } else {
                message = "Unsupported wholesale pricing action.";
            }
        } catch (IllegalArgumentException e) {
            message = e.getMessage();
        }
        session.setAttribute("wholesalePricingMsg", message);
        resp.sendRedirect(req.getContextPath() + "/admin-wholesale-pricing");
    }

    private WholesalePricing readCreate(HttpServletRequest req) {
        long productId = positiveLong(req.getParameter("productId"));
        if (productDAO.getActiveProductById(productId) == null) throw new IllegalArgumentException("Please choose a valid active product.");
        WholesalePricing p = new WholesalePricing();
        p.setProductId(productId);
        p.setMinQuantity(positiveInt(req.getParameter("minQuantity"), "MOQ must be at least 1."));
        p.setWholesalePrice(positivePrice(req.getParameter("wholesalePrice")));
        p.setActive(true);
        return p;
    }

    private WholesalePricing readUpdate(HttpServletRequest req) {
        WholesalePricing p = new WholesalePricing();
        p.setId(positiveLong(req.getParameter("id")));
        p.setMinQuantity(positiveInt(req.getParameter("minQuantity"), "MOQ must be at least 1."));
        p.setWholesalePrice(positivePrice(req.getParameter("wholesalePrice")));
        p.setActive("true".equalsIgnoreCase(req.getParameter("active")));
        return p;
    }

    private long positiveLong(String value) {
        try { long n = Long.parseLong(value); if (n <= 0) throw new NumberFormatException(); return n; }
        catch (Exception e) { throw new IllegalArgumentException("Invalid wholesale pricing record."); }
    }
    private int positiveInt(String value, String message) {
        try { int n = Integer.parseInt(value); if (n < 1) throw new NumberFormatException(); return n; }
        catch (Exception e) { throw new IllegalArgumentException(message); }
    }
    private double positivePrice(String value) {
        try { double n = Double.parseDouble(value); if (!Double.isFinite(n) || n <= 0) throw new NumberFormatException(); return n; }
        catch (Exception e) { throw new IllegalArgumentException("Wholesale price must be greater than zero."); }
    }
    private boolean isAdmin(HttpServletRequest req) {
        HttpSession s = req.getSession(false);
        if (s == null) return false;
        Object o = s.getAttribute("loginUser");
        return o instanceof User && "admin".equalsIgnoreCase(((User)o).getRole());
    }
}
