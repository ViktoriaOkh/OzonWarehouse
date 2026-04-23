<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, model.Cargo" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Грузы - Склад Ozon</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .cargo-card {
            background: white;
            border-radius: 20px;
            padding: 20px;
            margin-bottom: 15px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            transition: all 0.3s;
            box-shadow: 0 2px 5px rgba(0,0,0,0.05);
        }
        .cargo-card:hover {
            transform: translateX(5px);
            box-shadow: 0 5px 15px rgba(0,91,255,0.1);
        }
        .cargo-info { flex: 1; }
        .cargo-number { font-size: 18px; font-weight: bold; color: #005bff; }
        .cargo-details { color: #666; font-size: 13px; margin-top: 5px; }
        .cargo-stats { text-align: right; }
        .cargo-quantity { font-size: 24px; font-weight: bold; color: #ff6b35; }
        .profile-info {
            background: rgba(255,255,255,0.15);
            padding: 5px 15px;
            border-radius: 20px;
            display: inline-block;
        }
        .status-open { color: #28a745; font-weight: bold; }
    </style>
</head>
<body>

<div class="ozon-header">
    <div class="ozon-logo">
        <span>📦</span>
        <h1>Обработка возвратных постингов</h1>
    </div>
    <div class="ozon-nav">
        <a href="index.jsp">🏠 Главная</a>
        <a href="products">📦 Товары</a>
        <a href="employees">👥 Сотрудники</a>
        <a href="operations">📝 Операции</a>
        <a href="reports">📊 Отчеты</a>
        <a href="utilization">🗑️ Акт</a>
        <a href="processing" class="active">🔄 Обработка</a>
        <div class="profile-info">
            👤 <%= session.getAttribute("employeeName") != null ? session.getAttribute("employeeName") : "Гость" %>
        </div>
        <a href="logout" style="color: white; text-decoration: none; margin-left: 20px; padding: 8px 15px; border-radius: 10px; background: rgba(255,255,255,0.15);">🚪 Выйти</a>
    </div>
</div>

<div class="ozon-container">
    <h2>Активные грузы</h2>
    
    <%
        List<Cargo> cargos = (List<Cargo>) request.getAttribute("cargos");
        if (cargos != null && !cargos.isEmpty()) {
            for (Cargo c : cargos) {
    %>
    <div class="cargo-card">
        <div class="cargo-info">
            <div class="cargo-number"><%= c.getNumber() %></div>
            <div class="cargo-details">
                📅 Время поступления: <%= c.getReceiptTime() %><br>
                📍 Статус: <span class="status-open">Открыт</span>
            </div>
        </div>
        <div class="cargo-stats">
            <div class="cargo-quantity"><%= c.getQuantity() %></div>
            <div class="cargo-details">позиций</div>
            <a href="cargoProducts?cargoId=<%= c.getId() %>" class="ozon-btn" style="margin-top: 10px;">🔍 Открыть</a>
        </div>
    </div>
    <%
            }
        } else {
    %>
    <div class="ozon-card" style="text-align:center;">Нет активных грузов</div>
    <% } %>
    
    <a href="index.jsp" class="ozon-btn">🏠 На главную</a>
</div>

</body>
</html>