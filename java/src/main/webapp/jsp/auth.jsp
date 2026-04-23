<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Авторизация - Склад Ozon</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        /* Дополнительные стили для центрирования */
        .auth-container {
            min-height: 80vh;
            display: flex;
            justify-content: center;
            align-items: center;
        }
        .auth-card {
            max-width: 450px;
            width: 100%;
            text-align: center;
            background: white;
            border-radius: 25px;
            padding: 40px 35px;
            box-shadow: 0 20px 40px rgba(0, 91, 255, 0.15);
            transition: transform 0.3s;
        }
        .auth-card:hover {
            transform: translateY(-5px);
        }
        .auth-icon {
            font-size: 64px;
            margin-bottom: 15px;
        }
        .auth-title {
            color: #005bff;
            font-size: 24px;
            margin-bottom: 10px;
        }
        .auth-subtitle {
            color: #666;
            font-size: 14px;
            margin-bottom: 30px;
        }
        .auth-input {
            width: 100%;
            padding: 14px 18px;
            font-size: 16px;
            border: 2px solid #e0e0e0;
            border-radius: 15px;
            transition: all 0.3s;
            text-align: center;
            letter-spacing: 1px;
        }
        .auth-input:focus {
            outline: none;
            border-color: #005bff;
            box-shadow: 0 0 0 3px rgba(0, 91, 255, 0.1);
        }
        .auth-btn {
            width: 100%;
            padding: 14px;
            background: #005bff;
            color: white;
            border: none;
            border-radius: 15px;
            font-size: 16px;
            font-weight: bold;
            cursor: pointer;
            transition: all 0.3s;
            margin-top: 20px;
        }
        .auth-btn:hover {
            background: #ff6b35;
            transform: translateY(-2px);
        }
        .employee-info {
            margin-top: 25px;
            padding: 15px;
            background: #f0f7ff;
            border-radius: 15px;
            border-left: 4px solid #005bff;
            text-align: left;
        }
        .employee-info h4 {
            color: #005bff;
            margin-bottom: 8px;
            font-size: 14px;
        }
        .employee-info p {
            color: #333;
            font-size: 16px;
            font-weight: bold;
        }
        .error-message {
            background: #fee;
            color: #c00;
            padding: 12px;
            border-radius: 12px;
            margin-top: 15px;
            font-size: 14px;
        }
        .hint {
            color: #999;
            font-size: 12px;
            margin-top: 15px;
        }
    </style>
</head>
<body style="background: linear-gradient(135deg, #e6f0fa 0%, #fce4ec 100%); min-height: 100vh;">

<div class="auth-container">
    <div class="auth-card">
        <div class="auth-icon">🔄</div>
        <div class="auth-title">Вход в учётную запись</div>
        <div class="auth-subtitle">Обработка возвратных постингов</div>
        
        <form method="post" id="authForm">
            <input type="text" 
                   name="barcode" 
                   id="barcode" 
                   class="auth-input" 
                   placeholder="Отсканируйте US или введите вручную"
                   autofocus>
            <button type="submit" class="auth-btn">🔓 Войти в систему</button>
        </form>
        
        <!-- Блок с информацией о сотруднике (появляется при вводе US) -->
        <div id="employeeInfo" class="employee-info" style="display: none;">
            <h4>👤 Найден сотрудник:</h4>
            <p id="employeeName"></p>
        </div>
        
        <div class="hint">
            ℹ️ Пример: <strong>us5689548</strong>
        </div>
        
        <% if (request.getAttribute("error") != null) { %>
            <div class="error-message">
                ❌ <%= request.getAttribute("error") %>
            </div>
        <% } %>
    </div>
</div>

<script>
    const barcodeInput = document.getElementById('barcode');
    const employeeInfoDiv = document.getElementById('employeeInfo');
    const employeeNameSpan = document.getElementById('employeeName');
    let timeoutId = null;
    
    barcodeInput.addEventListener('input', function() {
        const barcode = this.value.trim();
        
        if (timeoutId) clearTimeout(timeoutId);
        
        if (barcode.length >= 5) {
            timeoutId = setTimeout(function() {
                fetch('${pageContext.request.contextPath}/api/employee?barcode=' + encodeURIComponent(barcode))
                    .then(response => response.text())
                    .then(data => {
                        if (data.startsWith('found|')) {
                            const parts = data.split('|');
                            employeeNameSpan.textContent = parts[1];
                            employeeInfoDiv.style.display = 'block';
                        } else {
                            employeeInfoDiv.style.display = 'none';
                        }
                    })
                    .catch(error => {
                        console.error('Ошибка:', error);
                        employeeInfoDiv.style.display = 'none';
                    });
            }, 300);
        } else {
            employeeInfoDiv.style.display = 'none';
        }
    });
</script>

</body>
</html>