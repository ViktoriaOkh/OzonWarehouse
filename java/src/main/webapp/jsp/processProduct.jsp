<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Cargo" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Обработка товара</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .product-card {
            background: #f8f9fa;
            border-radius: 20px;
            padding: 25px;
            margin-bottom: 20px;
            text-align: center;
        }
        .product-title {
            font-size: 24px;
            font-weight: bold;
            color: #005bff;
            margin-bottom: 10px;
        }
        .action-buttons {
            display: flex;
            gap: 15px;
            justify-content: center;
            margin: 20px 0;
        }
        .action-btn {
            padding: 12px 25px;
            font-size: 16px;
            border-radius: 15px;
        }
        .btn-util { background: #dc3545; }
        .btn-ucenka { background: #ffc107; color: #333; }
        .btn-peresort { background: #17a2b8; }
        .scan-input {
            font-size: 18px;
            text-align: center;
            letter-spacing: 2px;
        }
        .cargo-info-bar {
            background: #e6f0fa;
            padding: 12px 20px;
            border-radius: 15px;
            margin-bottom: 20px;
            display: flex;
            justify-content: space-between;
        }
    </style>
</head>
<body>

<div class="ozon-header">
    <div class="ozon-logo">
        <span>🔄</span>
        <h1>Обработка груза</h1>
    </div>
    <div class="ozon-nav">
        <a href="index.jsp">🏠 Главная</a>
        <a href="processing" class="active">📦 Грузы</a>
        <div class="profile-info" style="background:rgba(255,255,255,0.15); padding:5px 15px; border-radius:20px;">
            👤 <%= session.getAttribute("employeeName") != null ? session.getAttribute("employeeName") : "Гость" %>
        </div>
    </div>
</div>

<div class="ozon-container">
    <%
        Cargo cargo = (Cargo) request.getAttribute("cargo");
        if (cargo != null) {
    %>
    <div class="cargo-info-bar">
        <span><strong>📦 Груз:</strong> <%= cargo.getNumber() %></span>
        <span><strong>📅 Время:</strong> <%= cargo.getReceiptTime() %></span>
        <span><strong>📊 Позиций:</strong> <%= cargo.getQuantity() %></span>
    </div>
    <% } %>
    
    <div class="ozon-card">
        <div class="product-card">
            <div class="product-title">ПОДХВАТ ДЛЯ ШТОР НА МАГНИТАХ</div>
            <div class="product-details">
                <p>Артикул: <strong id="productArticle">—</strong></p>
                <p>Наименование: <strong id="productName">—</strong></p>
            </div>
        </div>
        
        <form method="post" id="scanForm">
            <input type="hidden" name="cargoId" value="<%= request.getAttribute("cargoId") %>">
            <input type="hidden" name="action" id="actionInput">
            <input type="hidden" name="barcode" id="barcodeInput">
            
            <label>🔍 Сканируйте штрихкод товара:</label>
            <input type="text" id="scannerInput" class="ozon-form-group scan-input" autofocus placeholder="OZN-001 или другой артикул">
        </form>
        
        <div class="action-buttons">
            <button class="ozon-btn action-btn btn-util" onclick="submitAction('utilit')">🗑 Утиль</button>
            <button class="ozon-btn action-btn btn-ucenka" onclick="submitAction('ucenka')">💰 Уценка</button>
            <button class="ozon-btn action-btn btn-peresort" onclick="submitAction('peresort')">🔄 Пересорт</button>
        </div>
        
        <div id="messageArea">
            <% if (request.getAttribute("message") != null) { %>
                <div class="ozon-success">✅ <%= request.getAttribute("message") %></div>
            <% } %>
            <% if (request.getAttribute("error") != null) { %>
                <div class="ozon-error">❌ <%= request.getAttribute("error") %></div>
            <% } %>
        </div>
        
        <a href="processing" class="ozon-btn">← Ко всем грузам</a>
    </div>
</div>

<script>
    const scannerInput = document.getElementById('scannerInput');
    let currentBarcode = '';
    
    // AJAX поиск товара по штрихкоду
    scannerInput.addEventListener('blur', function() {
        const barcode = this.value.trim();
        if (barcode.length > 3) {
            fetch('${pageContext.request.contextPath}/api/product?barcode=' + encodeURIComponent(barcode))
                .then(response => response.text())
                .then(data => {
                    if (data.startsWith('found|')) {
                        const parts = data.split('|');
                        document.getElementById('productArticle').innerText = parts[1];
                        document.getElementById('productName').innerText = parts[2];
                        currentBarcode = parts[1];
                    } else {
                        document.getElementById('productArticle').innerText = 'Товар не найден';
                        document.getElementById('productName').innerText = '—';
                        currentBarcode = '';
                    }
                });
        }
    });
    
    function submitAction(action) {
        if (!currentBarcode && scannerInput.value.trim().length > 0) {
            currentBarcode = scannerInput.value.trim();
        }
        if (!currentBarcode) {
            alert('Сначала отсканируйте товар');
            return;
        }
        document.getElementById('barcodeInput').value = currentBarcode;
        document.getElementById('actionInput').value = action;
        document.getElementById('scanForm').submit();
    }
</script>

</body>
</html>