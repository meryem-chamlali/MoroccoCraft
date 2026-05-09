package ma.ac.esi.moroccocraft.service;

import ma.ac.esi.moroccocraft.model.Order;
import ma.ac.esi.moroccocraft.model.Product;
import ma.ac.esi.moroccocraft.repository.OrderRepository;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

public class OrderService {

    private final OrderRepository orderRepo = new OrderRepository();

    public String placeOrder(int buyerId, String buyerName,
                             String phone, String address, String city,
                             List<Product> cart) {

        if (phone == null || phone.trim().isEmpty())   return "Le téléphone est obligatoire.";
        if (address == null || address.trim().isEmpty()) return "L'adresse est obligatoire.";
        if (city == null || city.trim().isEmpty())     return "La ville est obligatoire.";
        if (cart == null || cart.isEmpty())            return "Votre panier est vide.";

       
        for (Product p : cart) {
            Order order = new Order();
            order.setBuyerId(buyerId);
            order.setProductId(p.getId());
            order.setBuyerName(buyerName);
            order.setBuyerPhone(phone.trim());
            order.setBuyerAddress(address.trim());
            order.setBuyerCity(city.trim());
            order.setQuantity(1);
            order.setTotalPrice(p.getPrice());

            int id = orderRepo.insert(order);
            if (id == -1) return "Erreur lors de la création de la commande pour : " + p.getTitle();
        }
        return null; 
    }

   
    public List<Order> getBuyerOrders(int buyerId) {
        return orderRepo.findByBuyer(buyerId);
    }

    
    public List<Order> getArtisanOrders(int artisanId) {
        return orderRepo.findByArtisan(artisanId);
    }

   
    public List<Order> getAllOrders() {
        return orderRepo.findAll();
    }

    public String confirmOrder(int orderId, String deliveryDateStr, String note) {
        if (deliveryDateStr == null || deliveryDateStr.trim().isEmpty())
            return "La date de livraison est obligatoire.";
        try {
            Date date = new SimpleDateFormat("yyyy-MM-dd").parse(deliveryDateStr);
            if (date.before(new Date())) return "La date doit être dans le futur.";
            orderRepo.confirmOrder(orderId, date, note);
            return null;
        } catch (ParseException e) {
            return "Format de date invalide (attendu : aaaa-mm-jj).";
        }
    }

    public boolean updateStatus(int orderId, String status) {
        return orderRepo.updateStatus(orderId, status);
    }
}
