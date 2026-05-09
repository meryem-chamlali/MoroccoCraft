package ma.ac.esi.moroccocraft.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import ma.ac.esi.moroccocraft.model.Product;
import ma.ac.esi.moroccocraft.model.User;
import ma.ac.esi.moroccocraft.service.ProductService;
import ma.ac.esi.moroccocraft.util.SessionUtil;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;


@WebServlet("/CartController")
public class CartController extends HttpServlet {

    private final ProductService productService = new ProductService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (!SessionUtil.isAuthenticated(req, resp)) return;

        
        User user = SessionUtil.getConnectedUser(req);
        if (!user.isBuyer()) {
            resp.sendRedirect(req.getContextPath() + "/ProductController");
            return;
        }

        List<Product> cart = getCart(req);
        req.setAttribute("cart", cart);
        req.setAttribute("total", calculateTotal(cart));
        req.getRequestDispatcher("/WEB-INF/views/cart.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (!SessionUtil.isAuthenticated(req, resp)) return;

        User user = SessionUtil.getConnectedUser(req);
        if (!user.isBuyer()) {
            resp.sendRedirect(req.getContextPath() + "/ProductController");
            return;
        }

        String action = req.getParameter("action");
        List<Product> cart = getCart(req);

        if ("add".equals(action)) {
            int id = Integer.parseInt(req.getParameter("id"));
            Product product = productService.getById(id);
            if (product != null) {
                cart.add(product);  
            }
        } else if ("remove".equals(action)) {
            int id = Integer.parseInt(req.getParameter("id"));
           
            cart.removeIf(p -> p.getId() == id);
        } else if ("clear".equals(action)) {
            cart.clear();
        }

       
        req.getSession().setAttribute("cart", cart);

      
        if ("add".equals(action)) {
            resp.sendRedirect(req.getContextPath() + "/ProductController");
        } else {
            resp.sendRedirect(req.getContextPath() + "/CartController");
        }
    }

   
    @SuppressWarnings("unchecked")
    private List<Product> getCart(HttpServletRequest req) {
        HttpSession session = req.getSession();
        List<Product> cart = (List<Product>) session.getAttribute("cart");
        if (cart == null) {
            cart = new ArrayList<>();
            session.setAttribute("cart", cart);
        }
        return cart;
    }

   
    private double calculateTotal(List<Product> cart) {
        double total = 0;
        for (Product p : cart) total += p.getPrice();
        return total;
    }
}
