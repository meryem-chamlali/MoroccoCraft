package ma.ac.esi.moroccocraft.repository;

import ma.ac.esi.moroccocraft.model.User;
import ma.ac.esi.moroccocraft.util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserRepository {


    public boolean insert(User user) {
        String sql = "INSERT INTO users (name, email, password, role, bio, city, status) "
                   + "VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, user.getName());
            stmt.setString(2, user.getEmail());
            stmt.setString(3, user.getPassword());
            stmt.setString(4, user.getRole());
            stmt.setString(5, user.getBio());
            stmt.setString(6, user.getCity());
            stmt.setString(7, user.getStatus());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }


    public User findByEmail(String email) {
        String sql = "SELECT id, name, email, password, role, bio, city, status "
                   + "FROM users WHERE email = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, email);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) return mapRow(rs);
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }


    public User findById(int id) {
        String sql = "SELECT id, name, email, password, role, bio, city, status "
                   + "FROM users WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) return mapRow(rs);
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }


    public List<User> findAll() {
        String sql = "SELECT id, name, email, password, role, bio, city, status "
                   + "FROM users ORDER BY id DESC";
        return queryList(sql);
    }

   
    public List<User> findPendingArtisans() {
        String sql = "SELECT id, name, email, password, role, bio, city, status "
                   + "FROM users WHERE role = 'ARTISAN' AND status = 'PENDING' "
                   + "ORDER BY id DESC";
        return queryList(sql);
    }

    
    public boolean emailExists(String email) {
        String sql = "SELECT COUNT(*) FROM users WHERE email = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, email);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) return rs.getInt(1) > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

       public boolean update(User user) {
        String sql = "UPDATE users SET name = ?, bio = ?, city = ? WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, user.getName());
            stmt.setString(2, user.getBio());
            stmt.setString(3, user.getCity());
            stmt.setInt(4, user.getId());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

  
    public boolean updatePassword(int userId, String newPassword) {
        String sql = "UPDATE users SET password = ? WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, newPassword);
            stmt.setInt(2, userId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

   
    public boolean updateStatus(int userId, String newStatus) {
        String sql = "UPDATE users SET status = ? WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, newStatus);
            stmt.setInt(2, userId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    
    public boolean delete(int userId) {
        String sql = "DELETE FROM users WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

   

    private User mapRow(ResultSet rs) throws SQLException {
        User u = new User();
        u.setId(rs.getInt("id"));
        u.setName(rs.getString("name"));
        u.setEmail(rs.getString("email"));
        u.setPassword(rs.getString("password"));
        u.setRole(rs.getString("role"));
        u.setBio(rs.getString("bio"));
        u.setCity(rs.getString("city"));
        u.setStatus(rs.getString("status"));
        return u;
    }

    private List<User> queryList(String sql) {
        List<User> list = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }
}