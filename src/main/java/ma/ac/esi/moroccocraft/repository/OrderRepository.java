package ma.ac.esi.moroccocraft.repository;

import ma.ac.esi.moroccocraft.model.Order;
import ma.ac.esi.moroccocraft.util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OrderRepository {

  
    private static final String BASE_SQL =
        "SELECT o.id, o.buyer_id, o.product_id, o.buyer_name, o.buyer_phone, "
      + "       o.buyer_address, o.buyer_city, o.quantity, o.total_price, "
      + "       o.status, o.delivery_date, o.artisan_note, o.created_at, "
      + "       p.title    AS product_title, "
      + "       p.category AS product_category, "
      + "       u.name     AS artisan_name, "
      + "       u.id       AS artisan_id "
      + "FROM orders o "
      + "JOIN products p ON o.product_id = p.id "
      + "JOIN users    u ON p.artisan_id = u.id ";

    

    public int insert(Order order) {
       
        String sql =
            "INSERT INTO orders "
          + "(buyer_id, product_id, buyer_name, buyer_phone, "
          + " buyer_address, buyer_city, quantity, total_price, status) "
          + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, 'EN_ATTENTE') "
          + "RETURNING id";
          
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1,    order.getBuyerId());
            stmt.setInt(2,    order.getProductId());
            stmt.setString(3, order.getBuyerName());
            stmt.setString(4, order.getBuyerPhone());
            stmt.setString(5, order.getBuyerAddress());
            stmt.setString(6, order.getBuyerCity());
            stmt.setInt(7,    order.getQuantity());
            stmt.setDouble(8, order.getTotalPrice());

            
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) return rs.getInt(1);

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }

   

    public List<Order> findByBuyer(int buyerId) {
        return query(BASE_SQL + "WHERE o.buyer_id = ? ORDER BY o.id DESC",
                     stmt -> stmt.setInt(1, buyerId));
    }

    public List<Order> findByArtisan(int artisanId) {
        return query(BASE_SQL + "WHERE u.id = ? ORDER BY o.id DESC",
                     stmt -> stmt.setInt(1, artisanId));
    }

    public Order findById(int id) {
        List<Order> list = query(BASE_SQL + "WHERE o.id = ?",
                                 stmt -> stmt.setInt(1, id));
        return list.isEmpty() ? null : list.get(0);
    }

    public List<Order> findAll() {
        return query(BASE_SQL + "ORDER BY o.id DESC", stmt -> {});
    }

    
    public boolean confirmOrder(int orderId, java.util.Date deliveryDate, String note) {
        String sql =
            "UPDATE orders SET status = 'CONFIRMEE', "
          + "delivery_date = ?, artisan_note = ? "
          + "WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setDate(1, new java.sql.Date(deliveryDate.getTime()));
            stmt.setString(2, note);
            stmt.setInt(3, orderId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateStatus(int orderId, String newStatus) {
        String sql = "UPDATE orders SET status = ? WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, newStatus);
            stmt.setInt(2, orderId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    
    @FunctionalInterface
    interface ParamSetter {
        void set(PreparedStatement s) throws SQLException;
    }

    private List<Order> query(String sql, ParamSetter setter) {
        List<Order> list = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            setter.set(stmt);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    private Order mapRow(ResultSet rs) throws SQLException {
        Order o = new Order();
        o.setId(rs.getInt("id"));
        o.setBuyerId(rs.getInt("buyer_id"));
        o.setProductId(rs.getInt("product_id"));
        o.setBuyerName(rs.getString("buyer_name"));
        o.setBuyerPhone(rs.getString("buyer_phone"));
        o.setBuyerAddress(rs.getString("buyer_address"));
        o.setBuyerCity(rs.getString("buyer_city"));
        o.setQuantity(rs.getInt("quantity"));
        o.setTotalPrice(rs.getDouble("total_price"));
        o.setStatus(rs.getString("status"));
        o.setArtisanNote(rs.getString("artisan_note"));
        o.setProductTitle(rs.getString("product_title"));
        o.setProductCategory(rs.getString("product_category"));
        o.setArtisanName(rs.getString("artisan_name"));
        o.setArtisanId(rs.getInt("artisan_id"));

        if (rs.getDate("delivery_date") != null)
            o.setDeliveryDate(rs.getDate("delivery_date"));
        if (rs.getTimestamp("created_at") != null)
            o.setCreatedAt(rs.getTimestamp("created_at"));

        return o;
    }
}