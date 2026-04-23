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

@WebServlet("/api/box")
public class BoxApiServlet extends HttpServlet {
    
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
            
            if ("open".equals(action)) {
                String boxNumber = req.getParameter("boxNumber");
                String operationType = req.getParameter("operationType");
                
                if (boxNumber == null || boxNumber.trim().isEmpty()) {
                    out.print("error|Введите номер тары");
                    return;
                }
                
                if (operationType == null || operationType.trim().isEmpty()) {
                    out.print("error|Выберите тип тары");
                    return;
                }
                
                String checkSql = "SELECT COUNT(*) FROM ИсторияТары WHERE КодГруза = ? AND НомерТары = ? AND Тип = 'открытие' AND Закрыта IS NULL";
                try (PreparedStatement ps = conn.prepareStatement(checkSql)) {
                    ps.setInt(1, cargoId);
                    ps.setString(2, boxNumber);
                    ResultSet rs = ps.executeQuery();
                    if (rs.next() && rs.getInt(1) > 0) {
                        out.print("error|Тара " + boxNumber + " уже открыта");
                        return;
                    }
                }
                
                String insertSql = "INSERT INTO ИсторияТары (КодГруза, НомерТары, Тип, ТипОперации, ВремяОткрытия) VALUES (?, ?, 'открытие', ?, CURRENT_TIMESTAMP)";
                try (PreparedStatement ps = conn.prepareStatement(insertSql)) {
                    ps.setInt(1, cargoId);
                    ps.setString(2, boxNumber);
                    ps.setString(3, operationType);
                    ps.executeUpdate();
                }
                
                out.print("success|Тара " + boxNumber + " (" + operationType + ") открыта");
                
            } else if ("close".equals(action)) {
                String boxNumber = req.getParameter("boxNumber");
                
                if (boxNumber == null || boxNumber.trim().isEmpty()) {
                    out.print("error|Введите номер тары для закрытия");
                    return;
                }
                
                String checkSql = "SELECT КодИстории FROM ИсторияТары WHERE КодГруза = ? AND НомерТары = ? AND Тип = 'открытие' AND Закрыта IS NULL";
                Integer historyId = null;
                try (PreparedStatement ps = conn.prepareStatement(checkSql)) {
                    ps.setInt(1, cargoId);
                    ps.setString(2, boxNumber);
                    ResultSet rs = ps.executeQuery();
                    if (rs.next()) {
                        historyId = rs.getInt("КодИстории");
                    }
                }
                
                if (historyId == null) {
                    out.print("error|Тара " + boxNumber + " не найдена или уже закрыта");
                    return;
                }
                
                String updateSql = "UPDATE ИсторияТары SET Тип = 'закрытие', ВремяЗакрытия = CURRENT_TIMESTAMP, Закрыта = 'да' WHERE КодИстории = ?";
                try (PreparedStatement ps = conn.prepareStatement(updateSql)) {
                    ps.setInt(1, historyId);
                    ps.executeUpdate();
                }
                
                out.print("success|Тара " + boxNumber + " закрыта");
                
            } else if ("current".equals(action)) {
                String findSql = "SELECT НомерТары, Категория, ТипОперации FROM ИсторияТары WHERE КодГруза = ? AND Тип = 'открытие' AND Закрыта IS NULL";
                try (PreparedStatement ps = conn.prepareStatement(findSql)) {
                    ps.setInt(1, cargoId);
                    ResultSet rs = ps.executeQuery();
                    StringBuilder boxes = new StringBuilder();
                    while (rs.next()) {
                        if (boxes.length() > 0) boxes.append(",");
                        boxes.append(rs.getString("НомерТары"));
                        String category = rs.getString("Категория");
                        if (category != null && !category.isEmpty()) {
                            boxes.append("(").append(category).append(")");
                        }
                        String opType = rs.getString("ТипОперации");
                        if (opType != null && !opType.isEmpty()) {
                            boxes.append("[").append(opType).append("]");
                        }
                    }
                    if (boxes.length() > 0) {
                        out.print("success|" + boxes.toString());
                    } else {
                        out.print("empty|");
                    }
                }
            } else if ("check".equals(action)) {
                String boxNumber = req.getParameter("boxNumber");
                String operationType = req.getParameter("operationType");
                
                if (boxNumber == null || boxNumber.trim().isEmpty()) {
                    out.print("error|Не указана тара");
                    return;
                }
                
                String checkSql = "SELECT ТипОперации FROM ИсторияТары WHERE КодГруза = ? AND НомерТары = ? AND Тип = 'открытие' AND Закрыта IS NULL";
                try (PreparedStatement ps = conn.prepareStatement(checkSql)) {
                    ps.setInt(1, cargoId);
                    ps.setString(2, boxNumber);
                    ResultSet rs = ps.executeQuery();
                    if (rs.next()) {
                        String existingType = rs.getString("ТипОперации");
                        if (existingType != null && !existingType.isEmpty() && !existingType.equals(operationType)) {
                            out.print("error|В этой таре уже лежат товары типа: " + existingType + ". Нельзя смешивать!");
                            return;
                        }
                    }
                }
                out.print("success|ok");
                
            } else if ("stats".equals(action)) {
                String boxNumber = req.getParameter("boxNumber");
                
                if (boxNumber == null || boxNumber.trim().isEmpty()) {
                    out.print("error|Не указан номер тары");
                    return;
                }
                
                String statsSql = "SELECT " +
                                  "SUM(CASE WHEN КодОперации = 1 THEN Количество ELSE 0 END) as utilit, " +
                                  "SUM(CASE WHEN КодОперации = 2 THEN Количество ELSE 0 END) as ucenka, " +
                                  "SUM(CASE WHEN КодОперации = 3 THEN Количество ELSE 0 END) as peresort, " +
                                  "SUM(CASE WHEN КодОперации = 4 THEN Количество ELSE 0 END) as valid, " +
                                  "SUM(Количество) as total " +
                                  "FROM Сканирования WHERE КодГруза = ? AND НомерТары = ?";
                
                try (PreparedStatement ps = conn.prepareStatement(statsSql)) {
                    ps.setInt(1, cargoId);
                    ps.setString(2, boxNumber);
                    ResultSet rs = ps.executeQuery();
                    if (rs.next()) {
                        int utilit = rs.getInt("utilit");
                        int ucenka = rs.getInt("ucenka");
                        int peresort = rs.getInt("peresort");
                        int valid = rs.getInt("valid");
                        int total = rs.getInt("total");
                        out.print("success|" + utilit + "|" + ucenka + "|" + peresort + "|" + valid + "|" + total);
                    } else {
                        out.print("success|0|0|0|0|0");
                    }
                }
            } else {
                out.print("error|Неизвестное действие");
            }
            
        } catch (SQLException e) {
            out.print("error|" + e.getMessage());
            e.printStackTrace();
        }
    }
}