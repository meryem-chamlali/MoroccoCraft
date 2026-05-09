package ma.ac.esi.moroccocraft.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import ma.ac.esi.moroccocraft.model.User;
import ma.ac.esi.moroccocraft.service.OrderService;
import ma.ac.esi.moroccocraft.util.SessionUtil;

import java.io.IOException;

@WebServlet("/OrderController")
public class OrderController extends HttpServlet {

    private final OrderService orderService = new OrderService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (!SessionUtil.isAuthenticated(req, resp)) return;
        User user = SessionUtil.getConnectedUser(req);

        if (user.isBuyer()) {
           
            req.setAttribute("orders", orderService.getBuyerOrders(user.getId()));
            req.getRequestDispatcher("/WEB-INF/views/myOrders.jsp").forward(req, resp);

        } else if (user.isArtisan()) {
           
            req.setAttribute("orders", orderService.getArtisanOrders(user.getId()));
            req.getRequestDispatcher("/WEB-INF/views/artisanOrders.jsp").forward(req, resp);

        } else if (user.isAdmin()) {
          
            req.setAttribute("orders", orderService.getAllOrders());
            req.getRequestDispatcher("/WEB-INF/views/artisanOrders.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (!SessionUtil.isAuthenticated(req, resp)) return;
        req.setCharacterEncoding("UTF-8");
        User user = SessionUtil.getConnectedUser(req);

        String action = req.getParameter("action");
        int orderId;
        try {
            orderId = Integer.parseInt(req.getParameter("id"));
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/OrderController");
            return;
        }

        if ("confirm".equals(action) && (user.isArtisan() || user.isAdmin())) {
           
            String deliveryDate = req.getParameter("deliveryDate");
            String note         = req.getParameter("note");
            String error = orderService.confirmOrder(orderId, deliveryDate, note);
            if (error != null) {
                req.getSession().setAttribute("flash_error", error);
            } else {
                req.getSession().setAttribute("flash", "✅ Commande confirmée ! Le client peut voir votre message.");
            }

        } else if ("status".equals(action)) {
           
            String newStatus = req.getParameter("status");
            orderService.updateStatus(orderId, newStatus);
            req.getSession().setAttribute("flash", "✅ Statut mis à jour.");
        }

        resp.sendRedirect(req.getContextPath() + "/OrderController");
    }
}