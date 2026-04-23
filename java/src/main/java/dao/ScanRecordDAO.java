package dao;

import model.ScanRecord;
import util.DBConnection;
import java.sql.*;

public class ScanRecordDAO {

    public void save(ScanRecord record) {
        String sql = "INSERT INTO Сканирования (КодГруза, КодТовара, КодСотрудника, КодОперации, Количество, Причина, Комментарий, НомерТары) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, record.getCargoId());
            ps.setInt(2, record.getProductId());
            ps.setInt(3, record.getEmployeeId());
            ps.setInt(4, record.getOperationTypeId());
            ps.setInt(5, record.getQuantity());
            ps.setString(6, record.getReason());
            ps.setString(7, record.getComment());
            ps.setString(8, record.getBoxNumber());
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}