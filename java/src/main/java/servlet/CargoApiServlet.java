package servlet;

import util.DBConnection;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/api/cargo")
public class CargoApiServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("text/plain;charset=UTF-8");
        PrintWriter out = resp.getWriter();
        
        String action = req.getParameter("action");
        String cargoIdParam = req.getParameter("cargoId");
        
        if (cargoIdParam == null || cargoIdParam.isEmpty()) {
            out.print("error|Не указан cargoId");
            return;
        }
        
        int cargoId = Integer.parseInt(cargoIdParam);
        
        try (Connection conn = DBConnection.getConnection()) {
            
            if ("close".equals(action)) {
                // Проверяем, не закрыт ли уже груз
                String checkSql = "SELECT Статус FROM Грузы WHERE КодГруза = ?";
                String status = null;
                try (PreparedStatement ps = conn.prepareStatement(checkSql)) {
                    ps.setInt(1, cargoId);
                    ResultSet rs = ps.executeQuery();
                    if (rs.next()) {
                        status = rs.getString("Статус");
                    }
                }
                
                if ("Закрыт".equals(status)) {
                    out.print("error|Груз уже закрыт");
                    return;
                }
                
                // Закрываем груз
                String updateSql = "UPDATE Грузы SET Статус = 'Закрыт' WHERE КодГруза = ?";
                try (PreparedStatement ps = conn.prepareStatement(updateSql)) {
                    ps.setInt(1, cargoId);
                    ps.executeUpdate();
                }
                
                out.print("success|Груз закрыт");
            } else {
                out.print("error|Неизвестное действие");
            }
            
        } catch (SQLException e) {
            out.print("error|" + e.getMessage());
            e.printStackTrace();
        }
    }
}