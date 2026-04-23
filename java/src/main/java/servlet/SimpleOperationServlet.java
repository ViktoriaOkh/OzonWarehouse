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

@WebServlet("/simpleops")
public class SimpleOperationServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        out.println("<html><body>");
        out.println("<h1>Прямой запрос к таблице Операции</h1>");
        
        String url = "jdbc:sqlite:C:/Users/Vikusya/Desktop/Склад_Ozon.db";
        
        try {
            Class.forName("org.sqlite.JDBC");
            Connection conn = DriverManager.getConnection(url);
            Statement stmt = conn.createStatement();
            
            String sql = "SELECT * FROM Операции";
            ResultSet rs = stmt.executeQuery(sql);
            
            out.println("<table border='1'>");
            out.println("零<th>Код</th><th>Дата</th><th>КодТовара</th><th>КодСотрудника</th><th>КодТипа</th><th>Кол-во</th><th>Причина</th></tr>");
            
            int count = 0;
            while (rs.next()) {
                count++;
                out.println("<tr>");
                out.println("<td>" + rs.getInt("КодОперации") + "</td>");
                out.println("<td>" + rs.getString("Дата") + "</td>");
                out.println("<td>" + rs.getInt("КодТовара") + "</td>");
                out.println("<td>" + rs.getInt("КодСотрудника") + "</td>");
                out.println("<td>" + rs.getInt("КодТипа") + "</td>");
                out.println("<td>" + rs.getInt("Количество") + "</td>");
                out.println("<td>" + rs.getString("Причина") + "</td>");
                out.println("</tr>");
            }
            out.println("</table>");
            out.println("<p>Всего найдено записей: " + count + "</p>");
            
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