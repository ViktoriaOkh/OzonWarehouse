<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Склад Ozon</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
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
        }
        
        /* ШАПКА */
        .ozon-header {
            background: #005bff;
            border-radius: 20px;
            padding: 20px 30px;
            margin-bottom: 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            box-shadow: 0 5px 15px rgba(0, 91, 255, 0.3);
        }
        .ozon-header h1 {
            color: white;
            font-size: 24px;
            margin: 0;
        }
        .ozon-logo {
            display: flex;
            align-items: center;
            gap: 15px;
        }
        .ozon-logo span {
            font-size: 32px;
        }
        .ozon-subtitle {
            color: rgba(255,255,255,0.9);
            font-size: 14px;
        }
        
        /* СЕТКА: 3 КАРТОЧКИ В СТРОКЕ */
        .menu-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 25px;
            margin-bottom: 30px;
        }
        
        /* КАРТОЧКИ */
        .card {
            background: white;
            border-radius: 20px;
            padding: 30px 20px;
            text-align: center;
            text-decoration: none;
            transition: all 0.3s;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.08);
            border: 1px solid rgba(0, 91, 255, 0.1);
            display: block;
        }
        .card:hover {
            transform: translateY(-8px);
            box-shadow: 0 15px 30px rgba(0, 91, 255, 0.15);
            border-color: #ff6b35;
        }
        .card-icon {
            font-size: 48px;
            margin-bottom: 15px;
        }
        .card h3 {
            color: #005bff;
            font-size: 18px;
            margin-bottom: 8px;
        }
        .card p {
            color: #666;
            font-size: 12px;
        }
        
        /* ИНФО-ПАНЕЛЬ */
        .info-panel {
            background: white;
            border-radius: 20px;
            padding: 20px 25px;
            margin-top: 20px;
            border-left: 5px solid #ff6b35;
        }
        .info-panel h3 {
            color: #005bff;
            margin-bottom: 15px;
        }
        .info-panel p {
            color: #666;
            font-size: 14px;
            line-height: 1.5;
        }
        
        /* ПОДВАЛ */
        .footer {
            text-align: center;
            margin-top: 30px;
            padding: 20px;
            color: #999;
            font-size: 12px;
        }
        
        /* АДАПТИВ ДЛЯ ПЛАНШЕТОВ (2 КАРТОЧКИ) */
        @media (max-width: 900px) {
            .menu-grid {
                grid-template-columns: repeat(2, 1fr);
            }
        }
        
        /* АДАПТИВ ДЛЯ ТЕЛЕФОНОВ (1 КАРТОЧКА) */
        @media (max-width: 600px) {
            .menu-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
<div class="container">
    <!-- ШАПКА -->
    <div class="ozon-header">
        <div class="ozon-logo">
            <span>📦</span>
            <h1>Склад Ozon</h1>
        </div>
        <div class="ozon-subtitle">
            Система учета возвратов и уценки товаров
        </div>
    </div>
    
    <!-- 6 КАРТОЧЕК: 3 В СТРОКУ, 2 СТРОКИ -->
    <div class="ozon-menu-grid">
    <a href="products" class="ozon-menu-card">
        <div class="ozon-menu-icon">📦</div>
        <h3>Товары</h3>
        <p>Управление товарами на складе</p>
    </a>
    <a href="employees" class="ozon-menu-card">
        <div class="ozon-menu-icon">👥</div>
        <h3>Сотрудники</h3>
        <p>Список сотрудников склада</p>
    </a>
    <a href="jsp/operations.jsp" class="ozon-menu-card">
        <div class="ozon-menu-icon">📝</div>
        <h3>Операции</h3>
        <p>Журнал операций с товарами</p>
    </a>
    <a href="jsp/reports.jsp" class="ozon-menu-card">
        <div class="ozon-menu-icon">📊</div>
        <h3>Отчеты</h3>
        <p>Статистика и аналитика</p>
    </a>
    <a href="jsp/utilization.jsp" class="ozon-menu-card">
        <div class="ozon-menu-icon">🗑️</div>
        <h3>Акт утилизации</h3>
        <p>Отчет по утилизации товаров</p>
    </a>
</div>
        
        <a href="auth" class="card">
            <div class="card-icon">🔄</div>
            <h3>Обработка возвратов</h3>
            <p>Сканирование и уценка товаров</p>
        </a>
    </div>
    
    <!-- ИНФОРМАЦИОННАЯ ПАНЕЛЬ -->
    <div class="info-panel">
        <h3>📌 О системе</h3>
        <p>Система разработана для автоматизации учета возвратов на складе Ozon. Позволяет вести учет товаров, сотрудников, операций утилизации, уценки и пересорта.</p>
    </div>
    
    <!-- ПОДВАЛ -->
    <div class="footer">
        Учет возвратов Ozon © 2026 | Участок возвратов | Производственная практика
    </div>
</div>
</body>
</html>