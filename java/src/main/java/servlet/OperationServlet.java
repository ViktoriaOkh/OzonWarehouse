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

@WebServlet("/operations")
public class OperationServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        out.println("<!DOCTYPE html>");
        out.println("<html>");
        out.println("<head><meta charset='UTF-8'><title>Операции - Склад Ozon</title>");
        out.println("<style>");
        out.println("body { font-family: 'Segoe UI', Arial; background: #f0f2f5; padding: 20px; }");
        out.println(".container { max-width: 1400px; margin: 0 auto; background: white; border-radius: 15px; padding: 25px; }");
        out.println("h1 { color: #ff6b35; }");
        out.println("table { width: 100%; border-collapse: collapse; margin-top: 20px; }");
        out.println("th, td { border: 1px solid #ddd; padding: 12px; text-align: left; }");
        out.println("th { background: #ff6b35; color: white; }");
        out.println("tr:nth-child(even) { background: #f9f9f9; }");
        out.println(".btn { display: inline-block; padding: 10px 20px; background: #ff6b35; color: white; text-decoration: none; border-radius: 8px; margin-top: 20px; }");
        out.println("</style>");
        out.println("</head><body>");
        out.println("<div class='container'>");
        out.println("<h1>📝 Журнал операций</h1>");
        
        String url = "jdbc:sqlite:C:/Users/Vikusya/Desktop/Склад_Ozon.db";
        
        try {
            Class.forName("org.sqlite.JDBC");
            Connection conn = DriverManager.getConnection(url);
            Statement stmt = conn.createStatement();
            
            String sql = "SELECT o.КодОперации, o.Дата, " +
                         "t.Артикул, t.Наименование, " +
                         "s.ФИО, tp.Название as ТипОперации, " +
                         "o.Количество, o.Причина " +
                         "FROM Операции o " +
                         "LEFT JOIN Товары t ON o.КодТовара = t.КодТовара " +
                         "LEFT JOIN Сотрудники s ON o.КодСотрудника = s.КодСотрудника " +
                         "LEFT JOIN ТипыОпераций tp ON o.КодТипа = tp.КодТипа " +
                         "ORDER BY o.Дата DESC";
            
            ResultSet rs = stmt.executeQuery(sql);
            
            out.println("<table>");
            out.println("<tr><th>ID</th><th>Дата</th><th>Артикул</th><th>Товар</th><th>Сотрудник</th><th>Тип операции</th><th>Кол-во</th><th>Причина</th></tr>");
            
            int count = 0;
            while (rs.next()) {
                count++;
                out.println("<tr>");
                out.println("<td>" + rs.getInt("КодОперации") + "</td>");
                out.println("<td>" + rs.getString("Дата") + "</td>");
                out.println("<td>" + (rs.getString("Артикул") != null ? rs.getString("Артикул") : "—") + "</td>");
                out.println("<td>" + (rs.getString("Наименование") != null ? rs.getString("Наименование") : "—") + "</td>");
                out.println("<td>" + (rs.getString("ФИО") != null ? rs.getString("ФИО") : "—") + "</td>");
                out.println("<td>" + (rs.getString("ТипОперации") != null ? rs.getString("ТипОперации") : "—") + "</td>");
                out.println("<td>" + rs.getInt("Количество") + "</td>");
                out.println("<td>" + (rs.getString("Причина") != null ? rs.getString("Причина") : "—") + "</td>");
                out.println("</tr>");
            }
            out.println("</table>");
            
            out.println("<p><strong>Всего операций: " + count + "</strong></p>");
            
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