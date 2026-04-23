package servlet;

import dao.CargoDAO;
import dao.ProductDetailDAO;
import model.Cargo;
import model.Product;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/cargoProducts")
public class CargoProductServlet extends HttpServlet {
    
    private CargoDAO cargoDAO = new CargoDAO();
    private ProductDetailDAO detailDAO = new ProductDetailDAO();
    
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int cargoId = Integer.parseInt(req.getParameter("cargoId"));
        
        System.out.println("CargoProductServlet: cargoId = " + cargoId);
        
        Cargo cargo = cargoDAO.findById(cargoId);
        List<Product> products = detailDAO.getProductsByCargoId(cargoId);
        
        System.out.println("CargoProductServlet: найдено товаров = " + (products != null ? products.size() : 0));
        
        req.setAttribute("cargo", cargo);
        req.setAttribute("products", products);
        req.getRequestDispatcher("/jsp/cargoProducts.jsp").forward(req, resp);
    }
}