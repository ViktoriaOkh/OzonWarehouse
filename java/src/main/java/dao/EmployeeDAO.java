package dao;

import model.Employee;
import util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class EmployeeDAO {

    public List<Employee> getAllEmployees() {
        List<Employee> employees = new ArrayList<>();
        String sql = "SELECT КодСотрудника, ФИО, Должность, Смена, Штрихкод FROM Сотрудники";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                Employee emp = new Employee();
                emp.setId(rs.getInt("КодСотрудника"));
                emp.setFio(rs.getString("ФИО"));
                emp.setPosition(rs.getString("Должность"));
                emp.setShift(rs.getString("Смена"));
                emp.setBarcode(rs.getString("Штрихкод"));
                employees.add(emp);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return employees;
    }

    public boolean addEmployee(Employee employee) {
        String sql = "INSERT INTO Сотрудники (ФИО, Должность, Смена, Штрихкод) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, employee.getFio());
            pstmt.setString(2, employee.getPosition());
            pstmt.setString(3, employee.getShift());
            pstmt.setString(4, employee.getBarcode());
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteEmployee(int employeeId) {
        try (Connection conn = DBConnection.getConnection()) {
            String deleteOps = "DELETE FROM Операции WHERE КодСотрудника = ?";
            try (PreparedStatement pstmt1 = conn.prepareStatement(deleteOps)) {
                pstmt1.setInt(1, employeeId);
                pstmt1.executeUpdate();
            }
            String deleteEmp = "DELETE FROM Сотрудники WHERE КодСотрудника = ?";
            try (PreparedStatement pstmt2 = conn.prepareStatement(deleteEmp)) {
                pstmt2.setInt(1, employeeId);
                return pstmt2.executeUpdate() > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // НОВЫЙ МЕТОД для авторизации по штрихкоду
    public Employee findByBarcode(String barcode) {
        String sql = "SELECT КодСотрудника, ФИО, Должность, Смена, Штрихкод FROM Сотрудники WHERE Штрихкод = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, barcode);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Employee emp = new Employee();
                emp.setId(rs.getInt("КодСотрудника"));
                emp.setFio(rs.getString("ФИО"));
                emp.setPosition(rs.getString("Должность"));
                emp.setShift(rs.getString("Смена"));
                emp.setBarcode(rs.getString("Штрихкод"));
                return emp;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
}