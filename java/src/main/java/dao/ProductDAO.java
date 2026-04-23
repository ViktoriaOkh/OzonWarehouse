package dao;

import model.Product;
import util.DBConnection;
import java.sql.*;
import java.util.*;

public class ProductDAO {

    public List<Product> getAllProducts() {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT КодТовара, Артикул, Наименование, Категория, Поставщик FROM Товары";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                Product product = new Product(
                    rs.getInt("КодТовара"),
                    rs.getString("Артикул"),
                    rs.getString("Наименование"),
                    rs.getString("Категория"),
                    rs.getString("Поставщик")
                );
                products.add(product);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return products;
    }

    public boolean addProduct(Product product) {
        String sql = "INSERT INTO Товары (Артикул, Наименование, Категория, Поставщик) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, product.getArticle());
            pstmt.setString(2, product.getName());
            pstmt.setString(3, product.getCategory());
            pstmt.setString(4, product.getSupplier());
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateCategory(int productId, String newCategory) {
        String sql = "UPDATE Товары SET Категория = ? WHERE КодТовара = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, newCategory);
            pstmt.setInt(2, productId);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteProduct(int productId) {
        try (Connection conn = DBConnection.getConnection()) {
            String deleteOps = "DELETE FROM Операции WHERE КодТовара = ?";
            try (PreparedStatement pstmt1 = conn.prepareStatement(deleteOps)) {
                pstmt1.setInt(1, productId);
                pstmt1.executeUpdate();
            }
            String deleteProd = "DELETE FROM Товары WHERE КодТовара = ?";
            try (PreparedStatement pstmt2 = conn.prepareStatement(deleteProd)) {
                pstmt2.setInt(1, productId);
                return pstmt2.executeUpdate() > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // НОВЫЙ МЕТОД для поиска товара по артикулу
    public Product findByArticle(String article) {
        String sql = "SELECT КодТовара, Артикул, Наименование, Категория, Поставщик FROM Товары WHERE Артикул = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, article);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Product product = new Product(
                    rs.getInt("КодТовара"),
                    rs.getString("Артикул"),
                    rs.getString("Наименование"),
                    rs.getString("Категория"),
                    rs.getString("Поставщик")
                );
                return product;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
}