package controller;

import java.io.IOException;
import java.util.List;

import dao.UserDAO;
import entity.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import util.CsrfUtil;

@WebServlet("/admin-users")
public class AdminUserController extends HttpServlet {
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String mode = req.getParameter("mode");
        if (mode == null) mode = "";

        switch (mode) {
            case "login" -> showAdminLoginForm(req, resp);
            case "check" -> showAdminLoginForm(req, resp);
            case "dash" -> resp.sendRedirect(req.getContextPath() + "/admin-dashboard");
            case "all" -> showAdminUserPage(req, resp);
            case "edit" -> showEditForm(req, resp);
            case "logout" -> logoutUser(req, resp);
            case "update" -> resp.sendRedirect(req.getContextPath() + "/admin-users?mode=all");
            default -> resp.sendRedirect(req.getContextPath() + "/admin-users?mode=all");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String mode = req.getParameter("mode");
        if ("check".equals(mode)) {
            HttpSession loginSession = req.getSession(false);
            if (loginSession == null || !CsrfUtil.isValid(req, loginSession)) {
                resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Your login form expired. Refresh and try again.");
                return;
            }
            validateAdmin(req, resp);
            return;
        }
        if (!"update".equals(mode)) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Unsupported account action.");
            return;
        }

        HttpSession session = req.getSession(false);
        if (session == null || !CsrfUtil.isValid(req, session)) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Your form session expired. Refresh and try again.");
            return;
        }

        try {
            long id = Long.parseLong(req.getParameter("id"));
            String enabledValue = req.getParameter("enable");
            if (id <= 0 || !("true".equals(enabledValue) || "false".equals(enabledValue))) {
                session.setAttribute("msg", "Please choose a valid account status.");
            } else {
                boolean updated = Boolean.parseBoolean(enabledValue)
                        ? userDAO.activateUser(id) : userDAO.deactivateUser(id);
                session.setAttribute("msg", updated ? "Account status updated successfully." : "Account status was not changed.");
            }
        } catch (NumberFormatException ex) {
            session.setAttribute("msg", "Invalid account ID.");
        }
        resp.sendRedirect(req.getContextPath() + "/admin-users?mode=all");
    }

    private void showAdminUserPage(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(true);
        CsrfUtil.ensureToken(session);
        List<User> users = userDAO.getAllUsers();
        req.setAttribute("users", users);
        req.setAttribute("currentPage", "customers");
        Object message = session.getAttribute("msg");
        if (message != null) {
            req.setAttribute("msg", message.toString());
            session.removeAttribute("msg");
        }
        req.getRequestDispatcher("admin/admin-users.jsp").forward(req, resp);
    }

    private void showEditForm(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            long id = Long.parseLong(req.getParameter("id"));
            User user = userDAO.getUserById(id);
            if (user == null) {
                resp.sendError(HttpServletResponse.SC_NOT_FOUND, "Account not found.");
                return;
            }
            HttpSession session = req.getSession(true);
            CsrfUtil.ensureToken(session);
            req.setAttribute("user", user);
            req.setAttribute("currentPage", "customers");
            req.getRequestDispatcher("admin/admin-user-edit.jsp").forward(req, resp);
        } catch (NumberFormatException ex) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid account ID.");
        }
    }

    private void validateAdmin(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String email = req.getParameter("email");
        String password = req.getParameter("password");
        User user = userDAO.getUserByEmail(email);
        if (user != null && user.getRole() != null
                && user.getRole().equalsIgnoreCase("ADMIN")
                && Boolean.TRUE.equals(user.getEnabled())
                && userDAO.verifyPassword(user, password)) {
            req.getSession(true);
            req.changeSessionId();
            user.setPassword(null);
            req.getSession(false).setAttribute("loginUser", user);
            resp.sendRedirect(req.getContextPath() + "/admin-dashboard");
            return;
        }
        req.setAttribute("msg", "Invalid email or password, or this account is not an active administrator.");
        req.getRequestDispatcher("admin/admin-login.jsp").forward(req, resp);
    }

    private void showAdminLoginForm(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        CsrfUtil.ensureToken(req.getSession(true));
        req.getRequestDispatcher("admin/admin-login.jsp").forward(req, resp);
    }

    private void logoutUser(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession(false);
        if (session != null) session.invalidate();
        resp.sendRedirect(req.getContextPath() + "/home");
    }
}
