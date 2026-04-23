package dao;

import model.Operation;
import java.sql.*;
import java.util.*;

public class OperationDAO {
    
    public List<Operation> getAllOperations() {
        List<Operation> operations = new ArrayList<>();
        
        String url = "jdbc:sqlite:C:/Users/Vikusya/Desktop/Склад_Ozon.db";
        String sql = "SELECT o.КодОперации, o.Дата, " +
                     "t.Артикул, t.Наименование, " +
                     "s.ФИО, tp.Название as ТипОперации, " +
                     "o.Количество, o.Причина " +
                     "FROM Операции o " +
                     "LEFT JOIN Товары t ON o.КодТовара = t.КодТовара " +
                     "LEFT JOIN Сотрудники s ON o.КодСотрудника = s.КодСотрудника " +
                     "LEFT JOIN ТипыОпераций tp ON o.КодТипа = tp.КодТипа " +
                     "ORDER BY o.Дата DESC";
        
        try {
            Class.forName("org.sqlite.JDBC");
            try (Connection conn = DriverManager.getConnection(url);
                 Statement stmt = conn.createStatement();
                 ResultSet rs = stmt.executeQuery(sql)) {
                
                while (rs.next()) {
                    Operation op = new Operation(
                        rs.getInt("КодОперации"),
                        rs.getDate("Дата"),
                        rs.getString("Артикул") != null ? rs.getString("Артикул") : "",
                        rs.getString("Наименование") != null ? rs.getString("Наименование") : "",
                        rs.getString("ФИО") != null ? rs.getString("ФИО") : "",
                        rs.getString("ТипОперации") != null ? rs.getString("ТипОперации") : "",
                        rs.getInt("Количество"),
                        rs.getString("Причина") != null ? rs.getString("Причина") : ""
                    );
                    operations.add(op);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return operations;
    }
    
    public Map<String, Integer> getStatisticsByType() {
        Map<String, Integer> stats = new LinkedHashMap<>();
        String url = "jdbc:sqlite:C:/Users/Vikusya/Desktop/Склад_Ozon.db";
        String sql = "SELECT tp.Название, COUNT(*) as Количество " +
                     "FROM Операции o " +
                     "LEFT JOIN ТипыОпераций tp ON o.КодТипа = tp.КодТипа " +
                     "GROUP BY tp.Название " +
                     "ORDER BY Количество DESC";
        
        try {
            Class.forName("org.sqlite.JDBC");
            try (Connection conn = DriverManager.getConnection(url);
                 Statement stmt = conn.createStatement();
                 ResultSet rs = stmt.executeQuery(sql)) {
                
                while (rs.next()) {
                    String name = rs.getString("Название");
                    if (name == null) name = "Неизвестный";
                    stats.put(name, rs.getInt("Количество"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return stats;
    }
    
    public List<Operation> getOperationsByDate(String date) {
        List<Operation> operations = new ArrayList<>();
        String url = "jdbc:sqlite:C:/Users/Vikusya/Desktop/Склад_Ozon.db";
        String sql = "SELECT o.КодОперации, o.Дата, " +
                     "t.Артикул, t.Наименование, " +
                     "s.ФИО, tp.Название as ТипОперации, " +
                     "o.Количество, o.Причина " +
                     "FROM Операции o " +
                     "LEFT JOIN Товары t ON o.КодТовара = t.КодТовара " +
                     "LEFT JOIN Сотрудники s ON o.КодСотрудника = s.КодСотрудника " +
                     "LEFT JOIN ТипыОпераций tp ON o.КодТипа = tp.КодТипа " +
                     "WHERE o.Дата = ? " +
                     "ORDER BY o.Дата DESC";
        
        try {
            Class.forName("org.sqlite.JDBC");
            try (Connection conn = DriverManager.getConnection(url);
                 PreparedStatement pstmt = conn.prepareStatement(sql)) {
                
                pstmt.setString(1, date);
                ResultSet rs = pstmt.executeQuery();
                
                while (rs.next()) {
                    Operation op = new Operation(
                        rs.getInt("КодОперации"),
                        rs.getDate("Дата"),
                        rs.getString("Артикул") != null ? rs.getString("Артикул") : "",
                        rs.getString("Наименование") != null ? rs.getString("Наименование") : "",
                        rs.getString("ФИО") != null ? rs.getString("ФИО") : "",
                        rs.getString("ТипОперации") != null ? rs.getString("ТипОперации") : "",
                        rs.getInt("Количество"),
                        rs.getString("Причина") != null ? rs.getString("Причина") : ""
                    );
                    operations.add(op);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return operations;
    }
}

