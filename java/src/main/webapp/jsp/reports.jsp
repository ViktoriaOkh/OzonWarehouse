<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Отчеты - Склад Ozon</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #e6f0fa 0%, #fce4ec 100%);
            min-height: 100vh;
            padding: 20px;
        }
        .container { max-width: 1200px; margin: 0 auto; }
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
            box-shadow: 0 5px 15px rgba(0, 91, 255, 0.3);
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
        .nav a.active { background: rgba(255,255,255,0.25); }
        .card {
            background: white;
            border-radius: 20px;
            padding: 25px;
            margin-bottom: 25px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
        }
        h2 {
            color: #005bff;
            margin: 25px 0 15px 0;
            font-size: 1.4em;
        }
        .stats-grid {
            display: flex;
            gap: 20px;
            flex-wrap: wrap;
            margin-bottom: 30px;
            justify-content: center;
        }
        .stat-card {
            background: linear-gradient(135deg, #f8f9fa 0%, #fff 100%);
            padding: 25px 35px;
            border-radius: 20px;
            text-align: center;
            min-width: 150px;
            box-shadow: 0 3px 10px rgba(0,0,0,0.05);
            transition: transform 0.3s;
        }
        .stat-card:hover {
            transform: translateY(-5px);
        }
        .stat-number {
            font-size: 36px;
            font-weight: bold;
            color: #ff6b35;
        }
        .stat-label {
            color: #666;
            font-size: 14px;
            margin-top: 8px;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 15px;
        }
        th {
            background: #005bff;
            color: white;
            padding: 12px;
            border: 1px solid #ddd;
            text-align: left;
        }
        td {
            padding: 12px;
            border: 1px solid #ddd;
            text-align: left;
        }
        tr:nth-child(even) {
            background: #f9f9f9;
        }
        tr:hover {
            background: #fce4ec;
        }
        .btn-home {
            display: inline-block;
            padding: 10px 25px;
            background: #005bff;
            color: white;
            text-decoration: none;
            border-radius: 10px;
            margin-top: 20px;
            transition: 0.3s;
        }
        .btn-home:hover {
            background: #ff6b35;
        }
        .footer {
            text-align: center;
            padding: 20px;
            color: #999;
            font-size: 12px;
            margin-top: 20px;
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
    </style>
</head>
<body>

<div class="container">
    <div class="header">
        <div class="logo">
            <span>📊</span>
            <h1>Отчеты и статистика</h1>
        </div>
        <div class="nav">
            <a href="../index.jsp">🏠 Главная</a>
            <a href="products.jsp">📦 Товары</a>
            <a href="employees.jsp">👥 Сотрудники</a>
            <a href="operations.jsp">📝 Операции</a>
            <a href="reports.jsp" class="active">📊 Отчеты</a>
            <a href="utilization.jsp">🗑️ Акт</a>
        </div>
    </div>

    <div class="card">
        <%
            String url = "jdbc:sqlite:C:/Users/Vikusya/Desktop/Склад_Ozon.db";
            try {
                Class.forName("org.sqlite.JDBC");
                Connection conn = DriverManager.getConnection(url);
                Statement stmt = conn.createStatement();
                
                // ОБЩАЯ СТАТИСТИКА
                ResultSet rs = stmt.executeQuery("SELECT COUNT(*) as total FROM Операции");
                int totalOps = rs.next() ? rs.getInt("total") : 0;
                rs = stmt.executeQuery("SELECT COUNT(*) as total FROM Товары");
                int totalProducts = rs.next() ? rs.getInt("total") : 0;
                rs = stmt.executeQuery("SELECT COUNT(*) as total FROM Сотрудники");
                int totalEmployees = rs.next() ? rs.getInt("total") : 0;
        %>
        
        <h2>📈 Общая статистика</h2>
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-number"><%= totalOps %></div>
                <div class="stat-label">Операций</div>
            </div>
            <div class="stat-card">
                <div class="stat-number"><%= totalProducts %></div>
                <div class="stat-label">Товаров</div>
            </div>
            <div class="stat-card">
                <div class="stat-number"><%= totalEmployees %></div>
                <div class="stat-label">Сотрудников</div>
            </div>
        </div>
        
        <h2>📋 Статистика по типам операций</h2>
        <table>
            <thead>
                <tr><th>Тип операции</th><th>Количество операций</th><th>Общий объем</th></tr>
            </thead>
            <tbody>
            <%
                rs = stmt.executeQuery("SELECT tp.Название, COUNT(*) as Количество, SUM(o.Количество) as Объем FROM Операции o LEFT JOIN ТипыОпераций tp ON o.КодТипа = tp.КодТипа GROUP BY tp.Название ORDER BY Количество DESC");
                while (rs.next()) {
                    String name = rs.getString("Название");
                    if (name == null) name = "Неизвестный";
                    int count = rs.getInt("Количество");
                    int volume = rs.getInt("Объем");
                    String badgeClass = "";
                    if (name.equals("Утилизация")) badgeClass = "badge-util";
                    else if (name.equals("Уценка")) badgeClass = "badge-ucenka";
                    else if (name.equals("Пересорт")) badgeClass = "badge-peresort";
                    else if (name.equals("Возврат клиенту")) badgeClass = "badge-return";
                    else badgeClass = "badge-supplier";
            %>
                <tr>
                    <td><span class="badge <%= badgeClass %>"><%= name %></span></td>
                    <td><%= count %></td>
                    <td><%= volume %></td>
                </tr>
            <% } %>
            </tbody>
        </table>
        
        <h2>📁 Товары по категориям</h2>
        <table>
            <thead><tr><th>Категория</th><th>Количество товаров</th></tr></thead>
            <tbody>
            <%
                rs = stmt.executeQuery("SELECT Категория, COUNT(*) as Количество FROM Товары GROUP BY Категория ORDER BY Количество DESC");
                while (rs.next()) {
                    String category = rs.getString("Категория");
                    if (category == null) category = "Без категории";
            %>
                <tr><td><%= category %></td><td><%= rs.getInt("Количество") %></td></tr>
            <% } %>
            </tbody>
        </table>
        
        <h2>🏆 Топ-5 товаров по операциям</h2>
        <table>
            <thead><tr><th>Артикул</th><th>Наименование</th><th>Кол-во операций</th></tr></thead>
            <tbody>
            <%
                rs = stmt.executeQuery("SELECT t.Артикул, t.Наименование, COUNT(*) as Количество FROM Операции o LEFT JOIN Товары t ON o.КодТовара = t.КодТовара GROUP BY t.КодТовара ORDER BY Количество DESC LIMIT 5");
                while (rs.next()) {
                    String article = rs.getString("Артикул");
                    String name = rs.getString("Наименование");
                    if (article == null) article = "—";
                    if (name == null) name = "Товар удален";
            %>
                <tr><td><%= article %></td><td><%= name %></td><td><%= rs.getInt("Количество") %></td></tr>
            <% } %>
            </tbody>
        </table>
        
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

<div class="footer">
    Учет возвратов Ozon © 2026 | Участок возвратов | Производственная практика
</div>

</body>
</html>