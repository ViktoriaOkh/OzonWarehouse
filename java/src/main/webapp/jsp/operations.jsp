<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Операции - Склад Ozon</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #e6f0fa 0%, #fce4ec 100%);
            min-height: 100vh;
            padding: 20px;
        }
        .container { max-width: 1400px; margin: 0 auto; }
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
        .card {
            background: white;
            border-radius: 20px;
            padding: 25px;
            margin-bottom: 25px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
        }
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
        .success {
            background: #d4edda;
            color: #155724;
            padding: 12px;
            border-radius: 10px;
            margin-bottom: 20px;
            border-left: 4px solid #28a745;
        }
        .stats {
            display: flex;
            gap: 15px;
            flex-wrap: wrap;
            margin-bottom: 20px;
        }
        .stat-card {
            background: #f8f9fa;
            padding: 15px 25px;
            border-radius: 15px;
            text-align: center;
            min-width: 120px;
        }
        .stat-card .count {
            font-size: 28px;
            font-weight: bold;
            color: #ff6b35;
        }
        .badge {
            display: inline-block;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: bold;
        }
        .badge-util { background: #ff6b35; color: white; }
        .badge-ucenka { background: #005bff; color: white; }
        .badge-peresort { background: #17a2b8; color: white; }
        .badge-return { background: #28a745; color: white; }
        .badge-supplier { background: #6c757d; color: white; }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 15px;
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
        .action-buttons a {
            text-decoration: none;
            padding: 4px 10px;
            border-radius: 8px;
            font-size: 12px;
        }
        .action-edit {
            background: #005bff;
            color: white;
        }
        .action-edit:hover {
            background: #ff6b35;
        }
        .action-delete {
            background: #ff6b35;
            color: white;
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
            <span>📝</span>
            <h1>Журнал операций</h1>
        </div>
        <div class="nav">
            <a href="../index.jsp">🏠 Главная</a>
            <a href="products.jsp">📦 Товары</a>
            <a href="employees.jsp">👥 Сотрудники</a>
            <a href="operations.jsp" class="active">📝 Операции</a>
            <a href="reports.jsp">📊 Отчеты</a>
            <a href="utilization.jsp">🗑️ Акт</a>
        </div>
    </div>

    <div class="card">
        <%
            String dbUrl = "jdbc:sqlite:C:/Users/Vikusya/Desktop/Склад_Ozon.db";
            
            // ========== ДОБАВЛЕНИЕ ОПЕРАЦИИ ==========
            String action = request.getParameter("action");
            if ("add".equals(action)) {
                String date = request.getParameter("date");
                String productId = request.getParameter("productId");
                String employeeId = request.getParameter("employeeId");
                String operationTypeId = request.getParameter("operationTypeId");
                String quantity = request.getParameter("quantity");
                String reason = request.getParameter("reason");
                
                if (date != null && productId != null && employeeId != null && operationTypeId != null) {
                    try {
                        Class.forName("org.sqlite.JDBC");
                        Connection conn = DriverManager.getConnection(dbUrl);
                        PreparedStatement pstmt = conn.prepareStatement(
                            "INSERT INTO Операции (Дата, КодТовара, КодСотрудника, КодТипа, Количество, Причина) VALUES (?, ?, ?, ?, ?, ?)"
                        );
                        pstmt.setString(1, date);
                        pstmt.setInt(2, Integer.parseInt(productId));
                        pstmt.setInt(3, Integer.parseInt(employeeId));
                        pstmt.setInt(4, Integer.parseInt(operationTypeId));
                        pstmt.setInt(5, Integer.parseInt(quantity));
                        pstmt.setString(6, reason);
                        pstmt.executeUpdate();
                        pstmt.close();
                        conn.close();
                        out.println("<div class='success'>✅ Операция успешно добавлена!</div>");
                    } catch (Exception e) {
                        out.println("<div class='success' style='background:#f8d7da; color:#721c24;'>❌ Ошибка: " + e.getMessage() + "</div>");
                    }
                }
            }
            
            // ========== УДАЛЕНИЕ ОПЕРАЦИИ ==========
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
                    out.println("<div class='success'>🗑️ Операция успешно удалена!</div>");
                } catch (Exception e) {
                    out.println("<div class='success' style='background:#f8d7da; color:#721c24;'>❌ Ошибка: " + e.getMessage() + "</div>");
                }
            }
            
            // ========== ИЗМЕНЕНИЕ ОПЕРАЦИИ ==========
            String updateId = request.getParameter("updateId");
            String newDate = request.getParameter("newDate");
            String newProductId = request.getParameter("newProductId");
            String newEmployeeId = request.getParameter("newEmployeeId");
            String newOperationTypeId = request.getParameter("newOperationTypeId");
            String newQuantity = request.getParameter("newQuantity");
            String newReason = request.getParameter("newReason");
            
            if (updateId != null && newDate != null) {
                try {
                    Class.forName("org.sqlite.JDBC");
                    Connection conn = DriverManager.getConnection(dbUrl);
                    PreparedStatement pstmt = conn.prepareStatement(
                        "UPDATE Операции SET Дата = ?, КодТовара = ?, КодСотрудника = ?, КодТипа = ?, Количество = ?, Причина = ? WHERE КодОперации = ?"
                    );
                    pstmt.setString(1, newDate);
                    pstmt.setInt(2, Integer.parseInt(newProductId));
                    pstmt.setInt(3, Integer.parseInt(newEmployeeId));
                    pstmt.setInt(4, Integer.parseInt(newOperationTypeId));
                    pstmt.setInt(5, Integer.parseInt(newQuantity));
                    pstmt.setString(6, newReason);
                    pstmt.setInt(7, Integer.parseInt(updateId));
                    pstmt.executeUpdate();
                    pstmt.close();
                    conn.close();
                    out.println("<div class='success'>✏️ Операция успешно обновлена!</div>");
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
                        "SELECT o.КодОперации, o.Дата, o.КодТовара, o.КодСотрудника, o.КодТипа, o.Количество, o.Причина FROM Операции o WHERE o.КодОперации = ?"
                    );
                    pstmt.setInt(1, Integer.parseInt(editId));
                    ResultSet rs = pstmt.executeQuery();
                    if (rs.next()) {
        %>
        
        <!-- МОДАЛЬНОЕ ОКНО РЕДАКТИРОВАНИЯ -->
        <div id="editModal" class="modal" style="display: flex;">
            <div class="modal-content">
                <h3 style="color:#005bff;">✏️ Редактировать операцию</h3>
                <form method="post" action="operations.jsp">
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
                    
                    <label>Тип операции:</label>
                    <select name="newOperationTypeId" required>
                        <%
                            Statement stmt4 = conn.createStatement();
                            ResultSet rs4 = stmt4.executeQuery("SELECT КодТипа, Название FROM ТипыОпераций ORDER BY КодТипа");
                            int currentTypeId = rs.getInt("КодТипа");
                            while (rs4.next()) {
                                String selected = (rs4.getInt("КодТипа") == currentTypeId) ? "selected" : "";
                                out.println("<option value='" + rs4.getInt("КодТипа") + "' " + selected + ">" + rs4.getString("Название") + "</option>");
                            }
                            rs4.close();
                            stmt4.close();
                        %>
                    </select>
                    
                    <label>Количество:</label>
                    <input type="number" name="newQuantity" value="<%= rs.getInt("Количество") %>" required>
                    
                    <label>Причина:</label>
                    <input type="text" name="newReason" value="<%= rs.getString("Причина") != null ? rs.getString("Причина") : "" %>">
                    
                    <br><br>
                    <button type="submit" class="btn">Сохранить</button>
                    <a href="operations.jsp" class="btn btn-danger">Отмена</a>
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
        
        <!-- КНОПКА ДОБАВЛЕНИЯ -->
        <button class="btn btn-add" onclick="openAddModal()">➕ Добавить операцию</button>
        
        <%
            // СТАТИСТИКА
            Map<String, Integer> statistics = new LinkedHashMap<>();
            try {
                Class.forName("org.sqlite.JDBC");
                Connection conn = DriverManager.getConnection(dbUrl);
                Statement stmt = conn.createStatement();
                
                ResultSet rs = stmt.executeQuery("SELECT tp.Название, COUNT(*) as Количество FROM Операции o LEFT JOIN ТипыОпераций tp ON o.КодТипа = tp.КодТипа GROUP BY tp.Название ORDER BY Количество DESC");
                while (rs.next()) {
                    String name = rs.getString("Название");
                    if (name == null) name = "Неизвестный";
                    statistics.put(name, rs.getInt("Количество"));
                }
                rs.close();
                
                out.println("<div class='stats'>");
                for (Map.Entry<String, Integer> entry : statistics.entrySet()) {
                    String type = entry.getKey();
                    int count = entry.getValue();
                    String badgeClass = "";
                    if (type.equals("Утилизация")) badgeClass = "badge-util";
                    else if (type.equals("Уценка")) badgeClass = "badge-ucenka";
                    else if (type.equals("Пересорт")) badgeClass = "badge-peresort";
                    else if (type.equals("Возврат клиенту")) badgeClass = "badge-return";
                    else badgeClass = "badge-supplier";
                    out.println("<div class='stat-card'>");
                    out.println("<div><span class='badge " + badgeClass + "'>" + type + "</span></div>");
                    out.println("<div class='count'>" + count + "</div>");
                    out.println("<div>операций</div>");
                    out.println("</div>");
                }
                out.println("</div>");
                
                // ТАБЛИЦА ОПЕРАЦИЙ
                String sql = "SELECT o.КодОперации, o.Дата, t.Артикул, t.Наименование, s.ФИО, tp.Название as ТипОперации, o.Количество, o.Причина " +
                             "FROM Операции o " +
                             "LEFT JOIN Товары t ON o.КодТовара = t.КодТовара " +
                             "LEFT JOIN Сотрудники s ON o.КодСотрудника = s.КодСотрудника " +
                             "LEFT JOIN ТипыОпераций tp ON o.КодТипа = tp.КодТипа " +
                             "ORDER BY o.Дата DESC";
                
                rs = stmt.executeQuery(sql);
                
                out.println("<div style='overflow-x: auto;'>");
                out.println("<table>");
                out.println("<thead>");
                out.println("<tr>");
                out.println("<th>ID</th><th>Дата</th><th>Артикул</th><th>Товар</th><th>Сотрудник</th><th>Тип</th><th>Кол-во</th><th>Причина</th><th>Действия</th>");
                out.println("</tr>");
                out.println("</thead>");
                out.println("<tbody>");
                
                int countRows = 0;
                while (rs.next()) {
                    countRows++;
                    String type = rs.getString("ТипОперации");
                    String badgeClass = "";
                    if (type != null) {
                        if (type.equals("Утилизация")) badgeClass = "badge-util";
                        else if (type.equals("Уценка")) badgeClass = "badge-ucenka";
                        else if (type.equals("Пересорт")) badgeClass = "badge-peresort";
                        else if (type.equals("Возврат клиенту")) badgeClass = "badge-return";
                        else badgeClass = "badge-supplier";
                    }
                    int opId = rs.getInt("КодОперации");
                    out.println("<tr>");
                    out.println("<td>" + opId + "</td>");
                    out.println("<td>" + rs.getString("Дата") + "</td>");
                    out.println("<td>" + (rs.getString("Артикул") != null ? rs.getString("Артикул") : "—") + "</td>");
                    out.println("<td>" + (rs.getString("Наименование") != null ? rs.getString("Наименование") : "—") + "</td>");
                    out.println("<td>" + (rs.getString("ФИО") != null ? rs.getString("ФИО") : "—") + "</td>");
                    out.println("<td><span class='badge " + badgeClass + "'>" + (type != null ? type : "—") + "</span></td>");
                    out.println("<td>" + rs.getInt("Количество") + "</td>");
                    out.println("<td>" + (rs.getString("Причина") != null ? rs.getString("Причина") : "—") + "</td>");
                    out.println("<td class='action-buttons'>");
                    out.println("<a href='operations.jsp?edit=" + opId + "' class='action-edit'>✏️ Редактировать</a>");
                    out.println("<a href='operations.jsp?delete=" + opId + "' class='action-delete' onclick='return confirm(\"Удалить операцию?\")'>🗑️ Удалить</a>");
                    out.println("</td>");
                    out.println("</tr>");
                }
                out.println("</tbody>");
                out.println("</table>");
                out.println("</div>");
                out.println("<div class='total'>📊 Всего операций: " + countRows + "</div>");
                
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

<!-- МОДАЛЬНОЕ ОКНО ДЛЯ ДОБАВЛЕНИЯ ОПЕРАЦИИ -->
<div id="addModal" class="modal">
    <div class="modal-content">
        <h3 style="color:#005bff;">➕ Добавить операцию</h3>
        <form method="post" action="operations.jsp">
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
            
            <label>Тип операции:</label>
            <select name="operationTypeId" required>
                <option value="">Выберите тип</option>
                <%
                    try {
                        Class.forName("org.sqlite.JDBC");
                        Connection conn = DriverManager.getConnection(dbUrl);
                        Statement stmt = conn.createStatement();
                        ResultSet rs = stmt.executeQuery("SELECT КодТипа, Название FROM ТипыОпераций ORDER BY КодТипа");
                        while (rs.next()) {
                            out.println("<option value='" + rs.getInt("КодТипа") + "'>" + rs.getString("Название") + "</option>");
                        }
                        rs.close();
                        stmt.close();
                        conn.close();
                    } catch (Exception e) {}
                %>
            </select>
            
            <label>Количество:</label>
            <input type="number" name="quantity" value="1" required>
            
            <label>Причина:</label>
            <input type="text" name="reason" placeholder="Причина операции">
            
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
    }
</script>

<div class="footer">
    Учет возвратов Ozon © 2026 | Участок возвратов | Производственная практика
</div>

</body>
</html>