<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Товары - Склад Ozon</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #e6f0fa 0%, #fce4ec 100%);
            min-height: 100vh;
            padding: 20px;
        }
        .container {
            max-width: 1300px;
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
        .error {
            background: #f8d7da;
            color: #721c24;
            padding: 12px;
            border-radius: 10px;
            margin-bottom: 20px;
            border-left: 4px solid #dc3545;
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
        .form-group input {
            padding: 10px 15px;
            border: 1px solid #ddd;
            border-radius: 10px;
            width: 250px;
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
        .modal-content input {
            width: 100%;
            padding: 10px;
            margin: 10px 0;
            border: 1px solid #ddd;
            border-radius: 10px;
        }
        .modal-content label {
            font-weight: bold;
            color: #005bff;
        }
    </style>
</head>
<body>
<div class="container">
    <div class="header">
        <h1>📦 Управление товарами</h1>
        <div class="nav-links">
            <a href="../index.jsp">🏠 Главная</a>
            <a href="jsp/products.jsp">📦 Товары</a>
            <a href="employees.jsp">👥 Сотрудники</a>
            <a href="operations.jsp">📝 Операции</a>
            <a href="reports.jsp">📊 Отчеты</a>
            <a href="utilization.jsp">🗑️ Акт</a>
        </div>
    </div>
    
    <%
        String dbUrl = "jdbc:sqlite:C:/Users/Vikusya/Desktop/Склад_Ozon.db";
        
        // ========== ДОБАВЛЕНИЕ ТОВАРА ==========
        String action = request.getParameter("action");
        if ("add".equals(action)) {
            String article = request.getParameter("article");
            String name = request.getParameter("name");
            String category = request.getParameter("category");
            String supplier = request.getParameter("supplier");
            
            if (article != null && name != null) {
                try {
                    Class.forName("org.sqlite.JDBC");
                    Connection conn = DriverManager.getConnection(dbUrl);
                    PreparedStatement pstmt = conn.prepareStatement("INSERT INTO Товары (Артикул, Наименование, Категория, Поставщик) VALUES (?, ?, ?, ?)");
                    pstmt.setString(1, article);
                    pstmt.setString(2, name);
                    pstmt.setString(3, category);
                    pstmt.setString(4, supplier);
                    pstmt.executeUpdate();
                    pstmt.close();
                    conn.close();
                    out.println("<div class='success'>✅ Товар успешно добавлен!</div>");
                } catch (Exception e) {
                    out.println("<div class='error'>❌ Ошибка: " + e.getMessage() + "</div>");
                }
            }
        }
        
        // ========== УДАЛЕНИЕ ТОВАРА ==========
        String deleteId = request.getParameter("delete");
        if (deleteId != null) {
            try {
                Class.forName("org.sqlite.JDBC");
                Connection conn = DriverManager.getConnection(dbUrl);
                
                PreparedStatement pstmt1 = conn.prepareStatement("DELETE FROM Операции WHERE КодТовара = ?");
                pstmt1.setInt(1, Integer.parseInt(deleteId));
                pstmt1.executeUpdate();
                pstmt1.close();
                
                PreparedStatement pstmt2 = conn.prepareStatement("DELETE FROM Товары WHERE КодТовара = ?");
                pstmt2.setInt(1, Integer.parseInt(deleteId));
                pstmt2.executeUpdate();
                pstmt2.close();
                conn.close();
                out.println("<div class='success'>🗑️ Товар успешно удален!</div>");
            } catch (Exception e) {
                out.println("<div class='error'>❌ Ошибка: " + e.getMessage() + "</div>");
            }
        }
        
        // ========== ИЗМЕНЕНИЕ КАТЕГОРИИ ==========
        String updateId = request.getParameter("updateId");
        String newCategory = request.getParameter("newCategory");
        
        if (updateId != null && newCategory != null && !newCategory.trim().isEmpty()) {
            try {
                Class.forName("org.sqlite.JDBC");
                Connection conn = DriverManager.getConnection(dbUrl);
                PreparedStatement pstmt = conn.prepareStatement("UPDATE Товары SET Категория = ? WHERE КодТовара = ?");
                pstmt.setString(1, newCategory);
                pstmt.setInt(2, Integer.parseInt(updateId));
                int result = pstmt.executeUpdate();
                pstmt.close();
                conn.close();
                
                if (result > 0) {
                    out.println("<div class='success'>✏️ Категория товара успешно изменена!</div>");
                } else {
                    out.println("<div class='error'>❌ Товар не найден!</div>");
                }
            } catch (Exception e) {
                out.println("<div class='error'>❌ Ошибка: " + e.getMessage() + "</div>");
            }
        }
    %>
    
    <h2>➕ Добавить новый товар</h2>
    <form method="post" action="products.jsp">
        <input type="hidden" name="action" value="add">
        <div class="form-group">
            <label>Артикул:</label>
            <input type="text" name="article" required placeholder="Например: OZN-015">
        </div>
        <div class="form-group">
            <label>Наименование:</label>
            <input type="text" name="name" required>
        </div>
        <div class="form-group">
            <label>Категория:</label>
            <input type="text" name="category" placeholder="Электроника/Аксессуары">
        </div>
        <div class="form-group">
            <label>Поставщик:</label>
            <input type="text" name="supplier">
        </div>
        <button type="submit" class="btn">➕ Добавить товар</button>
    </form>
    
    <hr>
    
    <h2>📋 Список товаров</h2>
    <div style="overflow-x: auto;">
        <table>
            <thead>
                <tr>
                    <th>Код</th>
                    <th>Артикул</th>
                    <th>Наименование</th>
                    <th>Категория</th>
                    <th>Поставщик</th>
                    <th>Действия</th>
                </tr>
            </thead>
            <tbody>
                <%
                    try {
                        Class.forName("org.sqlite.JDBC");
                        Connection conn = DriverManager.getConnection(dbUrl);
                        Statement stmt = conn.createStatement();
                        ResultSet rs = stmt.executeQuery("SELECT КодТовара, Артикул, Наименование, Категория, Поставщик FROM Товары ORDER BY КодТовара");
                        
                        boolean hasData = false;
                        while (rs.next()) {
                            hasData = true;
                            int productId = rs.getInt("КодТовара");
                            String currentCategory = rs.getString("Категория");
                            currentCategory = (currentCategory != null) ? currentCategory : "";
                %>
                <tr>
                    <td><%= productId %></td>
                    <td><%= rs.getString("Артикул") %></td>
                    <td><%= rs.getString("Наименование") %></td>
                    <td><%= currentCategory %></td>
                    <td><%= rs.getString("Поставщик") != null ? rs.getString("Поставщик") : "—" %></td>
                    <td>
                        <button class="btn btn-sm" onclick='openModal(<%= productId %>, "<%= currentCategory %>")'>✏️ Категорию</button>
                        <a href="products.jsp?delete=<%= productId %>" class="btn btn-sm btn-danger" onclick="return confirm('Удалить товар?')">🗑️ Удалить</a>
                    </td>
                </tr>
                <%
                        }
                        rs.close();
                        stmt.close();
                        conn.close();
                        
                        if (!hasData) {
                %>
                <tr><td colspan="6" style="text-align: center;">Нет данных о товарах</td></tr>
                <%
                        }
                    } catch (Exception e) {
                        out.println("<tr><td colspan='6' style='text-align:center; color:red;'>Ошибка: " + e.getMessage() + "</td></tr>");
                    }
                %>
            </tbody>
        </table>
    </div>
    
    <br>
    <a href="../index.jsp" class="btn">🏠 На главную</a>
</div>

<!-- МОДАЛЬНОЕ ОКНО ДЛЯ ИЗМЕНЕНИЯ КАТЕГОРИИ -->
<div id="categoryModal" class="modal">
    <div class="modal-content">
        <h3 style="color:#005bff;">✏️ Изменить категорию</h3>
        <form method="post" action="products.jsp">
            <input type="hidden" name="updateId" id="productId">
            <label>Новая категория:</label>
            <input type="text" name="newCategory" id="categoryInput" required>
            <br><br>
            <button type="submit" class="btn">Сохранить</button>
            <button type="button" class="btn btn-danger" onclick="closeModal()">Отмена</button>
        </form>
    </div>
</div>

<script>
    function openModal(id, currentCategory) {
        document.getElementById('productId').value = id;
        document.getElementById('categoryInput').value = currentCategory;
        document.getElementById('categoryModal').style.display = 'flex';
    }
    
    function closeModal() {
        document.getElementById('categoryModal').style.display = 'none';
    }
    
    window.onclick = function(event) {
        if (event.target == document.getElementById('categoryModal')) {
            closeModal();
        }
    }
</script>

</body>
</html>