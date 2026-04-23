package servlet;

import dao.EmployeeDAO;
import model.Employee;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/api/employee")
public class EmployeeApiServlet extends HttpServlet {
    
    private EmployeeDAO employeeDAO = new EmployeeDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("text/plain;charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        String barcode = request.getParameter("barcode");
        
        if (barcode != null && !barcode.isEmpty()) {
            Employee emp = employeeDAO.findByBarcode(barcode);
            if (emp != null) {
                // Простой текстовый ответ: found|ФИО
                out.print("found|" + emp.getFio() + "|" + emp.getId() + "|" + emp.getPosition());
            } else {
                out.print("notfound");
            }
        } else {
            out.print("notfound");
        }
    }
}