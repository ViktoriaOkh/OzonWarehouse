package servlet;

import dao.ProductDAO;
import model.Product;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/products")
public class ProductServlet extends HttpServlet {
    
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private ProductDAO productDAO = new ProductDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        List<Product> products = productDAO.getAllProducts();
        request.setAttribute("products", products);
        request.getRequestDispatcher("/jsp/products.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if ("add".equals(action)) {
            String article = request.getParameter("article");
            String name = request.getParameter("name");
            String category = request.getParameter("category");
            String supplier = request.getParameter("supplier");
            
            Product product = new Product(0, article, name, category, supplier);
            boolean success = productDAO.addProduct(product);
            
            response.sendRedirect("products?success=" + success);
        } else if ("delete".equals(action)) {
            try {
                int id = Integer.parseInt(request.getParameter("id"));
                boolean success = productDAO.deleteProduct(id);
                response.sendRedirect("products?delete=" + success);
            } catch (NumberFormatException e) {
                response.sendRedirect("products?error=invalid_id");
            }
        } else if ("updateCategory".equals(action)) {
            try {
                int id = Integer.parseInt(request.getParameter("id"));
                String category = request.getParameter("category");
                boolean success = productDAO.updateCategory(id, category);
                response.sendRedirect("products?update=" + success);
            } catch (NumberFormatException e) {
                response.sendRedirect("products?error=invalid_id");
            }
        }
    }
}