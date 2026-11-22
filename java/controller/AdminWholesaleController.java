package controller;

import dao.WholesaleApplicationDAO;
import entity.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import util.CsrfUtil;
import java.io.IOException;

@WebServlet("/admin-wholesale")
public class AdminWholesaleController extends HttpServlet {
    private final WholesaleApplicationDAO dao=new WholesaleApplicationDAO();
    protected void doGet(HttpServletRequest req,HttpServletResponse resp)throws ServletException,IOException{
        User u=user(req); if(!admin(u)){resp.sendRedirect(req.getContextPath()+"/users?mode=login");return;} HttpSession s=req.getSession(); CsrfUtil.ensureToken(s);
        String status=req.getParameter("status"); if(status==null||status.isBlank())status="ALL";
        req.setAttribute("applications",dao.getApplications(status)); req.setAttribute("selectedStatus",status.toUpperCase()); req.setAttribute("pendingCount",dao.countByStatus("PENDING")); req.setAttribute("approvedCount",dao.countByStatus("APPROVED")); req.setAttribute("rejectedCount",dao.countByStatus("REJECTED")); req.setAttribute("currentPage","wholesale");
        Object msg=s.getAttribute("wholesaleAdminMsg"); if(msg!=null){req.setAttribute("msg",msg);s.removeAttribute("wholesaleAdminMsg");}
        req.getRequestDispatcher("/admin/admin-wholesale.jsp").forward(req,resp);
    }
    protected void doPost(HttpServletRequest req,HttpServletResponse resp)throws IOException{
        HttpSession s=req.getSession(false); User u=user(req); if(!admin(u)){resp.sendError(403);return;} if(!CsrfUtil.isValid(req,s)){resp.sendError(403,"Your form session expired. Refresh and try again.");return;}
        boolean ok=false; try{Long id=Long.parseLong(req.getParameter("id"));String action=req.getParameter("action"); if("approve".equals(action))ok=dao.approve(id,u.getId()); else if("reject".equals(action))ok=dao.reject(id,u.getId(),req.getParameter("reason")); s.setAttribute("wholesaleAdminMsg",ok?"Application updated successfully.":"Application could not be updated. It may already have been reviewed.");}catch(Exception e){s.setAttribute("wholesaleAdminMsg","Invalid application request.");}
        resp.sendRedirect(req.getContextPath()+"/admin-wholesale");
    }
    private User user(HttpServletRequest r){HttpSession s=r.getSession(false);return s==null?null:(User)s.getAttribute("loginUser");}
    private boolean admin(User u){return u!=null&&"admin".equalsIgnoreCase(u.getRole());}
}
