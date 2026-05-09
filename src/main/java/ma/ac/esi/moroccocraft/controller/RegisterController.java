package ma.ac.esi.moroccocraft.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import ma.ac.esi.moroccocraft.service.UserService;

import java.io.IOException;

@WebServlet("/RegisterController")
public class RegisterController extends HttpServlet {

    private final UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        String name     = req.getParameter("name");
        String email    = req.getParameter("email");
        String password = req.getParameter("password");
        String role     = req.getParameter("role");     
        String city     = req.getParameter("city");
        String bio      = req.getParameter("bio");

        String error = userService.register(name, email, password, role, city, bio);

        if (error == null) {
            
            String msg = "ARTISAN".equals(role)
                ? "Compte artisan créé ! En attente de validation par l'administrateur."
                : "Compte créé avec succès ! Vous pouvez maintenant vous connecter.";
            req.setAttribute("success", msg);
            req.getRequestDispatcher("/WEB-INF/views/index.jsp").forward(req, resp);
        } else {
            req.setAttribute("error", error);
            req.setAttribute("name",  name);
            req.setAttribute("email", email);
            req.setAttribute("role",  role);
            req.setAttribute("city",  city);
            req.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(req, resp);
        }
    }
}
