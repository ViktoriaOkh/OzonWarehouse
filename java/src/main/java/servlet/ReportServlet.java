package servlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/reports")
public class ReportServlet extends HttpServlet {
    
    private static final String DB_URL = "jdbc:sqlite:C:/Users/Vikusya/Desktop/Склад_Ozon.db";
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        out.println("<html><head>");
        out.println("<meta charset='UTF-8'>");
        out.println("<title>Отчеты - Склад Ozon</title>");
        out.println("<style>");
        out.println("body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background: #f0f2f5; padding: 20px; }");
        out.println(".container { max-width: 1200px; margin: 0 auto; background: white; border-radius: 15px; padding: 25px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }");
        out.println("h1 { color: #ff6b35; border-left: 5px solid #ff6b35; padding-left: 15px; }");
        out.println("h2 { color: #333; margin-top: 30px; }");
        out.println(".btn { display: inline-block; padding: 10px 20px; background: #ff6b35; color: white; text-decoration: none; border: none; border-radius: 8px; cursor: pointer; margin: 5px; }");
        out.println(".btn:hover { background: #e55a2b; }");
        out.println("table { width: 100%; border-collapse: collapse; margin-top: 20px; }");
        out.println("th, td { border: 1px solid #ddd; padding: 12px; text-align: left; }");
        out.println("th { background: #ff6b35; color: white; }");
        out.println("tr:nth-child(even) { background: #f9f9f9; }");
        out.println(".nav-links { margin-bottom: 20px; padding-bottom: 15px; border-bottom: 1px solid #eee; }");
        out.println(".nav-links a { color: #ff6b35; text-decoration: none; margin-right: 20px; }");
        out.println(".stat-card { background: #f8f9fa; padding: 15px; border-radius: 10px; display: inline-block; margin: 10px; text-align: center; min-width: 150px; }");
        out.println(".stat-number { font-size: 28px; font-weight: bold; color: #ff6b35; }");
        out.println("</style>");
        out.println("</head><body>");
        
        out.println("<div class='container'>");
        out.println("<div class='nav-links'>");
        out.println("<a href='index.jsp'>🏠 Главная</a>");
        out.println("<a href='products'>📦 Товары</a>");
        out.println("<a href='employees'>👥 Сотрудники</a>");
        out.println("<a href='operations'>📝 Операции</a>");
        out.println("<a href='reports'>📊 Отчеты</a>");
        out.println("<a href='utilization'>🗑️ Акт утилизации</a>");
        out.println("</div>");
        
        out.println("<h1>📊 Отчеты и статистика</h1>");
        
        try {
            Class.forName("org.sqlite.JDBC");
            Connection conn = DriverManager.getConnection(DB_URL);
            Statement stmt = conn.createStatement();
            
            // ========== ОБЩАЯ СТАТИСТИКА ==========
            out.println("<h2>📈 Общая статистика</h2>");
            
            ResultSet rs = stmt.executeQuery("SELECT COUNT(*) as total FROM Операции");
            int totalOps = rs.next() ? rs.getInt("total") : 0;
            
            rs = stmt.executeQuery("SELECT COUNT(*) as total FROM Товары");
            int totalProducts = rs.next() ? rs.getInt("total") : 0;
            
            rs = stmt.executeQuery("SELECT COUNT(*) as total FROM Сотрудники");
            int totalEmployees = rs.next() ? rs.getInt("total") : 0;
            
            out.println("<div>");
            out.println("<div class='stat-card'><div class='stat-number'>" + totalOps + "</div>Операций</div>");
            out.println("<div class='stat-card'><div class='stat-number'>" + totalProducts + "</div>Товаров</div>");
            out.println("<div class='stat-card'><div class='stat-number'>" + totalEmployees + "</div>Сотрудников</div>");
            out.println("</div>");
            
            // ========== СТАТИСТИКА ПО ТИПАМ ОПЕРАЦИЙ ==========
            out.println("<h2>📋 Статистика по типам операций</h2>");
            out.println("<table>");
            out.println("<tr><th>Тип операции</th><th>Количество</th><th>Общий объем</th></tr>");
            
            rs = stmt.executeQuery(
                "SELECT tp.Название, COUNT(*) as Количество, SUM(o.Количество) as Объем " +
                "FROM Операции o " +
                "LEFT JOIN ТипыОпераций tp ON o.КодТипа = tp.КодТипа " +
                "GROUP BY tp.Название " +
                "ORDER BY Количество DESC"
            );
            
            while (rs.next()) {
                out.println("<tr>");
                out.println("<td>" + (rs.getString("Название") != null ? rs.getString("Название") : "Неизвестный") + "</td>");
                out.println("<td>" + rs.getInt("Количество") + "</td>");
                out.println("<td>" + rs.getInt("Объем") + "</td>");
                out.println("</tr>");
            }
            out.println("</table>");
            
            // ========== СТАТИСТИКА ПО КАТЕГОРИЯМ ==========
            out.println("<h2>📁 Товары по категориям</h2>");
            out.println("<table>");
            out.println("<tr><th>Категория</th><th>Количество товаров</th></tr>");
            
            rs = stmt.executeQuery(
                "SELECT Категория, COUNT(*) as Количество " +
                "FROM Товары " +
                "GROUP BY Категория " +
                "ORDER BY Количество DESC"
            );
            
            while (rs.next()) {
                out.println("<tr>");
                out.println("<td>" + (rs.getString("Категория") != null ? rs.getString("Категория") : "Без категории") + "</td>");
                out.println("<td>" + rs.getInt("Количество") + "</td>");
                out.println("</tr>");
            }
            out.println("</table>");
            
            // ========== ТОП-5 ТОВАРОВ ==========
            out.println("<h2>🏆 Топ-5 товаров по количеству операций</h2>");
            out.println("<table>");
            out.println("<tr><th>Артикул</th><th>Наименование</th><th>Кол-во операций</th></tr>");
            
            rs = stmt.executeQuery(
                "SELECT t.Артикул, t.Наименование, COUNT(*) as Количество " +
                "FROM Операции o " +
                "LEFT JOIN Товары t ON o.КодТовара = t.КодТовара " +
                "GROUP BY t.КодТовара " +
                "ORDER BY Количество DESC " +
                "LIMIT 5"
            );
            
            while (rs.next()) {
                out.println("<tr>");
                out.println("<td>" + (rs.getString("Артикул") != null ? rs.getString("Артикул") : "—") + "</td>");
                out.println("<td>" + (rs.getString("Наименование") != null ? rs.getString("Наименование") : "—") + "</td>");
                out.println("<td>" + rs.getInt("Количество") + "</td>");
                out.println("</tr>");
            }
            out.println("</table>");
            
            stmt.close();
            conn.close();
            
        } catch (Exception e) {
            out.println("<p style='color:red;'>Ошибка: " + e.getMessage() + "</p>");
            e.printStackTrace();
        }
        
        out.println("<br><a href='index.jsp' class='btn'>🏠 На главную</a>");
        out.println("</div></body></html>");
    }
}