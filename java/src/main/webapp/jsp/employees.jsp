<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Сотрудники - Склад Ozon</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #e6f0fa 0%, #fce4ec 100%);
            min-height: 100vh;
            padding: 20px;
        }
        .container {
            max-width: 1200px;
            margin: 0 auto;
            background: white;
            border-radius: 20px;
            padding: 25px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.08);
        }
        .header {
            background: #005bff;
            border-radius: 15px;
            padding: 15px 25px;
            margin-bottom: 25px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
        }
        .header h1 {
            color: white;
            font-size: 24px;
        }
        .nav-links a {
            color: white;
            text-decoration: none;
            margin-left: 20px;
            padding: 5px 10px;
            border-radius: 8px;
            transition: background 0.3s;
        }
        .nav-links a:hover {
            background: rgba(255,255,255,0.2);
        }
        .btn {
            display: inline-block;
            padding: 10px 20px;
            background: #005bff;
            color: white;
            text-decoration: none;
            border: none;
            border-radius: 10px;
            cursor: pointer;
            font-size: 14px;
            transition: all 0.3s;
        }
        .btn:hover {
            background: #ff6b35;
            transform: translateY(-2px);
        }
        .btn-danger {
            background: #ff6b35;
        }
        .btn-danger:hover {
            background: #e55a2b;
        }
        .btn-sm {
            padding: 5px 12px;
            font-size: 12px;
        }
        .success {
            background: #d4edda;
            color: #155724;
            padding: 12px;
            border-radius: 10px;
            margin-bottom: 20px;
            border-left: 4px solid #28a745;
        }
        .form-group {
            margin-bottom: 15px;
            display: flex;
            align-items: center;
            flex-wrap: wrap;
            gap: 10px;
        }
        .form-group label {
            width: 100px;
            font-weight: bold;
            color: #005bff;
        }
        .form-group input, .form-group select {
            padding: 10px 15px;
            border: 1px solid #ddd;
            border-radius: 10px;
            width: 250px;
        }
        .form-group input:focus, .form-group select:focus {
            outline: none;
            border-color: #ff6b35;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        th, td {
            border: 1px solid #e0e0e0;
            padding: 12px;
            text-align: left;
        }
        th {
            background: #005bff;
            color: white;
            font-weight: 500;
        }
        tr:nth-child(even) {
            background: #f9f9f9;
        }
        tr:hover {
            background: #fce4ec;
        }
        h2 {
            color: #005bff;
            margin: 25px 0 15px 0;
            font-size: 1.3em;
        }
        hr {
            border: none;
            border-top: 2px solid #f0f2f5;
            margin: 20px 0;
        }
        .modal {
            display: none;
            position: fixed;
            top: 0; left: 0;
            width: 100%; height: 100%;
            background: rgba(0,0,0,0.5);
            justify-content: center;
            align-items: center;
            z-index: 1000;
        }
        .modal-content {
            background: white;
            padding: 25px;
            border-radius: 20px;
            width: 400px;
        }
        .modal-content input, .modal-content select {
            width: 100%;
            padding: 10px;
            margin: 10px 0;
            border: 1px solid #ddd;
            border-radius: 10px;
        }
    </style>
</head>
<body>
<div class="container">
    <div class="header">
        <h1>👥 Управление сотрудниками</h1>
        <div class="nav-links">
            <a href="../index.jsp">🏠 Главная</a>
            <a href="products.jsp">📦 Товары</a>
            <a href="employees.jsp">👥 Сотрудники</a>
            <a href="operations.jsp">📝 Операции</a>
            <a href="reports.jsp">📊 Отчеты</a>
            <a href="utilization.jsp">🗑️ Акт</a>
        </div>
    </div>
    
    <%
        String dbUrl = "jdbc:sqlite:C:/Users/Vikusya/Desktop/Склад_Ozon.db";
        
        // ОБРАБОТКА ДОБАВЛЕНИЯ СОТРУДНИКА
        String action = request.getParameter("action");
        if ("add".equals(action)) {
            String fio = request.getParameter("fio");
            String position = request.getParameter("position");
            String shift = request.getParameter("shift");
            
            if (fio != null && position != null && shift != null) {
                try {
                    Class.forName("org.sqlite.JDBC");
                    Connection conn = DriverManager.getConnection(dbUrl);
                    PreparedStatement pstmt = conn.prepareStatement("INSERT INTO Сотрудники (ФИО, Должность, Смена) VALUES (?, ?, ?)");
                    pstmt.setString(1, fio);
                    pstmt.setString(2, position);
                    pstmt.setString(3, shift);
                    pstmt.executeUpdate();
                    pstmt.close();
                    conn.close();
                    out.println("<div class='success'>✅ Сотрудник успешно добавлен!</div>");
                } catch (Exception e) {
                    out.println("<div class='success' style='background:#f8d7da; color:#721c24;'>❌ Ошибка: " + e.getMessage() + "</div>");
                }
            }
        }
        
        // ОБРАБОТКА УДАЛЕНИЯ СОТРУДНИКА
        String deleteId = request.getParameter("delete");
        if (deleteId != null) {
            try {
                Class.forName("org.sqlite.JDBC");
                Connection conn = DriverManager.getConnection(dbUrl);
                
                // Удаляем связанные операции
                PreparedStatement pstmt1 = conn.prepareStatement("DELETE FROM Операции WHERE КодСотрудника = ?");
                pstmt1.setInt(1, Integer.parseInt(deleteId));
                pstmt1.executeUpdate();
                pstmt1.close();
                
                // Удаляем сотрудника
                PreparedStatement pstmt2 = conn.prepareStatement("DELETE FROM Сотрудники WHERE КодСотрудника = ?");
                pstmt2.setInt(1, Integer.parseInt(deleteId));
                pstmt2.executeUpdate();
                pstmt2.close();
                conn.close();
                out.println("<div class='success'>🗑️ Сотрудник успешно удален!</div>");
            } catch (Exception e) {
                out.println("<div class='success' style='background:#f8d7da; color:#721c24;'>❌ Ошибка: " + e.getMessage() + "</div>");
            }
        }
        
        // ОБРАБОТКА ИЗМЕНЕНИЯ ДОЛЖНОСТИ И СМЕНЫ СОТРУДНИКА
        String updateId = request.getParameter("updateId");
        String newPosition = request.getParameter("newPosition");
        String newShift = request.getParameter("newShift");
        if (updateId != null && (newPosition != null || newShift != null)) {
            try {
                Class.forName("org.sqlite.JDBC");
                Connection conn = DriverManager.getConnection(dbUrl);
                
                if (newPosition != null && !newPosition.isEmpty()) {
                    PreparedStatement pstmt = conn.prepareStatement("UPDATE Сотрудники SET Должность = ? WHERE КодСотрудника = ?");
                    pstmt.setString(1, newPosition);
                    pstmt.setInt(2, Integer.parseInt(updateId));
                    pstmt.executeUpdate();
                    pstmt.close();
                }
                if (newShift != null && !newShift.isEmpty()) {
                    PreparedStatement pstmt = conn.prepareStatement("UPDATE Сотрудники SET Смена = ? WHERE КодСотрудника = ?");
                    pstmt.setString(1, newShift);
                    pstmt.setInt(2, Integer.parseInt(updateId));
                    pstmt.executeUpdate();
                    pstmt.close();
                }
                conn.close();
                out.println("<div class='success'>✏️ Данные сотрудника обновлены!</div>");
            } catch (Exception e) {
                out.println("<div class='success' style='background:#f8d7da; color:#721c24;'>❌ Ошибка: " + e.getMessage() + "</div>");
            }
        }
    %>
    
    <h2>➕ Добавить нового сотрудника</h2>
    <form method="post" action="employees.jsp">
        <input type="hidden" name="action" value="add">
        <div class="form-group">
            <label>ФИО:</label>
            <input type="text" name="fio" required placeholder="Иванова Анна Петровна">
        </div>
        <div class="form-group">
            <label>Должность:</label>
            <select name="position" required>
                <option value="">Выберите должность</option>
                <option value="Оператор возвратов">Оператор возвратов</option>
                <option value="Специалист по уценке">Специалист по уценке</option>
                <option value="Кладовщик">Кладовщик</option>
                <option value="Старший смены">Старший смены</option>
            </select>
        </div>
        <div class="form-group">
            <label>Смена:</label>
            <select name="shift" required>
                <option value="">Выберите смену</option>
                <option value="Дневная">Дневная</option>
                <option value="Ночная">Ночная</option>
            </select>
        </div>
        <button type="submit" class="btn">➕ Добавить сотрудника</button>
    </form>
    
    <hr>
    
    <h2>📋 Список сотрудников</h2>
    <table>
        <thead>
            <tr>
                <th>Код</th>
                <th>ФИО</th>
                <th>Должность</th>
                <th>Смена</th>
                <th>Действия</th>
            </tr>
        </thead>
        <tbody>
            <%
                try {
                    Class.forName("org.sqlite.JDBC");
                    Connection conn = DriverManager.getConnection(dbUrl);
                    Statement stmt = conn.createStatement();
                    ResultSet rs = stmt.executeQuery("SELECT КодСотрудника, ФИО, Должность, Смена FROM Сотрудники ORDER BY КодСотрудника");
                    
                    boolean hasData = false;
                    while (rs.next()) {
                        hasData = true;
            %>
            <tr>
                <td><%= rs.getInt("КодСотрудника") %></td>
                <td><%= rs.getString("ФИО") %></td>
                <td><%= rs.getString("Должность") %></td>
                <td><%= rs.getString("Смена") %></td>
                <td>
                    <button class="btn btn-sm" onclick='openModal(<%= rs.getInt("КодСотрудника") %>, "<%= rs.getString("Должность") %>", "<%= rs.getString("Смена") %>")'>✏️ Редактировать</button>
                    <a href="employees.jsp?delete=<%= rs.getInt("КодСотрудника") %>" class="btn btn-sm btn-danger" onclick="return confirm('Удалить сотрудника? Все его операции будут удалены!')">🗑️</a>
                </td>
            </tr>
            <%
                    }
                    rs.close();
                    stmt.close();
                    conn.close();
                    
                    if (!hasData) {
            %>
            <tr><td colspan="5" style="text-align: center;">Нет данных о сотрудниках</td></tr>
            <%
                    }
                } catch (Exception e) {
                    out.println("<tr><td colspan='5' style='text-align:center; color:red;'>Ошибка загрузки: " + e.getMessage() + "</td></tr>");
                }
            %>
        </tbody>
    </table>
    
    <br>
    <a href="../index.jsp" class="btn">🏠 На главную</a>
</div>

<!-- МОДАЛЬНОЕ ОКНО ДЛЯ РЕДАКТИРОВАНИЯ СОТРУДНИКА -->
<div id="editModal" class="modal">
    <div class="modal-content">
        <h3 style="color:#005bff;">✏️ Редактировать сотрудника</h3>
        <form method="post" action="employees.jsp">
            <input type="hidden" name="updateId" id="employeeId">
            <label>Должность:</label>
            <select name="newPosition" id="newPosition">
                <option value="">Выберите должность</option>
                <option value="Оператор возвратов">Оператор возвратов</option>
                <option value="Специалист по уценке">Специалист по уценке</option>
                <option value="Кладовщик">Кладовщик</option>
                <option value="Старший смены">Старший смены</option>
            </select>
            <label>Смена:</label>
            <select name="newShift" id="newShift">
                <option value="">Выберите смену</option>
                <option value="Дневная">Дневная</option>
                <option value="Ночная">Ночная</option>
            </select>
            <br><br>
            <button type="submit" class="btn">Сохранить</button>
            <button type="button" class="btn btn-danger" onclick="closeModal()">Отмена</button>
        </form>
    </div>
</div>

<script>
    function openModal(id, currentPosition, currentShift) {
        document.getElementById('employeeId').value = id;
        document.getElementById('newPosition').value = currentPosition;
        document.getElementById('newShift').value = currentShift;
        document.getElementById('editModal').style.display = 'flex';
    }
    function closeModal() {
        document.getElementById('editModal').style.display = 'none';
    }
    window.onclick = function(event) {
        if (event.target == document.getElementById('editModal')) {
            closeModal();
        }
    }
</script>
</body>
</html>