package ma.ac.esi.moroccocraft.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import ma.ac.esi.moroccocraft.model.User;
import ma.ac.esi.moroccocraft.service.ProductService;
import ma.ac.esi.moroccocraft.util.SessionUtil;

import java.io.IOException;
import java.util.List;

@WebServlet("/ProductController")
public class ProductController extends HttpServlet {

    private final ProductService productService = new ProductService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        
        if (!SessionUtil.isAuthenticated(req, resp)) return;

        String category = req.getParameter("category"); 

        req.setAttribute("products", productService.getApprovedProducts(category));
        req.setAttribute("selectedCategory", category);
        req.getRequestDispatcher("/WEB-INF/views/products.jsp").forward(req, resp);
    }
}
