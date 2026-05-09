package ma.ac.esi.moroccocraft.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import ma.ac.esi.moroccocraft.model.User;
import ma.ac.esi.moroccocraft.service.UserService;

import java.io.IOException;

@WebServlet("/LoginController")
public class LoginController extends HttpServlet {

    private final UserService userService = new UserService();

    
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
   
        HttpSession session = req.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            resp.sendRedirect(req.getContextPath() + "/ProductController");
            return;
        }
        req.getRequestDispatcher("/WEB-INF/views/index.jsp").forward(req, resp);
    }

    
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        String email    = req.getParameter("email");
        String password = req.getParameter("password");

        User user = userService.authenticate(email, password);

        if (user != null) {
           
            HttpSession session = req.getSession();
            session.setAttribute("user", user);
            session.setMaxInactiveInterval(30 * 60); 

            
            if (user.isAdmin()) {
                resp.sendRedirect(req.getContextPath() + "/AdminController");
            } else {
                resp.sendRedirect(req.getContextPath() + "/ProductController");
            }
        } else {
            req.setAttribute("error", "Email ou mot de passe incorrect, ou compte non activé.");
            req.getRequestDispatcher("/WEB-INF/views/index.jsp").forward(req, resp);
        }
    }
}
