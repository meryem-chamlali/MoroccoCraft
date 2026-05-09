package ma.ac.esi.moroccocraft.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import ma.ac.esi.moroccocraft.model.User;
import ma.ac.esi.moroccocraft.service.ProductService;
import ma.ac.esi.moroccocraft.util.SessionUtil;

import java.io.IOException;

@WebServlet("/SubmitProductController")
public class SubmitProductController extends HttpServlet {

    private final ProductService productService = new ProductService();

    
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
       
        if (!SessionUtil.isArtisan(req, resp)) return;
        req.getRequestDispatcher("/WEB-INF/views/submitProduct.jsp").forward(req, resp);
    }

   
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (!SessionUtil.isArtisan(req, resp)) return;

        req.setCharacterEncoding("UTF-8");
        User artisan = SessionUtil.getConnectedUser(req);

        String title       = req.getParameter("title");
        String description = req.getParameter("description");
        String priceStr    = req.getParameter("price");
        String category    = req.getParameter("category");
        String imageUrl    = req.getParameter("imageUrl");

        String error = productService.submit(title, description, priceStr,
                                             category, imageUrl, artisan.getId());
        if (error == null) {
            req.setAttribute("message",
                "Produit soumis avec succès ! Il sera visible après validation par l'administrateur.");
        } else {
            req.setAttribute("error", error);
        }
        req.getRequestDispatcher("/WEB-INF/views/submitProduct.jsp").forward(req, resp);
    }
}
