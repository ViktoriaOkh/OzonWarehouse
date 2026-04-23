package dao;

import model.Pallet;
import util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PalletDAO {

    // все открытые паллеты
    public List<Pallet> getOpenPallets() {
        List<Pallet> list = new ArrayList<>();
        String sql = "SELECT КодПаллеты, НомерПаллеты, Зона, Количество, Статус, Создана, Закрыта FROM Паллеты WHERE Статус = 'Открыта' ORDER BY Создана DESC";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                list.add(new Pallet(
                    rs.getInt("КодПаллеты"),
                    rs.getString("НомерПаллеты"),
                    rs.getString("Зона"),
                    rs.getInt("Количество"),
                    rs.getString("Статус"),
                    rs.getString("Создана"),
                    rs.getString("Закрыта")
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // паллета по номеру
    public Pallet findByNumber(String number) {
        String sql = "SELECT КодПаллеты, НомерПаллеты, Зона, Количество, Статус, Создана, Закрыта FROM Паллеты WHERE НомерПаллеты = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, number);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new Pallet(
                    rs.getInt("КодПаллеты"),
                    rs.getString("НомерПаллеты"),
                    rs.getString("Зона"),
                    rs.getInt("Количество"),
                    rs.getString("Статус"),
                    rs.getString("Создана"),
                    rs.getString("Закрыта")
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // открыть новую паллету
    public void createPallet(Pallet pallet) {
        String sql = "INSERT INTO Паллеты (НомерПаллеты, Зона, Количество, Статус) VALUES (?, ?, ?, 'Открыта')";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, pallet.getNumber());
            ps.setString(2, pallet.getZone());
            ps.setInt(3, pallet.getQuantity());
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // закрыть паллету
    public void closePallet(int palletId) {
        String sql = "UPDATE Паллеты SET Статус = 'Закрыта', Закрыта = CURRENT_TIMESTAMP WHERE КодПаллеты = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, palletId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // увеличить количество товаров в паллете
    public void incrementQuantity(int palletId, int delta) {
        String sql = "UPDATE Паллеты SET Количество = Количество + ? WHERE КодПаллеты = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, delta);
            ps.setInt(2, palletId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}