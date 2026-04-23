package servlet;

import dao.ProductDetailDAO;
import model.ProductDetail;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/api/productDetail")
public class ProductDetailApiServlet extends HttpServlet {
    
    private ProductDetailDAO detailDAO = new ProductDetailDAO();
    
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("text/html;charset=UTF-8");
        PrintWriter out = resp.getWriter();
        
        String productIdParam = req.getParameter("productId");
        String cargoIdParam = req.getParameter("cargoId");
        
        if (productIdParam == null || productIdParam.equals("null") || productIdParam.trim().isEmpty()) {
            out.println("<div style='text-align:center; color:#c00;'>Ошибка: не указан ID товара</div>");
            return;
        }
        
        int productId;
        int cargoId = 0;
        try {
            productId = Integer.parseInt(productIdParam);
            if (cargoIdParam != null && !cargoIdParam.equals("null") && !cargoIdParam.trim().isEmpty()) {
                cargoId = Integer.parseInt(cargoIdParam);
            }
        } catch (NumberFormatException e) {
            out.println("<div style='text-align:center; color:#c00;'>Ошибка: неверный формат ID</div>");
            return;
        }
        
        ProductDetail detail = detailDAO.getProductDetail(productId);
        
        if (detail == null || detail.getProduct() == null) {
            out.println("<div style='text-align:center; color:#c00;'>Товар не найден</div>");
            return;
        }
        
        // Фото
        out.println("<div class='product-photo'>");
        String article = detail.getProduct().getArticle().toLowerCase();
        String photoUrl = "/OzonWarehouse/images/products/" + article + ".jpg";
        out.println("<img src='" + photoUrl + "' alt='Фото товара' style='max-width:200px; border-radius:15px;' onerror=\"this.src='https://via.placeholder.com/200?text=Нет+фото'\">");
        out.println("</div>");
        
        out.println("<h3>" + detail.getProduct().getName() + "</h3>");
        out.println("<p>Артикул: " + detail.getProduct().getArticle() + "</p>");
        
        // Характеристики
        out.println("<h4>📋 Характеристики</h4>");
        out.println("<table class='chars-table'>");
        if (detail.getCharacteristics() != null && !detail.getCharacteristics().isEmpty()) {
            for (var entry : detail.getCharacteristics().entrySet()) {
                out.println("<tr><td style='padding:8px; border-bottom:1px solid #eee;'><strong>" + entry.getKey() + ":</strong></td><td style='padding:8px; border-bottom:1px solid #eee;'>" + entry.getValue() + "NonNull尾");
            }
        } else {
            out.println("<tr><td colspan='2'>Нет характеристик</td>");
        }
        out.println("</table>");
        
        // Комментарии
        out.println("<h4>💬 Комментарии покупателей</h4>");
        out.println("<div class='comments-section'>");
        if (detail.getComments() != null && !detail.getComments().isEmpty()) {
            for (String comment : detail.getComments()) {
                out.println("<div class='comment'>\" " + comment + " \"</div>");
            }
        } else {
            out.println("<div>Нет комментариев</div>");
        }
        out.println("</div>");
        
        // Кнопки действий
        out.println("<div class='action-buttons'>");
        
        // Утиль
        out.println("<button class='ozon-btn' style='background:#dc3545;' onclick='openUtilModal(" + cargoId + ", " + detail.getProduct().getId() + ")'>🗑 Утиль</button>");
        
        // Уценка
        out.println("<button class='ozon-btn' style='background:#ffc107; color:#333;' onclick='openUcenkaModal(" + cargoId + ", " + detail.getProduct().getId() + ")'>💰 Уценка</button>");
        
        // Пересорт
        out.println("<button class='ozon-btn' style='background:#17a2b8;' onclick='openPeresortModal(" + cargoId + ", " + detail.getProduct().getId() + ")'>🔄 Пересорт</button>");
        
        // Валид
        out.println("<form method='post' action='processProduct' style='display:inline-block;'>");
        out.println("<input type='hidden' name='cargoId' value='" + cargoId + "'>");
        out.println("<input type='hidden' name='productId' value='" + detail.getProduct().getId() + "'>");
        out.println("<input type='hidden' name='action' value='valid'>");
        out.println("<button class='ozon-btn' style='background:#28a745;'>✅ Валид</button>");
        out.println("</form>");
        
        out.println("</div>");
    }
}