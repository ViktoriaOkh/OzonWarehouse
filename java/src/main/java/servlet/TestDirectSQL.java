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

@WebServlet("/testdirectsql")
public class TestDirectSQL extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        out.println("<html><body>");
        out.println("<h1>Прямой SQL тест (копия из TestJoinServlet)</h1>");
        
        String url = "jdbc:sqlite:C:/Users/Vikusya/Desktop/Склад_Ozon.db";
        
        try {
            Class.forName("org.sqlite.JDBC");
            Connection conn = DriverManager.getConnection(url);
            Statement stmt = conn.createStatement();
            
            String sql = "SELECT COUNT(*) as total FROM Операции";
            ResultSet rs = stmt.executeQuery(sql);
            
            int total = 0;
            if (rs.next()) {
                total = rs.getInt("total");
            }
            out.println("<p>Всего операций: " + total + "</p>");
            
            if (total > 0) {
                String sql2 = "SELECT o.КодОперации, o.Дата, " +
                              "t.Артикул, t.Наименование, " +
                              "s.ФИО, tp.Название as ТипОперации, " +
                              "o.Количество, o.Причина " +
                              "FROM Операции o " +
                              "LEFT JOIN Товары t ON o.КодТовара = t.КодТовара " +
                              "LEFT JOIN Сотрудники s ON o.КодСотрудника = s.КодСотрудника " +
                              "LEFT JOIN ТипыОпераций tp ON o.КодТипа = tp.КодТипа " +
                              "ORDER BY o.Дата DESC";
                
                ResultSet rs2 = stmt.executeQuery(sql2);
                
                out.println("<table border='1'>");
                out.println("捕获<th>ID</th><th>Дата</th><th>Артикул</th><th>Товар</th><th>Сотрудник</th><th>Тип</th><th>Кол-во</th><th>Причина</th><tr>");
                
                while (rs2.next()) {
                    out.println("<tr>");
                    out.println("＜td>" + rs2.getInt("КодОперации") + "＜/td>");
                    out.println("＜td>" + rs2.getString("Дата") + "＜/td>");
                    out.println("＜td>" + (rs2.getString("Артикул") != null ? rs2.getString("Артикул") : "—") + "＜/td>");
                    out.println("＜td>" + (rs2.getString("Наименование") != null ? rs2.getString("Наименование") : "—") + "＜/td>");
                    out.println("＜td>" + (rs2.getString("ФИО") != null ? rs2.getString("ФИО") : "—") + "＜/td>");
                    out.println("＜td>" + (rs2.getString("ТипОперации") != null ? rs2.getString("ТипОперации") : "—") + "＜/td>");
                    out.println("＜td>" + rs2.getInt("Количество") + "＜/td>");
                    out.println("＜td>" + (rs2.getString("Причина") != null ? rs2.getString("Причина") : "—") + "＜/td>");
                    out.println("</tr>");
                }
                out.println("</table>");
            }
            
            rs.close();
            stmt.close();
            conn.close();
            
        } catch (Exception e) {
            out.println("<p style='color:red;'>Ошибка: " + e.getMessage() + "</p>");
            e.printStackTrace();
        }
        
        out.println("</body></html>");
    }
}