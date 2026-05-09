package ma.ac.esi.moroccocraft.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import ma.ac.esi.moroccocraft.model.Product;
import ma.ac.esi.moroccocraft.model.User;
import ma.ac.esi.moroccocraft.service.ProductService;
import ma.ac.esi.moroccocraft.util.SessionUtil;

import java.io.IOException;

@WebServlet("/EditProductController")
public class EditProductController extends HttpServlet {

    private final ProductService productService = new ProductService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (!SessionUtil.isAuthenticated(req, resp)) return;

        int id;
        try { id = Integer.parseInt(req.getParameter("id")); }
        catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/ProductController");
            return;
        }

        Product product = productService.getById(id);
        if (product == null) {
            resp.sendRedirect(req.getContextPath() + "/ProductController");
            return;
        }

        
        User user = SessionUtil.getConnectedUser(req);
        if (!user.isAdmin() && product.getArtisanId() != user.getId()) {
            resp.sendRedirect(req.getContextPath() + "/WEB-INF/views/error403.html");
            return;
        }

        req.setAttribute("product", product);
        req.getRequestDispatcher("/WEB-INF/views/editProduct.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (!SessionUtil.isAuthenticated(req, resp)) return;
        req.setCharacterEncoding("UTF-8");

        int id;
        try { id = Integer.parseInt(req.getParameter("id")); }
        catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/ProductController");
            return;
        }

        
        Product existing = productService.getById(id);
        User user = SessionUtil.getConnectedUser(req);
        if (existing == null || (!user.isAdmin() && existing.getArtisanId() != user.getId())) {
            resp.sendRedirect(req.getContextPath() + "/WEB-INF/views/error403.html");
            return;
        }

        String title       = req.getParameter("title");
        String description = req.getParameter("description");
        String priceStr    = req.getParameter("price");
        String category    = req.getParameter("category");
        String imageUrl    = req.getParameter("imageUrl");

        String error = productService.update(id, title, description, priceStr, category, imageUrl);

        if (error == null) {
            resp.sendRedirect(req.getContextPath() + "/ProductController");
        } else {
            req.setAttribute("error", error);
            req.setAttribute("product", existing);
            req.getRequestDispatcher("/WEB-INF/views/editProduct.jsp").forward(req, resp);
        }
    }
}
