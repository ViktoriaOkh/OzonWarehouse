package dao;

import model.Cargo;
import util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CargoDAO {

    public List<Cargo> getOpenCargos() {
        List<Cargo> list = new ArrayList<>();
        String sql = "SELECT КодГруза, НомерГруза, ВремяПоступления, КоличествоПозиций, Статус FROM Грузы WHERE Статус = 'Открыт' ORDER BY ВремяПоступления DESC";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                list.add(new Cargo(
                    rs.getInt("КодГруза"),
                    rs.getString("НомерГруза"),
                    rs.getString("ВремяПоступления"),
                    rs.getInt("КоличествоПозиций"),
                    rs.getString("Статус")
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public Cargo findById(int id) {
        String sql = "SELECT КодГруза, НомерГруза, ВремяПоступления, КоличествоПозиций, Статус FROM Грузы WHERE КодГруза = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new Cargo(
                    rs.getInt("КодГруза"),
                    rs.getString("НомерГруза"),
                    rs.getString("ВремяПоступления"),
                    rs.getInt("КоличествоПозиций"),
                    rs.getString("Статус")
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public void closeCargo(int cargoId) {
        String sql = "UPDATE Грузы SET Статус = 'Закрыт' WHERE КодГруза = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, cargoId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public boolean isCargoClosed(int cargoId) {
        String sql = "SELECT Статус FROM Грузы WHERE КодГруза = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, cargoId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return "Закрыт".equals(rs.getString("Статус"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}