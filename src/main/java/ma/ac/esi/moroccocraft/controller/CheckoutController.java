package ma.ac.esi.moroccocraft.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import ma.ac.esi.moroccocraft.model.Product;
import ma.ac.esi.moroccocraft.model.User;
import ma.ac.esi.moroccocraft.service.OrderService;
import ma.ac.esi.moroccocraft.util.SessionUtil;

import java.io.IOException;
import java.util.List;

@WebServlet("/CheckoutController")
public class CheckoutController extends HttpServlet {

    private final OrderService orderService = new OrderService();

   
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (!SessionUtil.isAuthenticated(req, resp)) return;

        User user = SessionUtil.getConnectedUser(req);

        
        if (!user.isBuyer()) {
            resp.sendRedirect(req.getContextPath() + "/ProductController");
            return;
        }

       
        List<Product> cart = getCartFromSession(req);

        
        if (cart == null || cart.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/CartController");
            return;
        }

        
        double total = cart.stream().mapToDouble(Product::getPrice).sum();

        
        req.setAttribute("cart",  cart);
        req.setAttribute("total", total);

        req.getRequestDispatcher("/WEB-INF/views/checkout.jsp").forward(req, resp);
    }

   
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (!SessionUtil.isAuthenticated(req, resp)) return;
        req.setCharacterEncoding("UTF-8");

        User user = SessionUtil.getConnectedUser(req);
        if (!user.isBuyer()) {
            resp.sendRedirect(req.getContextPath() + "/ProductController");
            return;
        }

        String phone   = req.getParameter("phone");
        String address = req.getParameter("address");
        String city    = req.getParameter("city");

        List<Product> cart = getCartFromSession(req);

        String error = orderService.placeOrder(
            user.getId(), user.getName(), phone, address, city, cart
        );

        if (error == null) {
           
            req.getSession().removeAttribute("cart");
            req.getSession().setAttribute("flash",
                "✅ Commande passée avec succès ! L'artisan va vous contacter prochainement.");
            resp.sendRedirect(req.getContextPath() + "/OrderController?view=mes-commandes");
        } else {
           
            double total = cart != null ? cart.stream().mapToDouble(Product::getPrice).sum() : 0;
            req.setAttribute("cart",  cart);
            req.setAttribute("total", total);
            req.setAttribute("error", error);
            req.getRequestDispatcher("/WEB-INF/views/checkout.jsp").forward(req, resp);
        }
    }

    @SuppressWarnings("unchecked")
    private List<Product> getCartFromSession(HttpServletRequest req) {
        return (List<Product>) req.getSession().getAttribute("cart");
    }
}
