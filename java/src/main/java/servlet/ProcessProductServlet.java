package servlet;

import dao.ScanRecordDAO;
import model.ScanRecord;
import util.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.*;

@WebServlet("/processProduct")
public class ProcessProductServlet extends HttpServlet {
    
    private ScanRecordDAO scanDAO = new ScanRecordDAO();
    
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        Integer employeeId = (Integer) session.getAttribute("employeeId");
        if (employeeId == null) {
            resp.sendRedirect("auth");
            return;
        }
        
        int cargoId = Integer.parseInt(req.getParameter("cargoId"));
        int productId = Integer.parseInt(req.getParameter("productId"));
        String action = req.getParameter("action");
        String boxNumber = req.getParameter("boxNumber");
        String reason = req.getParameter("reason") != null ? req.getParameter("reason") : "";
        String comment = req.getParameter("comment") != null ? req.getParameter("comment") : "";
        
        int operationId = switch (action) {
            case "utilit" -> 1;
            case "ucenka" -> 2;
            case "peresort" -> 3;
            case "valid" -> 4;
            default -> 1;
        };
        
        // Сохраняем сканирование
        ScanRecord record = new ScanRecord();
        record.setCargoId(cargoId);
        record.setProductId(productId);
        record.setEmployeeId(employeeId);
        record.setOperationTypeId(operationId);
        record.setQuantity(1);
        record.setReason(reason);
        record.setComment(comment);
        record.setBoxNumber(boxNumber);
        scanDAO.save(record);
        
        // Обновляем количество товаров в таре и категорию
        if (boxNumber != null && !boxNumber.isEmpty()) {
            updateBoxInfo(cargoId, boxNumber, productId);
        }
        
        resp.sendRedirect("cargoProducts?cargoId=" + cargoId);
    }
    
    private void updateBoxInfo(int cargoId, String boxNumber, int productId) {
        // Получаем категорию товара
        String category = null;
        String sqlProduct = "SELECT Категория FROM Товары WHERE КодТовара = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sqlProduct)) {
            ps.setInt(1, productId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                category = rs.getString("Категория");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        if (category != null) {
            // Обновляем категорию тары
            String updateSql = "UPDATE ИсторияТары SET Категория = ? WHERE КодГруза = ? AND НомерТары = ? AND Тип = 'открытие' AND Закрыта IS NULL";
            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement(updateSql)) {
                ps.setString(1, category);
                ps.setInt(2, cargoId);
                ps.setString(3, boxNumber);
                ps.executeUpdate();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}