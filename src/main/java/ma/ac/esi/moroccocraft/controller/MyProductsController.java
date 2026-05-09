package ma.ac.esi.moroccocraft.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import ma.ac.esi.moroccocraft.model.User;
import ma.ac.esi.moroccocraft.service.ProductService;
import ma.ac.esi.moroccocraft.util.SessionUtil;

import java.io.IOException;


@WebServlet("/MyProductsController")
public class MyProductsController extends HttpServlet {

    private final ProductService productService = new ProductService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (!SessionUtil.isArtisan(req, resp)) return;

        User artisan = SessionUtil.getConnectedUser(req);
        req.setAttribute("myProducts", productService.getArtisanProducts(artisan.getId()));
        req.getRequestDispatcher("/WEB-INF/views/myProducts.jsp").forward(req, resp);
    }
}
