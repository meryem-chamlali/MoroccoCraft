package ma.ac.esi.moroccocraft.repository;

import ma.ac.esi.moroccocraft.model.Product;
import ma.ac.esi.moroccocraft.util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ProductRepository {

    
    public boolean insert(Product product) {
        String sql = "INSERT INTO products (title, description, price, category, image_url, artisan_id, status) "
                   + "VALUES (?, ?, ?, ?, ?, ?, 'PENDING')";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, product.getTitle());
            stmt.setString(2, product.getDescription());
            stmt.setDouble(3, product.getPrice());
            stmt.setString(4, product.getCategory());
            stmt.setString(5, product.getImageUrl());
            stmt.setInt(6, product.getArtisanId());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

   
    public List<Product> findApproved(String category) {
        StringBuilder sql = new StringBuilder(
            "SELECT p.id, p.title, p.description, p.price, p.category, "
          + "p.image_url, p.artisan_id, p.status, "
          + "u.name AS artisan_name, u.city AS artisan_city "
          + "FROM products p JOIN users u ON p.artisan_id = u.id "
          + "WHERE p.status = 'APPROVED' AND u.status = 'ACTIVE'"
        );
        if (category != null && !category.isEmpty()) sql.append(" AND p.category = ?");
        sql.append(" ORDER BY p.id DESC");

        List<Product> list = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {
            if (category != null && !category.isEmpty()) stmt.setString(1, category);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    
    public Product findById(int id) {
        String sql = "SELECT p.id, p.title, p.description, p.price, p.category, "
                   + "p.image_url, p.artisan_id, p.status, "
                   + "u.name AS artisan_name, u.city AS artisan_city "
                   + "FROM products p JOIN users u ON p.artisan_id = u.id WHERE p.id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) return mapRow(rs);
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    
    public List<Product> findByArtisan(int artisanId) {
        String sql = "SELECT p.id, p.title, p.description, p.price, p.category, "
                   + "p.image_url, p.artisan_id, p.status, "
                   + "u.name AS artisan_name, u.city AS artisan_city "
                   + "FROM products p JOIN users u ON p.artisan_id = u.id "
                   + "WHERE p.artisan_id = ? ORDER BY p.id DESC";
        List<Product> list = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, artisanId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    
    public List<Product> findPending() {
        String sql = "SELECT p.id, p.title, p.description, p.price, p.category, "
                   + "p.image_url, p.artisan_id, p.status, "
                   + "u.name AS artisan_name, u.city AS artisan_city "
                   + "FROM products p JOIN users u ON p.artisan_id = u.id "
                   + "WHERE p.status = 'PENDING' ORDER BY p.id DESC";
        List<Product> list = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    
    public List<Product> findAll() {
        String sql = "SELECT p.id, p.title, p.description, p.price, p.category, "
                   + "p.image_url, p.artisan_id, p.status, "
                   + "u.name AS artisan_name, u.city AS artisan_city "
                   + "FROM products p JOIN users u ON p.artisan_id = u.id "
                   + "ORDER BY p.id DESC";
        List<Product> list = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

  
    public boolean update(Product product) {
        String sql = "UPDATE products SET title = ?, description = ?, price = ?, "
                   + "category = ?, image_url = ? WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, product.getTitle());
            stmt.setString(2, product.getDescription());
            stmt.setDouble(3, product.getPrice());
            stmt.setString(4, product.getCategory());
            stmt.setString(5, product.getImageUrl());
            stmt.setInt(6, product.getId());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

   
    public boolean updateStatus(int productId, String newStatus) {
        String sql = "UPDATE products SET status = ? WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, newStatus);
            stmt.setInt(2, productId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    
    public boolean delete(int productId) {
        String sql = "DELETE FROM products WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, productId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    
    private Product mapRow(ResultSet rs) throws SQLException {
        Product p = new Product();
        p.setId(rs.getInt("id"));
        p.setTitle(rs.getString("title"));
        p.setDescription(rs.getString("description"));
        p.setPrice(rs.getDouble("price"));
        p.setCategory(rs.getString("category"));
        p.setImageUrl(rs.getString("image_url"));
        p.setArtisanId(rs.getInt("artisan_id"));
        p.setStatus(rs.getString("status"));
        p.setArtisanName(rs.getString("artisan_name"));
        p.setArtisanCity(rs.getString("artisan_city"));
        return p;
    }
}