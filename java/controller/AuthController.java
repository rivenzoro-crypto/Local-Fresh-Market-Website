package controller;

import java.io.IOException;
import java.util.List;


import dao.CartDAO;
import dao.CartItemDAO;
import dao.UserDAO;
import entity.Cart;
import entity.CartItem;
import entity.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import util.MailUtil;

//Web system - Https protocol
// every action via request/response 
//- java methods in Controller ( req, resp)
// save credential data (login user) - session/cookies
// Types of Request - GetRequest ( get all data from Server )
// filling form with data and request ( Post Request)
				// existing data update - PUT request 
				// delete existing data - DELET request

@WebServlet("/users")
public class AuthController extends HttpServlet{
	//dependency injection
	private final UserDAO userDAO=new UserDAO();
	private final CartDAO cartDAO=new CartDAO();
	private final CartItemDAO cartItemDAO=new CartItemDAO();

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		
		String mode=req.getParameter("mode");
		if(mode==null)
			mode="";
		
		//mode=login -> show the login page
		//mode=register -> show the registration page
		switch (mode) {
		case "login":
			showLoginForm(req,resp);
			break;
			
		case "register":
			showRegistrationForm(req,resp);
			break;
			
		case "save":
			saveUser(req,resp);
			break;
			
		case "valid":
			validUser(req,resp);
			break;
			
		case "logout":
			logoutUser(req,resp);
			break;

		default:
			break;
		}
	
	}//end of doGEt

	private void logoutUser(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		HttpSession session=req.getSession(false);// false- get existing session obj
		if (session != null) {
			session.invalidate();
		}
		HttpSession freshSession = req.getSession(true);
		freshSession.setAttribute("cartMessage", "Session logged out successfully.");
		freshSession.setAttribute("cartMessageType", "success");
		resp.sendRedirect(req.getContextPath() + "/home");
		
	}

	private void validUser(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		// get data from login form
		String email=req.getParameter("email");
		String password=req.getParameter("password");
		
		User user=userDAO.getUserByEmail(email);
		if( user == null )
			{	
//				System.out.println("null object");
//				System.out.println(user);
//				System.out.println("No Email seciton, null object section");
				req.setAttribute("msg", "Invalid email or password, or the account is disabled.");
				req.getRequestDispatcher("login.jsp").forward(req, resp);
				return;
			}
		else {
				// match password
				// login data stored in session obj
				// session obj - sever side memory space
				// sesssion obj - anywhere can access
				// too much data in session - long server loding time
				// only store credential information
				
				if(Boolean.TRUE.equals(user.getEnabled()) && userDAO.verifyPassword(user, password))
				{
					HttpSession session=req.getSession(true);
                    // Rotate the session ID after authentication to reduce session-fixation risk.
                    req.changeSessionId();
                    // Never keep the password hash in the authenticated session object.
                    user.setPassword(null);
					
					// search cart for the login user
					Cart cart=cartDAO.getCartByUserId(user.getId());
					//if cart null=> new cart create
					if(cart==null)
						{
							cart=new Cart();
							cart.setUser(user);
							cartDAO.createCart(cart);// save into db table
						}
					
					session.setAttribute("loginUser", user);
					//next time
					cart=cartDAO.getCartByUserId(user.getId());
					session.setAttribute("cart", cart);
					List<CartItem> itemList=cartItemDAO.getAllCartItemsByCartId(cart.getId());
					int itemCount=0;
					if(itemList.size()>0) {
						for (CartItem cartItem : itemList) {
							itemCount+=cartItem.getQty();
						}
					}
					session.setAttribute("itemCount", itemCount);
					// Load the catalog through HomeController so filters and CSRF tokens are initialized.
					resp.sendRedirect(req.getContextPath() + "/home");
				}
				else {
					req.setAttribute("msg", "Invalid email or password, or the account is disabled.");// jsp -> ${msg}
					req.getRequestDispatcher("login.jsp").forward(req, resp);
				}
		}
		
	}

	private void saveUser(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		// get all data from registration form
		String name=req.getParameter("name");
		String email=req.getParameter("email");
		String pwd=req.getParameter("password");
		String phone=req.getParameter("phone");
		
		User user=new User();
		user.setName(name);
		user.setEmail(email);
		user.setPassword(pwd);
		user.setPhone(phone);
		user.setRole("USER");
		user.setEnabled(true);
		
		// save to db table
		Boolean status=userDAO.createUser(user);
		// registration success -> go to login page
		if(status)
			{
				// email to user (tmr)
				MailUtil.sendMail(email, "Registration Success");
				req.setAttribute("msg", "Register User Account Successfully");
				req.getRequestDispatcher("login.jsp").forward(req, resp);
			}
		else
			{
				req.setAttribute("msg", "Fail in User Registration");
				req.getRequestDispatcher("register.jsp").forward(req, resp);
			}
		// registration fail -> go back to registration page
		
	}

	private void showRegistrationForm(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		req.getRequestDispatcher("register.jsp").forward(req, resp);		
	}

	private void showLoginForm(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		HttpSession session = req.getSession(false);
		if (session != null && req.getAttribute("msg") == null) {
			Object flash = session.getAttribute("cartMessage");
			if (flash != null) {
				req.setAttribute("msg", flash.toString());
				Object flashType = session.getAttribute("cartMessageType");
				req.setAttribute("msgType", flashType == null ? "info" : flashType.toString());
				session.removeAttribute("cartMessage");
				session.removeAttribute("cartMessageType");
			}
		}
		req.getRequestDispatcher("login.jsp").forward(req, resp);
	}

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		doGet(req, resp);
	}
	

}
