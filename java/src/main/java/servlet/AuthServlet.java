package servlet;

import dao.EmployeeDAO;
import model.Employee;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/auth")
public class AuthServlet extends HttpServlet {
    
    private EmployeeDAO employeeDAO = new EmployeeDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.getRequestDispatcher("/jsp/auth.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String barcode = request.getParameter("barcode");
        
        if (barcode == null || barcode.trim().isEmpty()) {
            request.setAttribute("error", "Введите US номер");
            request.getRequestDispatcher("/jsp/auth.jsp").forward(request, response);
            return;
        }
        
        Employee emp = employeeDAO.findByBarcode(barcode.trim());
        
        if (emp != null) {
            HttpSession session = request.getSession();
            session.setAttribute("employeeId", emp.getId());
            session.setAttribute("employeeName", emp.getFio());
            response.sendRedirect("processing");
        } else {
            request.setAttribute("error", "Сотрудник с таким US не найден");
            request.getRequestDispatcher("/jsp/auth.jsp").forward(request, response);
        }
    }
}