package ma.ac.esi.moroccocraft.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import ma.ac.esi.moroccocraft.repository.UserRepository;
import ma.ac.esi.moroccocraft.service.ProductService;
import ma.ac.esi.moroccocraft.util.SessionUtil;

import java.io.IOException;

@WebServlet("/AdminController")
public class AdminController extends HttpServlet {

    private final ProductService productService = new ProductService();
    private final UserRepository userRepo       = new UserRepository();

    
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (!SessionUtil.isAdmin(req, resp)) return;

        req.setAttribute("pendingProducts", productService.getPendingProducts());
        req.setAttribute("pendingArtisans", userRepo.findPendingArtisans());
        req.getRequestDispatcher("/WEB-INF/views/adminPanel.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (!SessionUtil.isAdmin(req, resp)) return;

        String actionType = req.getParameter("actionType");
        String action     = req.getParameter("action");
        int    id;

        try {
            id = Integer.parseInt(req.getParameter("id"));
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/AdminController");
            return;
        }

        if ("product".equals(actionType)) {
            productService.updateStatus(id, action);
        } else if ("artisan".equals(actionType)) {
            String newStatus = "activate".equals(action) ? "ACTIVE" : "BANNED";
            userRepo.updateStatus(id, newStatus);
        }

        resp.sendRedirect(req.getContextPath() + "/AdminController");
    }
}
