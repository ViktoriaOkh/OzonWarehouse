package servlet;

import dao.OperationDAO;
import model.Operation;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/testdao")
public class TestOperationDAO extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        out.println("<html><body>");
        out.println("<h1>Тест OperationDAO</h1>");
        
        OperationDAO dao = new OperationDAO();
        List<Operation> operations = dao.getAllOperations();
        
        out.println("<p>OperationDAO вернул: " + (operations != null ? operations.size() : "null") + " операций</p>");
        
        if (operations != null && !operations.isEmpty()) {
            out.println("<table border='1'>");
            out.println("<tr><th>ID</th><th>Дата</th><th>Тип</th><th>Товар</th></tr>");
            for (Operation op : operations) {
                out.println("<tr>");
                out.println("<td>" + op.getId() + "</td>");
                out.println("<td>" + op.getDate() + "</td>");
                out.println("<td>" + op.getOperationType() + "</td>");
                out.println("<td>" + op.getProductName() + "</td>");
                out.println("</tr>");
            }
            out.println("</table>");
        } else {
            out.println("<p style='color:red;'>Нет данных!</p>");
        }
        
        out.println("</body></html>");
    }
}