package util;

import java.sql.*;

public class DBConnection {
    
    public static Connection getConnection() {
        Connection connection = null;
        
        // АБСОЛЮТНЫЙ ПУТЬ К ФАЙЛУ НА РАБОЧЕМ СТОЛЕ
        String url = "jdbc:sqlite:C:/Users/Vikusya/Desktop/Склад_Ozon.db";
        
        try {
            Class.forName("org.sqlite.JDBC");
            connection = DriverManager.getConnection(url);
            System.out.println("✅ DBConnection: Подключение к БД успешно! Путь: " + url);
        } catch (ClassNotFoundException e) {
            System.out.println("❌ DBConnection: Драйвер SQLite не найден!");
            e.printStackTrace();
        } catch (SQLException e) {
            System.out.println("❌ DBConnection: Ошибка подключения к БД!");
            System.out.println("   Проверь путь: " + url);
            e.printStackTrace();
        }
        return connection;
    }
}