<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, model.Pallet" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Паллеты - Склад Ozon</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<div class="ozon-container">
    <div class="ozon-card">
        <h2>Активные паллеты</h2>
        
        <table class="ozon-table">
            <thead>
                <tr>
                    <th>Номер паллеты</th>
                    <th>Зона</th>
                    <th>Количество</th>
                    <th>Действие</th>
                </tr>
            </thead>
            <tbody>
                <%
                    List<Pallet> pallets = (List<Pallet>) request.getAttribute("pallets");
                    if (pallets != null && !pallets.isEmpty()) {
                        for (Pallet p : pallets) {
                %>
                <tr>
                    <td><a href="process?palletId=<%= p.getId() %>"><%= p.getNumber() %></a></td>
                    <td><%= p.getZone() %></td>
                    <td><%= p.getQuantity() %></td>
                    <td>
                        <form method="post" style="display:inline">
                            <input type="hidden" name="action" value="close">
                            <input type="hidden" name="palletId" value="<%= p.getId() %>">
                            <button class="ozon-btn">Закрыть</button>
                        </form>
                    </td>
                </tr>
                <%
                        }
                    } else {
                %>
                <tr><td colspan="4" style="text-align:center;">Нет открытых паллет</td></tr>
                <% } %>
            </tbody>
        </table>
        
        <br>
        <a href="index.jsp" class="ozon-btn">🏠 На главную</a>
    </div>
</div>
</body>
</html>