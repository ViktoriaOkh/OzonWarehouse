package dao;

import model.Product;
import model.ProductDetail;
import util.DBConnection;
import java.sql.*;
import java.util.*;

public class ProductDetailDAO {

    // Получить все товары в грузе
	public List<Product> getProductsByCargoId(int cargoId) {
	    List<Product> products = new ArrayList<>();
	    String sql = "SELECT DISTINCT t.КодТовара, t.Артикул, t.Наименование, t.Категория, t.Поставщик " +
	                 "FROM Сканирования s " +
	                 "JOIN Товары t ON s.КодТовара = t.КодТовара " +
	                 "WHERE s.КодГруза = ?";
	    try (Connection conn = DBConnection.getConnection();
	         PreparedStatement ps = conn.prepareStatement(sql)) {
	        ps.setInt(1, cargoId);
	        ResultSet rs = ps.executeQuery();
	        System.out.println("SQL выполнен для cargoId=" + cargoId);
	        while (rs.next()) {
	            Product p = new Product(
	                rs.getInt("КодТовара"),
	                rs.getString("Артикул"),
	                rs.getString("Наименование"),
	                rs.getString("Категория"),
	                rs.getString("Поставщик")
	            );
	            products.add(p);
	            System.out.println("Найден товар: " + p.getName() + " (ID=" + p.getId() + ")");
	        }
	    } catch (SQLException e) {
	        System.out.println("Ошибка SQL: " + e.getMessage());
	        e.printStackTrace();
	    }
	    System.out.println("Всего найдено товаров: " + products.size());
	    return products;
	}

    // Получить детали товара (характеристики, фото, комментарии)
    public ProductDetail getProductDetail(int productId) {
        ProductDetail detail = new ProductDetail();
        
        // 1. Получаем товар
        ProductDAO productDAO = new ProductDAO();
        Product product = productDAO.findByArticle(String.valueOf(productId));
        if (product == null) {
            product = getProductById(productId);
        }
        if (product == null) return null;
        detail.setProduct(product);
        
        // 2. Характеристики
        Map<String, String> chars = new HashMap<>();
        String sqlChars = "SELECT Название, Значение FROM Характеристики WHERE КодТовара = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sqlChars)) {
            ps.setInt(1, productId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                chars.put(rs.getString("Название"), rs.getString("Значение"));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        detail.setCharacteristics(chars);
        
        // 3. Фото
        List<String> photos = new ArrayList<>();
        String sqlPhotos = "SELECT URL FROM ФотоТовара WHERE КодТовара = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sqlPhotos)) {
            ps.setInt(1, productId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                photos.add(rs.getString("URL"));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        detail.setPhotos(photos);
        
        // 4. Комментарии
        List<String> comments = new ArrayList<>();
        String sqlComments = "SELECT Текст FROM Комментарии WHERE КодТовара = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sqlComments)) {
            ps.setInt(1, productId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                comments.add(rs.getString("Текст"));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        detail.setComments(comments);
        
        return detail;
    }
    
    private Product getProductById(int productId) {
        String sql = "SELECT КодТовара, Артикул, Наименование, Категория, Поставщик FROM Товары WHERE КодТовара = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, productId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new Product(
                    rs.getInt("КодТовара"),
                    rs.getString("Артикул"),
                    rs.getString("Наименование"),
                    rs.getString("Категория"),
                    rs.getString("Поставщик")
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
}