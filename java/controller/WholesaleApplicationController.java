package controller;

import dao.WholesaleApplicationDAO;
import entity.User;
import entity.WholesaleApplication;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import util.CsrfUtil;
import java.io.IOException;

@WebServlet("/wholesale")
public class WholesaleApplicationController extends HttpServlet {
    private final WholesaleApplicationDAO dao = new WholesaleApplicationDAO();
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession s=req.getSession(false); User u=s==null?null:(User)s.getAttribute("loginUser");
        if(u==null){ resp.sendRedirect(req.getContextPath()+"/users?mode=login"); return; }
        CsrfUtil.ensureToken(s); req.setAttribute("application", dao.getLatestByUserId(u.getId()));
        req.getRequestDispatcher("/wholesale.jsp").forward(req,resp);
    }
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8"); HttpSession s=req.getSession(false); User u=s==null?null:(User)s.getAttribute("loginUser");
        if(u==null){resp.sendRedirect(req.getContextPath()+"/users?mode=login");return;}
        if(!CsrfUtil.isValid(req,s)){resp.sendError(403,"Your form session expired. Refresh and try again.");return;}
        WholesaleApplication existing=dao.getLatestByUserId(u.getId());
        if(existing!=null && ("PENDING".equals(existing.getStatus())||"APPROVED".equals(existing.getStatus()))){s.setAttribute("wholesaleMsg","You already have an active wholesale application.");resp.sendRedirect(req.getContextPath()+"/wholesale");return;}
        WholesaleApplication a=new WholesaleApplication(); a.setUserId(u.getId()); a.setBusinessName(trim(req,"businessName",150)); a.setBusinessType(trim(req,"businessType",100)); a.setBusinessAddress(trim(req,"businessAddress",255)); a.setBusinessPhone(trim(req,"businessPhone",45)); a.setRegistrationNumber(trim(req,"registrationNumber",100));
        if(blank(a.getBusinessName())||blank(a.getBusinessType())||blank(a.getBusinessAddress())||blank(a.getBusinessPhone())){s.setAttribute("wholesaleMsg","Please complete all required business information.");resp.sendRedirect(req.getContextPath()+"/wholesale");return;}
        s.setAttribute("wholesaleMsg",dao.createApplication(a)?"Wholesale application submitted successfully. Please wait for admin review.":"Could not submit the application. Please try again.");
        resp.sendRedirect(req.getContextPath()+"/wholesale");
    }
    private static String trim(HttpServletRequest r,String n,int max){String v=r.getParameter(n);if(v==null)return null;v=v.trim();return v.length()>max?v.substring(0,max):v;}
    private static boolean blank(String s){return s==null||s.isBlank();}
}
