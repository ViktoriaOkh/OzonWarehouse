package servlet;

import dao.EmployeeDAO;
import model.Employee;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/employees")
public class EmployeeServlet extends HttpServlet {
    
    private EmployeeDAO employeeDAO = new EmployeeDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        List<Employee> employees = employeeDAO.getAllEmployees();
        request.setAttribute("employees", employees);
        request.getRequestDispatcher("/jsp/employees.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if ("add".equals(action)) {
            String fio = request.getParameter("fio");
            String position = request.getParameter("position");
            String shift = request.getParameter("shift");
            
            // ИСПРАВЛЕНО: используем конструктор по умолчанию и сеттеры
            Employee employee = new Employee();
            employee.setFio(fio);
            employee.setPosition(position);
            employee.setShift(shift);
            
            boolean success = employeeDAO.addEmployee(employee);
            
            response.sendRedirect("employees?success=" + success);
        } else if ("delete".equals(action)) {
            try {
                int id = Integer.parseInt(request.getParameter("id"));
                boolean success = employeeDAO.deleteEmployee(id);
                response.sendRedirect("employees?delete=" + success);
            } catch (NumberFormatException e) {
                response.sendRedirect("employees?error=invalid_id");
            }
        }
    }
}