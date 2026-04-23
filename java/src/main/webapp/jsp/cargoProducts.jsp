<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, model.Cargo, model.Product" %>
<%
    int cargoId = ((Cargo) request.getAttribute("cargo")).getId();
    request.setAttribute("cargoId", cargoId);
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Товары в грузе</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #e6f0fa 0%, #fce4ec 100%);
            padding: 20px;
        }
        .container { max-width: 1400px; margin: 0 auto; }
        
        .ozon-header {
            background: #005bff;
            border-radius: 20px;
            padding: 20px 30px;
            margin-bottom: 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
        }
        .ozon-header h1 { color: white; font-size: 24px; }
        .ozon-header .logo { display: flex; align-items: center; gap: 15px; }
        .ozon-header .logo span { font-size: 32px; }
        .ozon-nav a {
            color: white;
            text-decoration: none;
            margin-left: 20px;
            padding: 8px 15px;
            border-radius: 10px;
            transition: 0.3s;
        }
        .ozon-nav a:hover { background: rgba(255,255,255,0.2); }
        
        .split-layout { display: flex; gap: 25px; }
        .products-list {
            width: 35%;
            background: white;
            border-radius: 20px;
            padding: 15px;
            max-height: 70vh;
            overflow-y: auto;
        }
        .product-item {
            display: flex;
            align-items: center;
            gap: 15px;
            padding: 12px;
            border-bottom: 1px solid #eee;
            cursor: pointer;
            transition: 0.2s;
        }
        .product-item:hover { background: #fce4ec; border-radius: 12px; }
        .product-item.active {
            background: #e6f0fa;
            border-radius: 12px;
            border-left: 4px solid #005bff;
        }
        .product-item img {
            width: 50px;
            height: 50px;
            object-fit: cover;
            border-radius: 10px;
        }
        .product-name { font-weight: bold; color: #333; }
        .product-article { font-size: 12px; color: #666; }
        
        .right-panel { width: 65%; display: flex; flex-direction: column; gap: 20px; }
        
        .cargo-control {
            background: white;
            border-radius: 20px;
            padding: 20px;
            border: 1px solid #e0e0e0;
        }
        .cargo-control h4 { color: #005bff; margin-bottom: 15px; }
        .cargo-control input, .cargo-control select {
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 10px;
            margin-bottom: 10px;
            width: 100%;
        }
        .btn-open { background: #28a745; color: white; border: none; padding: 10px 20px; border-radius: 10px; cursor: pointer; margin-right: 5px; }
        .btn-close { background: #dc3545; color: white; border: none; padding: 10px 20px; border-radius: 10px; cursor: pointer; }
        
        .box-info {
            margin-top: 15px;
            padding: 10px;
            background: #f0f7ff;
            border-radius: 10px;
            font-size: 14px;
        }
        
        .all-stats {
            background: #f8f9fa;
            border-radius: 15px;
            padding: 15px;
        }
        .all-stats h5 { color: #005bff; margin-bottom: 10px; }
        .stat-grid { display: flex; gap: 15px; flex-wrap: wrap; }
        .stat-card {
            padding: 10px 20px;
            border-radius: 12px;
            text-align: center;
            min-width: 90px;
        }
        .stat-card .count { font-size: 24px; font-weight: bold; }
        .stat-card .label { font-size: 12px; }
        
        .detail-panel {
            background: white;
            border-radius: 20px;
            padding: 25px;
        }
        .product-photo { text-align: center; margin-bottom: 20px; }
        .product-photo img { max-width: 200px; border-radius: 15px; }
        .chars-table { width: 100%; margin: 15px 0; }
        .chars-table td { padding: 8px; border-bottom: 1px solid #eee; }
        .comments-section { background: #f8f9fa; padding: 15px; border-radius: 15px; margin: 15px 0; }
        .comment { padding: 10px; border-bottom: 1px solid #ddd; font-style: italic; }
        .action-buttons { display: flex; gap: 10px; margin-top: 20px; flex-wrap: wrap; }
        
        .modal {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0,0,0,0.5);
            justify-content: center;
            align-items: center;
            z-index: 1000;
        }
        .modal-content {
            background: white;
            border-radius: 20px;
            padding: 25px;
            width: 450px;
        }
        .modal-content h3 { color: #005bff; margin-bottom: 20px; }
        .modal-content label { display: block; margin-bottom: 5px; font-weight: bold; }
        .modal-content select, .modal-content textarea, .modal-content input {
            width: 100%;
            padding: 10px;
            border-radius: 10px;
            border: 1px solid #ddd;
            margin-bottom: 15px;
        }
        .modal-actions { display: flex; gap: 10px; justify-content: flex-end; }
        
        .tag-valid { background: #28a745; color: white; padding: 3px 10px; border-radius: 15px; font-size: 12px; }
        .tag-ucenka { background: #ffc107; color: #333; padding: 3px 10px; border-radius: 15px; font-size: 12px; }
        .tag-util { background: #dc3545; color: white; padding: 3px 10px; border-radius: 15px; font-size: 12px; }
        .tag-peresort { background: #17a2b8; color: white; padding: 3px 10px; border-radius: 15px; font-size: 12px; }
        
        .cargo-header {
            background: #e6f0fa;
            padding: 12px 20px;
            border-radius: 15px;
            margin-bottom: 20px;
            display: flex;
            justify-content: space-between;
            flex-wrap: wrap;
        }
    </style>
</head>
<body>

<div class="container">
    <div class="ozon-header">
        <div class="logo">
            <span>📦</span>
            <h1>Обработка груза</h1>
        </div>
        <div class="ozon-nav">
            <a href="index.jsp">🏠 Главная</a>
            <a href="processing" class="active">🔄 Обработка</a>
            <div style="background:rgba(255,255,255,0.15); padding:5px 15px; border-radius:20px; margin-left:20px;">
                👤 ${sessionScope.employeeName}
            </div>
            <a href="logout" style="color: white; text-decoration: none; margin-left: 20px; padding: 8px 15px; border-radius: 10px; background: rgba(255,255,255,0.15);">🚪 Выйти</a>
        </div>
    </div>
    
    <div class="cargo-header">
        <span><strong>📦 Груз:</strong> ${cargo.number}</span>
        <span><strong>📅 Время:</strong> ${cargo.receiptTime}</span>
        <span><strong>📊 Позиций:</strong> ${cargo.quantity}</span>
    </div>
    
    <div class="split-layout">
        <div class="products-list">
            <h3>Товары в грузе</h3>
            <div id="productList">
                <% 
                    List<Product> products = (List<Product>) request.getAttribute("products");
                    if (products != null && !products.isEmpty()) {
                        for (Product p : products) {
                            String articleLower = p.getArticle().toLowerCase();
                %>
                <div class="product-item" onclick="loadProductDetail(<%= p.getId() %>)">
                    <img src="${pageContext.request.contextPath}/images/products/<%= articleLower %>.jpg" 
                         onerror="this.src='https://via.placeholder.com/50?text=📦'">
                    <div>
                        <div class="product-name"><%= p.getName() %></div>
                        <div class="product-article"><%= p.getArticle() %></div>
                    </div>
                </div>
                <%      }
                    } else { %>
                <div style="text-align:center; padding:20px;">Нет товаров в этом грузе</div>
                <% } %>
            </div>
        </div>
        
        <div class="right-panel">
            <div class="cargo-control">
                <h4>📦 Управление тарой</h4>
                <div>
                    <input type="text" id="boxNumberOpen" placeholder="Номер тары (bx...)">
                    <select id="boxTypeOpen">
                        <option value="">-- Тип тары --</option>
                        <option value="Валид">✅ Валид</option>
                        <option value="Уценка">💰 Уценка</option>
                        <option value="Утиль">🗑 Утиль</option>
                        <option value="Пересорт">🔄 Пересорт</option>
                    </select>
                    <button onclick="openBox()" class="btn-open">Открыть тару</button>
                    <button onclick="closeBox()" class="btn-close">Закрыть тару</button>
                </div>
                <div id="boxInfo" class="box-info"></div>
            </div>
            
            <div class="all-stats">
                <h5>📊 Общая статистика по всем тарам:</h5>
                <div class="stat-grid">
                    <div class="stat-card" style="background:#dc3545; color:white;"><div class="count" id="totalUtilit">0</div><div class="label">🗑 Утиль</div></div>
                    <div class="stat-card" style="background:#ffc107; color:#333;"><div class="count" id="totalUcenka">0</div><div class="label">💰 Уценка</div></div>
                    <div class="stat-card" style="background:#17a2b8; color:white;"><div class="count" id="totalPeresort">0</div><div class="label">🔄 Пересорт</div></div>
                    <div class="stat-card" style="background:#28a745; color:white;"><div class="count" id="totalValid">0</div><div class="label">✅ Валид</div></div>
                    <div class="stat-card" style="background:#005bff; color:white;"><div class="count" id="totalAll">0</div><div class="label">📦 Всего</div></div>
                </div>
            </div>
            
            <div class="detail-panel" id="detailPanel">
                <div style="text-align:center; color:#999;">🔍 Выберите товар из списка слева</div>
            </div>
            
            <div style="margin-top: 15px;">
                <button onclick="closeCargo()" class="btn-close" style="width:100%;">📦 Закрыть груз</button>
            </div>
        </div>
    </div>
    
    <a href="processing" class="btn-open" style="display:inline-block; margin-top:20px; text-decoration:none;">← Ко всем грузам</a>
</div>

<!-- Модальное окно для уценки -->
<div id="ucenkaModal" class="modal">
    <div class="modal-content">
        <h3>💰 Уценка товара</h3>
        <input type="hidden" id="modalCargoId">
        <input type="hidden" id="modalProductId">
        <label>Выберите тару:</label>
        <select id="modalBoxNumber"></select>
        <label>Причина:</label>
        <select id="modalReason">
            <option value="Механическое повреждение">Механическое повреждение</option>
            <option value="Не комплект">Не комплект</option>
            <option value="Заводской брак">Заводской брак</option>
            <option value="Следы использования">Следы использования</option>
        </select>
        <label>Состояние:</label>
        <div><label><input type="radio" name="condition" value="Новый" checked> Новый</label> <label><input type="radio" name="condition" value="Б/у"> Б/у</label></div>
        <label>Комментарий:</label>
        <textarea id="modalComment" rows="3"></textarea>
        <div class="modal-actions">
            <button onclick="saveUcenka()" style="background:#28a745; color:white; border:none; padding:10px 20px; border-radius:10px;">Сохранить</button>
            <button onclick="closeUcenkaModal()" style="background:#dc3545; color:white; border:none; padding:10px 20px; border-radius:10px;">Отменить</button>
        </div>
    </div>
</div>

<!-- Модальное окно для утилизации -->
<div id="utilModal" class="modal">
    <div class="modal-content">
        <h3>🗑 Утилизация товара</h3>
        <input type="hidden" id="utilModalCargoId">
        <input type="hidden" id="utilModalProductId">
        <label>Выберите тару:</label>
        <select id="utilModalBoxNumber"></select>
        <label>Причина:</label>
        <select id="utilModalReason">
            <option value="Механическое повреждение">Механическое повреждение</option>
            <option value="Не работает">Не работает</option>
            <option value="Брак">Брак</option>
            <option value="Истек срок годности">Истек срок годности</option>
        </select>
        <label>Комментарий:</label>
        <textarea id="utilModalComment" rows="3"></textarea>
        <div class="modal-actions">
            <button onclick="saveUtil()" style="background:#28a745; color:white; border:none; padding:10px 20px; border-radius:10px;">Сохранить</button>
            <button onclick="closeUtilModal()" style="background:#dc3545; color:white; border:none; padding:10px 20px; border-radius:10px;">Отменить</button>
        </div>
    </div>
</div>

<!-- Модальное окно для пересорта -->
<div id="peresortModal" class="modal">
    <div class="modal-content">
        <h3>🔄 Пересорт товара</h3>
        <input type="hidden" id="peresortModalCargoId">
        <input type="hidden" id="peresortModalProductId">
        <label>Выберите тару:</label>
        <select id="peresortModalBoxNumber"></select>
        <label>Введите SKU товара:</label>
        <input type="text" id="peresortSku" placeholder="Например: OZN-999">
        <label>Причина пересорта:</label>
        <select id="peresortReason">
            <option value="Не тот товар">Не тот товар</option>
            <option value="Ошибка маркировки">Ошибка маркировки</option>
            <option value="Перепутаны артикулы">Перепутаны артикулы</option>
            <option value="Другое">Другое</option>
        </select>
        <label>Комментарий:</label>
        <textarea id="peresortComment" rows="3"></textarea>
        <div class="modal-actions">
            <button onclick="savePeresort()" style="background:#28a745; color:white; border:none; padding:10px 20px; border-radius:10px;">Сохранить</button>
            <button onclick="closePeresortModal()" style="background:#dc3545; color:white; border:none; padding:10px 20px; border-radius:10px;">Отменить</button>
        </div>
    </div>
</div>

<script>
    var cargoId = <%= request.getAttribute("cargoId") %>;
    
    function loadProductDetail(productId) {
        fetch('${pageContext.request.contextPath}/api/productDetail?productId=' + productId + '&cargoId=' + cargoId)
            .then(response => response.text())
            .then(data => { document.getElementById('detailPanel').innerHTML = data; });
    }
    
    function loadAllStats() {
        fetch('${pageContext.request.contextPath}/api/box?action=current&cargoId=' + cargoId)
            .then(response => response.text())
            .then(data => {
                if (data.startsWith('success|')) {
                    var boxes = data.substring(8).split(',');
                    var boxNumbers = [];
                    for (var i = 0; i < boxes.length; i++) boxNumbers.push(boxes[i].split('[')[0]);
                    if (boxNumbers.length === 0) {
                        document.getElementById('totalUtilit').innerText = '0';
                        document.getElementById('totalUcenka').innerText = '0';
                        document.getElementById('totalPeresort').innerText = '0';
                        document.getElementById('totalValid').innerText = '0';
                        document.getElementById('totalAll').innerText = '0';
                        return;
                    }
                    var totalUtilit=0, totalUcenka=0, totalPeresort=0, totalValid=0, totalAll=0, completed=0;
                    for (var i = 0; i < boxNumbers.length; i++) {
                        fetch('${pageContext.request.contextPath}/api/box?action=stats&cargoId=' + cargoId + '&boxNumber=' + encodeURIComponent(boxNumbers[i]))
                            .then(response => response.text())
                            .then(statsData => {
                                if (statsData.startsWith('success|')) {
                                    var parts = statsData.split('|');
                                    totalUtilit += parseInt(parts[1]);
                                    totalUcenka += parseInt(parts[2]);
                                    totalPeresort += parseInt(parts[3]);
                                    totalValid += parseInt(parts[4]);
                                    totalAll += parseInt(parts[5]);
                                }
                                completed++;
                                if (completed === boxNumbers.length) {
                                    document.getElementById('totalUtilit').innerText = totalUtilit;
                                    document.getElementById('totalUcenka').innerText = totalUcenka;
                                    document.getElementById('totalPeresort').innerText = totalPeresort;
                                    document.getElementById('totalValid').innerText = totalValid;
                                    document.getElementById('totalAll').innerText = totalAll;
                                }
                            });
                    }
                } else {
                    document.getElementById('totalUtilit').innerText = '0';
                    document.getElementById('totalUcenka').innerText = '0';
                    document.getElementById('totalPeresort').innerText = '0';
                    document.getElementById('totalValid').innerText = '0';
                    document.getElementById('totalAll').innerText = '0';
                }
            });
    }
    
    function openBox() {
        var boxNumber = document.getElementById('boxNumberOpen').value.trim();
        var boxType = document.getElementById('boxTypeOpen').value;
        if (!boxNumber) { alert('Введите номер тары'); return; }
        if (!boxType) { alert('Выберите тип тары'); return; }
        fetch('${pageContext.request.contextPath}/api/box?action=open&cargoId=' + cargoId + '&boxNumber=' + encodeURIComponent(boxNumber) + '&operationType=' + encodeURIComponent(boxType))
            .then(response => response.text())
            .then(data => {
                var infoDiv = document.getElementById('boxInfo');
                if (data.startsWith('success|')) {
                    infoDiv.innerHTML = '<span style="color:green;">✅ ' + data.substring(8) + '</span>';
                    document.getElementById('boxNumberOpen').value = '';
                    document.getElementById('boxTypeOpen').value = '';
                    loadCurrentBox();
                    loadAllStats();
                } else if (data.startsWith('error|')) {
                    infoDiv.innerHTML = '<span style="color:red;">❌ ' + data.substring(6) + '</span>';
                } else { infoDiv.innerHTML = '<span style="color:red;">❌ Ошибка</span>'; }
            });
    }
    
    function closeBox() {
        var boxNumber = document.getElementById('boxNumberClose').value.trim();
        if (!boxNumber) { alert('Введите номер тары для закрытия'); return; }
        fetch('${pageContext.request.contextPath}/api/box?action=close&cargoId=' + cargoId + '&boxNumber=' + encodeURIComponent(boxNumber))
            .then(response => response.text())
            .then(data => {
                var infoDiv = document.getElementById('boxInfo');
                if (data.startsWith('success|')) {
                    infoDiv.innerHTML = '<span style="color:green;">✅ ' + data.substring(8) + '</span>';
                    document.getElementById('boxNumberClose').value = '';
                    loadCurrentBox();
                    loadAllStats();
                } else if (data.startsWith('error|')) {
                    infoDiv.innerHTML = '<span style="color:red;">❌ ' + data.substring(6) + '</span>';
                } else { infoDiv.innerHTML = '<span style="color:red;">❌ Ошибка</span>'; }
            });
    }
    
    function loadCurrentBox() {
        fetch('${pageContext.request.contextPath}/api/box?action=current&cargoId=' + cargoId)
            .then(response => response.text())
            .then(data => {
                var infoDiv = document.getElementById('boxInfo');
                if (data.startsWith('success|')) {
                    var boxes = data.substring(8).split(',');
                    var html = '<span style="color:blue;">📦 Открытые тары:</span><br>';
                    for (var i = 0; i < boxes.length; i++) {
                        var box = boxes[i];
                        var tagClass = '';
                        if (box.includes('[Валид]')) tagClass = 'tag-valid';
                        else if (box.includes('[Уценка]')) tagClass = 'tag-ucenka';
                        else if (box.includes('[Утиль]')) tagClass = 'tag-util';
                        else if (box.includes('[Пересорт]')) tagClass = 'tag-peresort';
                        html += '<div style="margin-left:15px; margin-bottom:5px;"><span class="' + tagClass + '">' + box + '</span></div>';
                    }
                    infoDiv.innerHTML = html;
                } else if (data.startsWith('empty|')) {
                    infoDiv.innerHTML = '<span style="color:gray;">📦 Нет открытых тар</span>';
                } else { infoDiv.innerHTML = '<span style="color:red;">❌ ' + data + '</span>'; }
            });
    }
    
    function openUcenkaModal(cargoId, productId) {
        document.getElementById('modalCargoId').value = cargoId;
        document.getElementById('modalProductId').value = productId;
        var selectBox = document.getElementById('modalBoxNumber');
        selectBox.innerHTML = '<option value="">-- Выберите тару --</option>';
        fetch('${pageContext.request.contextPath}/api/box?action=current&cargoId=' + cargoId)
            .then(response => response.text())
            .then(data => {
                if (data.startsWith('success|')) {
                    var boxes = data.substring(8).split(',');
                    for (var i = 0; i < boxes.length; i++) {
                        var option = document.createElement('option');
                        option.value = boxes[i].split('[')[0];
                        option.text = boxes[i];
                        selectBox.appendChild(option);
                    }
                }
            });
        document.getElementById('ucenkaModal').style.display = 'flex';
    }
    
    function closeUcenkaModal() {
        document.getElementById('ucenkaModal').style.display = 'none';
        document.getElementById('modalComment').value = '';
    }
    
    function saveUcenka() {
        var cargoId = document.getElementById('modalCargoId').value;
        var productId = document.getElementById('modalProductId').value;
        var boxNumber = document.getElementById('modalBoxNumber').value;
        var reason = document.getElementById('modalReason').value;
        var condition = document.querySelector('input[name="condition"]:checked').value;
        var comment = document.getElementById('modalComment').value;
        var fullComment = 'Состояние: ' + condition + '. ' + comment;
        if (!boxNumber) { alert('Выберите тару'); return; }
        var form = document.createElement('form');
        form.method = 'POST';
        form.action = 'processProduct';
        form.innerHTML = '<input type="hidden" name="cargoId" value="' + cargoId + '">' +
                         '<input type="hidden" name="productId" value="' + productId + '">' +
                         '<input type="hidden" name="boxNumber" value="' + boxNumber + '">' +
                         '<input type="hidden" name="action" value="ucenka">' +
                         '<input type="hidden" name="reason" value="' + reason + '">' +
                         '<input type="hidden" name="comment" value="' + fullComment + '">';
        document.body.appendChild(form);
        form.submit();
        setTimeout(function() { loadAllStats(); loadCurrentBox(); }, 500);
    }
    
    function openUtilModal(cargoId, productId) {
        document.getElementById('utilModalCargoId').value = cargoId;
        document.getElementById('utilModalProductId').value = productId;
        var selectBox = document.getElementById('utilModalBoxNumber');
        selectBox.innerHTML = '<option value="">-- Выберите тару --</option>';
        fetch('${pageContext.request.contextPath}/api/box?action=current&cargoId=' + cargoId)
            .then(response => response.text())
            .then(data => {
                if (data.startsWith('success|')) {
                    var boxes = data.substring(8).split(',');
                    for (var i = 0; i < boxes.length; i++) {
                        var option = document.createElement('option');
                        option.value = boxes[i].split('[')[0];
                        option.text = boxes[i];
                        selectBox.appendChild(option);
                    }
                }
            });
        document.getElementById('utilModal').style.display = 'flex';
    }
    
    function closeUtilModal() {
        document.getElementById('utilModal').style.display = 'none';
        document.getElementById('utilModalComment').value = '';
    }
    
    function saveUtil() {
        var cargoId = document.getElementById('utilModalCargoId').value;
        var productId = document.getElementById('utilModalProductId').value;
        var boxNumber = document.getElementById('utilModalBoxNumber').value;
        var reason = document.getElementById('utilModalReason').value;
        var comment = document.getElementById('utilModalComment').value;
        if (!boxNumber) { alert('Выберите тару'); return; }
        var form = document.createElement('form');
        form.method = 'POST';
        form.action = 'processProduct';
        form.innerHTML = '<input type="hidden" name="cargoId" value="' + cargoId + '">' +
                         '<input type="hidden" name="productId" value="' + productId + '">' +
                         '<input type="hidden" name="boxNumber" value="' + boxNumber + '">' +
                         '<input type="hidden" name="action" value="utilit">' +
                         '<input type="hidden" name="reason" value="' + reason + '">' +
                         '<input type="hidden" name="comment" value="' + comment + '">';
        document.body.appendChild(form);
        form.submit();
        setTimeout(function() { loadAllStats(); loadCurrentBox(); }, 500);
    }
    
    function openPeresortModal(cargoId, productId) {
        document.getElementById('peresortModalCargoId').value = cargoId;
        document.getElementById('peresortModalProductId').value = productId;
        var selectBox = document.getElementById('peresortModalBoxNumber');
        selectBox.innerHTML = '<option value="">-- Выберите тару --</option>';
        fetch('${pageContext.request.contextPath}/api/box?action=current&cargoId=' + cargoId)
            .then(response => response.text())
            .then(data => {
                if (data.startsWith('success|')) {
                    var boxes = data.substring(8).split(',');
                    for (var i = 0; i < boxes.length; i++) {
                        var option = document.createElement('option');
                        option.value = boxes[i].split('[')[0];
                        option.text = boxes[i];
                        selectBox.appendChild(option);
                    }
                }
            });
        document.getElementById('peresortModal').style.display = 'flex';
    }
    
    function closePeresortModal() {
        document.getElementById('peresortModal').style.display = 'none';
        document.getElementById('peresortSku').value = '';
        document.getElementById('peresortComment').value = '';
    }
    
    function savePeresort() {
        var cargoId = document.getElementById('peresortModalCargoId').value;
        var productId = document.getElementById('peresortModalProductId').value;
        var boxNumber = document.getElementById('peresortModalBoxNumber').value;
        var sku = document.getElementById('peresortSku').value.trim();
        var reason = document.getElementById('peresortReason').value;
        var comment = document.getElementById('peresortComment').value;
        if (!boxNumber) { alert('Выберите тару'); return; }
        if (!sku) { alert('Введите SKU товара'); return; }
        var fullComment = 'Новый SKU: ' + sku + '. Причина: ' + reason + '. ' + comment;
        var form = document.createElement('form');
        form.method = 'POST';
        form.action = 'processProduct';
        form.innerHTML = '<input type="hidden" name="cargoId" value="' + cargoId + '">' +
                         '<input type="hidden" name="productId" value="' + productId + '">' +
                         '<input type="hidden" name="boxNumber" value="' + boxNumber + '">' +
                         '<input type="hidden" name="action" value="peresort">' +
                         '<input type="hidden" name="comment" value="' + fullComment + '">';
        document.body.appendChild(form);
        form.submit();
        setTimeout(function() { loadAllStats(); loadCurrentBox(); }, 500);
    }
    
    function closeCargo() {
        if (!confirm('Вы уверены, что хотите закрыть груз? После закрытия добавить товары будет нельзя.')) {
            return;
        }
        
        fetch('${pageContext.request.contextPath}/api/cargo?action=close&cargoId=' + cargoId)
            .then(response => response.text())
            .then(data => {
                if (data.startsWith('success|')) {
                    alert('Груз закрыт!');
                    window.location.href = 'processing';
                } else if (data.startsWith('error|')) {
                    alert('Ошибка: ' + data.substring(6));
                } else {
                    alert('Ошибка при закрытии груза');
                }
            });
    }
    
    loadCurrentBox();
    loadAllStats();
</script>

</body>
</html>