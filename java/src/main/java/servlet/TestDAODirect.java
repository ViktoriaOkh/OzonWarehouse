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

@WebServlet("/testdirect")
public class TestDAODirect extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        OperationDAO dao = new OperationDAO();
        List<Operation> ops = dao.getAllOperations();
        
        out.println("<html><body>");
        out.println("<h1>Прямой тест DAO</h1>");
        out.println("<p>Размер: " + ops.size() + "</p>");
        
        for (Operation op : ops) {
            out.println(op.getId() + " | " + op.getProductName() + "<br>");
        }
        
        out.println("</body></html>");
    }
}