package ma.ac.esi.moroccocraft.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import ma.ac.esi.moroccocraft.model.Product;
import ma.ac.esi.moroccocraft.model.User;
import ma.ac.esi.moroccocraft.service.ProductService;
import ma.ac.esi.moroccocraft.util.SessionUtil;

import java.io.IOException;

@WebServlet("/DeleteProductController")
public class DeleteProductController extends HttpServlet {

    private final ProductService productService = new ProductService();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (!SessionUtil.isAuthenticated(req, resp)) return;

        int id;
        try { id = Integer.parseInt(req.getParameter("id")); }
        catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/ProductController");
            return;
        }

        Product product = productService.getById(id);
        User user = SessionUtil.getConnectedUser(req);

       
        if (product == null || (!user.isAdmin() && product.getArtisanId() != user.getId())) {
            resp.sendRedirect(req.getContextPath() + "/WEB-INF/views/error403.html");
            return;
        }

        productService.delete(id);

      
        String from = req.getParameter("from");
        if ("admin".equals(from) || user.isAdmin()) {
            resp.sendRedirect(req.getContextPath() + "/AdminController");
        } else if ("mes-produits".equals(from)) {
            resp.sendRedirect(req.getContextPath() + "/MyProductsController");
        } else {
            resp.sendRedirect(req.getContextPath() + "/ProductController");
        }
    }
}