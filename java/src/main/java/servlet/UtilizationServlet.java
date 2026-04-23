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

@WebServlet("/utilization")
public class UtilizationServlet extends HttpServlet {
    
    private static final String DB_URL = "jdbc:sqlite:C:/Users/Vikusya/Desktop/Склад_Ozon.db";
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        out.println("<html><head>");
        out.println("<meta charset='UTF-8'>");
        out.println("<title>Акт утилизации - Склад Ozon</title>");
        out.println("<style>");
        out.println("body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background: #f0f2f5; padding: 20px; }");
        out.println(".container { max-width: 1200px; margin: 0 auto; background: white; border-radius: 15px; padding: 25px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }");
        out.println("h1 { color: #ff6b35; border-left: 5px solid #ff6b35; padding-left: 15px; }");
        out.println("h2 { color: #333; margin-top: 30px; }");
        out.println(".btn { display: inline-block; padding: 10px 20px; background: #ff6b35; color: white; text-decoration: none; border: none; border-radius: 8px; cursor: pointer; margin: 5px; }");
        out.println(".btn:hover { background: #e55a2b; }");
        out.println(".btn-print { background: #28a745; }");
        out.println(".btn-print:hover { background: #218838; }");
        out.println("table { width: 100%; border-collapse: collapse; margin-top: 20px; }");
        out.println("th, td { border: 1px solid #ddd; padding: 12px; text-align: left; }");
        out.println("th { background: #ff6b35; color: white; }");
        out.println("tr:nth-child(even) { background: #f9f9f9; }");
        out.println(".nav-links { margin-bottom: 20px; padding-bottom: 15px; border-bottom: 1px solid #eee; }");
        out.println(".nav-links a { color: #ff6b35; text-decoration: none; margin-right: 20px; }");
        out.println(".total { font-size: 18px; font-weight: bold; margin-top: 20px; padding: 10px; background: #f8f9fa; border-radius: 8px; }");
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
        
        out.println("<h1>🗑️ АКТ УТИЛИЗАЦИИ ТОВАРОВ</h1>");
        out.println("<button class='btn btn-print' onclick='window.print()'>🖨️ Печать</button>");
        
        try {
            Class.forName("org.sqlite.JDBC");
            Connection conn = DriverManager.getConnection(DB_URL);
            Statement stmt = conn.createStatement();
            
            String sql = 
                "SELECT o.КодОперации, o.Дата, " +
                "t.Артикул, t.Наименование, t.Категория, " +
                "s.ФИО, o.Причина, o.Количество " +
                "FROM Операции o " +
                "LEFT JOIN Товары t ON o.КодТовара = t.КодТовара " +
                "LEFT JOIN Сотрудники s ON o.КодСотрудника = s.КодСотрудника " +
                "LEFT JOIN ТипыОпераций tp ON o.КодТипа = tp.КодТипа " +
                "WHERE tp.Название = 'Утилизация' " +
                "ORDER BY o.Дата DESC";
            
            ResultSet rs = stmt.executeQuery(sql);
            
            out.println("<table>");
            out.println("<tr>");
            out.println("<th>№</th>");
            out.println("<th>Дата</th>");
            out.println("<th>Артикул</th>");
            out.println("<th>Наименование товара</th>");
            out.println("<th>Категория</th>");
            out.println("<th>Кол-во</th>");
            out.println("<th>Причина утилизации</th>");
            out.println("<th>Ответственный</th>");
            out.println("</tr>");
            
            int totalCount = 0;
            int totalQuantity = 0;
            int rowNum = 1;
            
            while (rs.next()) {
                totalCount++;
                totalQuantity += rs.getInt("Количество");
                
                out.println("<tr>");
                out.println("<td>" + rowNum++ + "</td>");
                out.println("<td>" + rs.getString("Дата") + "</td>");
                out.println("<td>" + (rs.getString("Артикул") != null ? rs.getString("Артикул") : "—") + "</td>");
                out.println("<td>" + (rs.getString("Наименование") != null ? rs.getString("Наименование") : "—") + "</td>");
                out.println("<td>" + (rs.getString("Категория") != null ? rs.getString("Категория") : "—") + "</td>");
                out.println("<td>" + rs.getInt("Количество") + "</td>");
                out.println("<td>" + (rs.getString("Причина") != null ? rs.getString("Причина") : "—") + "</td>");
                out.println("<td>" + (rs.getString("ФИО") != null ? rs.getString("ФИО") : "—") + "</td>");
                out.println("</tr>");
            }
            
            out.println("</table>");
            
            out.println("<div class='total'>");
            out.println("📊 ИТОГО: утилизировано " + totalCount + " позиций, общим количеством " + totalQuantity + " единиц");
            out.println("</div>");
            
            if (totalCount == 0) {
                out.println("<p style='text-align:center; color:#666;'>Нет операций по утилизации</p>");
            }
            
            out.println("<div style='margin-top: 30px;'>");
            out.println("<p>Дата составления акта: " + new java.text.SimpleDateFormat("dd.MM.yyyy").format(new java.util.Date()) + "</p>");
            out.println("<p>Подпись ответственного лица: _________________</p>");
            out.println("</div>");
            
            rs.close();
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