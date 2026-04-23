<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.text.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Акт утилизации - Склад Ozon</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #e6f0fa 0%, #fce4ec 100%);
            min-height: 100vh;
            padding: 20px;
        }
        .container { max-width: 1300px; margin: 0 auto; }
        .header {
            background: #005bff;
            padding: 20px 30px;
            border-radius: 20px;
            color: white;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            margin-bottom: 30px;
        }
        .logo { display: flex; align-items: center; gap: 15px; }
        .logo span { font-size: 32px; }
        .logo h1 { margin: 0; font-size: 24px; }
        .nav { display: flex; gap: 10px; flex-wrap: wrap; }
        .nav a {
            color: white;
            text-decoration: none;
            padding: 8px 15px;
            border-radius: 10px;
            transition: 0.3s;
        }
        .nav a:hover { background: rgba(255,255,255,0.2); }
        .btn {
            display: inline-block;
            padding: 8px 16px;
            background: #005bff;
            color: white;
            text-decoration: none;
            border: none;
            border-radius: 10px;
            cursor: pointer;
            font-size: 13px;
            transition: 0.3s;
        }
        .btn:hover { background: #ff6b35; }
        .btn-sm { padding: 5px 12px; font-size: 12px; }
        .btn-danger { background: #ff6b35; }
        .btn-danger:hover { background: #e55a2b; }
        .btn-add {
            background: #28a745;
            margin-bottom: 20px;
        }
        .btn-add:hover { background: #218838; }
        .btn-print {
            background: #28a745;
            margin-bottom: 20px;
            margin-right: 10px;
        }
        .btn-print:hover { background: #218838; }
        .success {
            background: #d4edda;
            color: #155724;
            padding: 12px;
            border-radius: 10px;
            margin-bottom: 20px;
            border-left: 4px solid #28a745;
        }
        .card {
            background: white;
            border-radius: 20px;
            padding: 25px;
            margin-bottom: 25px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
        }
        .form-group {
            margin-bottom: 15px;
            display: flex;
            align-items: center;
            flex-wrap: wrap;
            gap: 10px;
        }
        .form-group label {
            width: 120px;
            font-weight: bold;
            color: #005bff;
        }
        .form-group input, .form-group select {
            padding: 8px 12px;
            border: 1px solid #ddd;
            border-radius: 8px;
            width: 250px;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
            font-size: 14px;
        }
        th {
            background: #005bff;
            color: white;
            padding: 10px;
            border: 1px solid #ddd;
            text-align: left;
        }
        td {
            padding: 10px;
            border: 1px solid #ddd;
            text-align: left;
        }
        tr:nth-child(even) { background: #f9f9f9; }
        tr:hover { background: #fce4ec; }
        .total {
            margin-top: 20px;
            padding: 15px;
            background: #f8f9fa;
            border-radius: 10px;
            text-align: center;
            font-weight: bold;
            color: #005bff;
        }
        .signature {
            margin-top: 30px;
            padding-top: 20px;
            border-top: 1px solid #ddd;
        }
        .btn-home {
            display: inline-block;
            padding: 10px 25px;
            background: #005bff;
            color: white;
            text-decoration: none;
            border-radius: 10px;
            margin-top: 20px;
        }
        .btn-home:hover { background: #ff6b35; }
        .footer {
            text-align: center;
            padding: 20px;
            color: #999;
            font-size: 12px;
        }
        hr {
            margin: 20px 0;
            border: none;
            border-top: 2px solid #f0f2f5;
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
            width: 450px;
        }
        .modal-content input, .modal-content select {
            width: 100%;
            padding: 8px;
            margin: 8px 0;
            border: 1px solid #ddd;
            border-radius: 8px;
        }
        .action-buttons {
            display: flex;
            gap: 8px;
            flex-wrap: wrap;
        }
        .action-edit {
            background: #005bff;
            color: white;
            padding: 4px 10px;
            border-radius: 8px;
            text-decoration: none;
            font-size: 12px;
        }
        .action-edit:hover {
            background: #ff6b35;
        }
        .action-delete {
            background: #ff6b35;
            color: white;
            padding: 4px 10px;
            border-radius: 8px;
            text-decoration: none;
            font-size: 12px;
        }
        .action-delete:hover {
            background: #e55a2b;
        }
    </style>
</head>
<body>

<div class="container">
    <div class="header">
    <div class="logo">
        <span>🗑️</span>
        <h1>Акт утилизации товаров</h1>
    </div>
    <div class="nav">
        <a href="../index.jsp">🏠 Главная</a>
        <a href="products.jsp">📦 Товары</a>
        <a href="employees.jsp">👥 Сотрудники</a>
        <a href="operations.jsp">📝 Операции</a>
        <a href="reports.jsp">📊 Отчеты</a>
        <a href="utilization.jsp" class="active">🗑️ Акт</a>
    </div>
</div>

    <div class="card">
        <%
            String dbUrl = "jdbc:sqlite:C:/Users/Vikusya/Desktop/Склад_Ozon.db";
            int utilTypeId = 1; // Код типа операции "Утилизация"
            
            // ========== ДОБАВЛЕНИЕ ОПЕРАЦИИ УТИЛИЗАЦИИ ==========
            String action = request.getParameter("action");
            if ("add".equals(action)) {
                String date = request.getParameter("date");
                String productId = request.getParameter("productId");
                String employeeId = request.getParameter("employeeId");
                String quantity = request.getParameter("quantity");
                String reason = request.getParameter("reason");
                
                if (date != null && productId != null && employeeId != null) {
                    try {
                        Class.forName("org.sqlite.JDBC");
                        Connection conn = DriverManager.getConnection(dbUrl);
                        PreparedStatement pstmt = conn.prepareStatement(
                            "INSERT INTO Операции (Дата, КодТовара, КодСотрудника, КодТипа, Количество, Причина) VALUES (?, ?, ?, ?, ?, ?)"
                        );
                        pstmt.setString(1, date);
                        pstmt.setInt(2, Integer.parseInt(productId));
                        pstmt.setInt(3, Integer.parseInt(employeeId));
                        pstmt.setInt(4, utilTypeId);
                        pstmt.setInt(5, Integer.parseInt(quantity));
                        pstmt.setString(6, reason);
                        pstmt.executeUpdate();
                        pstmt.close();
                        conn.close();
                        out.println("<div class='success'>✅ Операция утилизации успешно добавлена!</div>");
                    } catch (Exception e) {
                        out.println("<div class='success' style='background:#f8d7da; color:#721c24;'>❌ Ошибка: " + e.getMessage() + "</div>");
                    }
                }
            }
            
            // ========== УДАЛЕНИЕ ОПЕРАЦИИ УТИЛИЗАЦИИ ==========
            String deleteId = request.getParameter("delete");
            if (deleteId != null) {
                try {
                    Class.forName("org.sqlite.JDBC");
                    Connection conn = DriverManager.getConnection(dbUrl);
                    PreparedStatement pstmt = conn.prepareStatement("DELETE FROM Операции WHERE КодОперации = ?");
                    pstmt.setInt(1, Integer.parseInt(deleteId));
                    pstmt.executeUpdate();
                    pstmt.close();
                    conn.close();
                    out.println("<div class='success'>🗑️ Операция утилизации успешно удалена!</div>");
                } catch (Exception e) {
                    out.println("<div class='success' style='background:#f8d7da; color:#721c24;'>❌ Ошибка: " + e.getMessage() + "</div>");
                }
            }
            
            // ========== ИЗМЕНЕНИЕ ОПЕРАЦИИ УТИЛИЗАЦИИ ==========
            String updateId = request.getParameter("updateId");
            String newDate = request.getParameter("newDate");
            String newProductId = request.getParameter("newProductId");
            String newEmployeeId = request.getParameter("newEmployeeId");
            String newQuantity = request.getParameter("newQuantity");
            String newReason = request.getParameter("newReason");
            
            if (updateId != null && newDate != null) {
                try {
                    Class.forName("org.sqlite.JDBC");
                    Connection conn = DriverManager.getConnection(dbUrl);
                    PreparedStatement pstmt = conn.prepareStatement(
                        "UPDATE Операции SET Дата = ?, КодТовара = ?, КодСотрудника = ?, Количество = ?, Причина = ? WHERE КодОперации = ? AND КодТипа = ?"
                    );
                    pstmt.setString(1, newDate);
                    pstmt.setInt(2, Integer.parseInt(newProductId));
                    pstmt.setInt(3, Integer.parseInt(newEmployeeId));
                    pstmt.setInt(4, Integer.parseInt(newQuantity));
                    pstmt.setString(5, newReason);
                    pstmt.setInt(6, Integer.parseInt(updateId));
                    pstmt.setInt(7, utilTypeId);
                    pstmt.executeUpdate();
                    pstmt.close();
                    conn.close();
                    out.println("<div class='success'>✏️ Операция утилизации успешно обновлена!</div>");
                } catch (Exception e) {
                    out.println("<div class='success' style='background:#f8d7da; color:#721c24;'>❌ Ошибка: " + e.getMessage() + "</div>");
                }
            }
            
            // ========== ПОЛУЧЕНИЕ ДАННЫХ ДЛЯ РЕДАКТИРОВАНИЯ ==========
            String editId = request.getParameter("edit");
            if (editId != null) {
                try {
                    Class.forName("org.sqlite.JDBC");
                    Connection conn = DriverManager.getConnection(dbUrl);
                    PreparedStatement pstmt = conn.prepareStatement(
                        "SELECT o.КодОперации, o.Дата, o.КодТовара, o.КодСотрудника, o.Количество, o.Причина FROM Операции o WHERE o.КодОперации = ? AND o.КодТипа = ?"
                    );
                    pstmt.setInt(1, Integer.parseInt(editId));
                    pstmt.setInt(2, utilTypeId);
                    ResultSet rs = pstmt.executeQuery();
                    if (rs.next()) {
        %>
        
        <!-- МОДАЛЬНОЕ ОКНО РЕДАКТИРОВАНИЯ -->
        <div id="editModal" class="modal" style="display: flex;">
            <div class="modal-content">
                <h3 style="color:#005bff;">✏️ Редактировать операцию утилизации</h3>
                <form method="post" action="utilization.jsp">
                    <input type="hidden" name="updateId" value="<%= rs.getInt("КодОперации") %>">
                    <label>Дата:</label>
                    <input type="date" name="newDate" value="<%= rs.getString("Дата") %>" required>
                    
                    <label>Товар:</label>
                    <select name="newProductId" required>
                        <%
                            Statement stmt2 = conn.createStatement();
                            ResultSet rs2 = stmt2.executeQuery("SELECT КодТовара, Артикул, Наименование FROM Товары ORDER BY Артикул");
                            int currentProductId = rs.getInt("КодТовара");
                            while (rs2.next()) {
                                String selected = (rs2.getInt("КодТовара") == currentProductId) ? "selected" : "";
                                out.println("<option value='" + rs2.getInt("КодТовара") + "' " + selected + ">" + rs2.getString("Артикул") + " - " + rs2.getString("Наименование") + "</option>");
                            }
                            rs2.close();
                            stmt2.close();
                        %>
                    </select>
                    
                    <label>Сотрудник:</label>
                    <select name="newEmployeeId" required>
                        <%
                            Statement stmt3 = conn.createStatement();
                            ResultSet rs3 = stmt3.executeQuery("SELECT КодСотрудника, ФИО FROM Сотрудники ORDER BY ФИО");
                            int currentEmployeeId = rs.getInt("КодСотрудника");
                            while (rs3.next()) {
                                String selected = (rs3.getInt("КодСотрудника") == currentEmployeeId) ? "selected" : "";
                                out.println("<option value='" + rs3.getInt("КодСотрудника") + "' " + selected + ">" + rs3.getString("ФИО") + "</option>");
                            }
                            rs3.close();
                            stmt3.close();
                        %>
                    </select>
                    
                    <label>Количество:</label>
                    <input type="number" name="newQuantity" value="<%= rs.getInt("Количество") %>" required>
                    
                    <label>Причина утилизации:</label>
                    <input type="text" name="newReason" value="<%= rs.getString("Причина") != null ? rs.getString("Причина") : "" %>">
                    
                    <br><br>
                    <button type="submit" class="btn">Сохранить</button>
                    <a href="utilization.jsp" class="btn btn-danger">Отмена</a>
                </form>
            </div>
        </div>
        <%
                    }
                    rs.close();
                    pstmt.close();
                    conn.close();
                } catch (Exception e) {
                    out.println("<p style='color:red;'>Ошибка: " + e.getMessage() + "</p>");
                }
            }
        %>
        
        <!-- КНОПКИ ДЕЙСТВИЙ -->
        <div style="margin-bottom: 20px;">
            <button class="btn btn-add" onclick="openAddModal()">➕ Добавить утилизацию</button>
            <button class="btn btn-print" onclick="window.print()">🖨️ Печать акта</button>
        </div>
        
        <%
            // ВЫВОД ТАБЛИЦЫ УТИЛИЗАЦИИ
            try {
                Class.forName("org.sqlite.JDBC");
                Connection conn = DriverManager.getConnection(dbUrl);
                Statement stmt = conn.createStatement();
                
                String sql = "SELECT o.КодОперации, o.Дата, t.Артикул, t.Наименование, t.Категория, s.ФИО, o.Причина, o.Количество " +
                             "FROM Операции o " +
                             "LEFT JOIN Товары t ON o.КодТовара = t.КодТовара " +
                             "LEFT JOIN Сотрудники s ON o.КодСотрудника = s.КодСотрудника " +
                             "WHERE o.КодТипа = " + utilTypeId + " " +
                             "ORDER BY o.Дата DESC";
                
                ResultSet rs = stmt.executeQuery(sql);
        %>
        
        <div style="overflow-x: auto;">
            <table>
                <thead>
                    <tr>
                        <th>№</th><th>Дата</th><th>Артикул</th><th>Наименование товара</th><th>Категория</th><th>Кол-во</th><th>Причина утилизации</th><th>Ответственный</th><th>Действия</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        int count = 0;
                        int totalQty = 0;
                        int rowNum = 1;
                        while (rs.next()) {
                            count++;
                            totalQty += rs.getInt("Количество");
                            int opId = rs.getInt("КодОперации");
                    %>
                    <tr>
                        <td><%= rowNum++ %></td>
                        <td><%= rs.getString("Дата") %></td>
                        <td><%= rs.getString("Артикул") != null ? rs.getString("Артикул") : "—" %></td>
                        <td><%= rs.getString("Наименование") != null ? rs.getString("Наименование") : "—" %></td>
                        <td><%= rs.getString("Категория") != null ? rs.getString("Категория") : "—" %></td>
                        <td><%= rs.getInt("Количество") %></td>
                        <td><%= rs.getString("Причина") != null ? rs.getString("Причина") : "—" %></td>
                        <td><%= rs.getString("ФИО") != null ? rs.getString("ФИО") : "—" %></td>
                        <td class="action-buttons">
                            <a href="utilization.jsp?edit=<%= opId %>" class="action-edit">✏️ Редактировать</a>
                            <a href="utilization.jsp?delete=<%= opId %>" class="action-delete" onclick="return confirm('Удалить операцию утилизации?')">🗑️ Удалить</a>
                        </td>
                    </tr>
                    <%
                        }
                    %>
                </tbody>
            </table>
        </div>
        
        <div class="total">
            📊 ИТОГО: утилизировано <%= count %> позиций, общим количеством <%= totalQty %> единиц
        </div>
        
        <div class="signature">
            <p>Дата составления акта: <%= new SimpleDateFormat("dd.MM.yyyy").format(new java.util.Date()) %></p>
            <p>Подпись ответственного лица: _________________</p>
        </div>
        
        <%
                rs.close();
                stmt.close();
                conn.close();
            } catch (Exception e) {
                out.println("<p style='color:red;'>Ошибка: " + e.getMessage() + "</p>");
            }
        %>
        
        <a href="../index.jsp" class="btn-home">🏠 На главную</a>
    </div>
</div>

<!-- МОДАЛЬНОЕ ОКНО ДЛЯ ДОБАВЛЕНИЯ ОПЕРАЦИИ УТИЛИЗАЦИИ -->
<div id="addModal" class="modal">
    <div class="modal-content">
        <h3 style="color:#005bff;">➕ Добавить операцию утилизации</h3>
        <form method="post" action="utilization.jsp">
            <input type="hidden" name="action" value="add">
            <label>Дата:</label>
            <input type="date" name="date" required>
            
            <label>Товар:</label>
            <select name="productId" required>
                <option value="">Выберите товар</option>
                <%
                    try {
                        Class.forName("org.sqlite.JDBC");
                        Connection conn = DriverManager.getConnection(dbUrl);
                        Statement stmt = conn.createStatement();
                        ResultSet rs = stmt.executeQuery("SELECT КодТовара, Артикул, Наименование FROM Товары ORDER BY Артикул");
                        while (rs.next()) {
                            out.println("<option value='" + rs.getInt("КодТовара") + "'>" + rs.getString("Артикул") + " - " + rs.getString("Наименование") + "</option>");
                        }
                        rs.close();
                        stmt.close();
                        conn.close();
                    } catch (Exception e) {}
                %>
            </select>
            
            <label>Сотрудник:</label>
            <select name="employeeId" required>
                <option value="">Выберите сотрудника</option>
                <%
                    try {
                        Class.forName("org.sqlite.JDBC");
                        Connection conn = DriverManager.getConnection(dbUrl);
                        Statement stmt = conn.createStatement();
                        ResultSet rs = stmt.executeQuery("SELECT КодСотрудника, ФИО FROM Сотрудники ORDER BY ФИО");
                        while (rs.next()) {
                            out.println("<option value='" + rs.getInt("КодСотрудника") + "'>" + rs.getString("ФИО") + "</option>");
                        }
                        rs.close();
                        stmt.close();
                        conn.close();
                    } catch (Exception e) {}
                %>
            </select>
            
            <label>Количество:</label>
            <input type="number" name="quantity" value="1" required>
            
            <label>Причина утилизации:</label>
            <input type="text" name="reason" placeholder="Причина утилизации">
            
            <br><br>
            <button type="submit" class="btn">Сохранить</button>
            <button type="button" class="btn btn-danger" onclick="closeAddModal()">Отмена</button>
        </form>
    </div>
</div>

<script>
    function openAddModal() {
        document.getElementById('addModal').style.display = 'flex';
    }
    function closeAddModal() {
        document.getElementById('addModal').style.display = 'none';
    }
    window.onclick = function(event) {
        var addModal = document.getElementById('addModal');
        if (event.target == addModal) {
            closeAddModal();
        }
        var editModal = document.getElementById('editModal');
        if (event.target == editModal) {
            if (editModal) editModal.style.display = 'none';
        }
    }
</script>

<div class="footer">
    Учет возвратов Ozon © 2026 | Участок возвратов | Производственная практика
</div>

</body>
</html>