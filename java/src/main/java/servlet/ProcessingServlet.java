package servlet;

import dao.CargoDAO;
import model.Cargo;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/processing")
public class ProcessingServlet extends HttpServlet {
    private CargoDAO cargoDAO = new CargoDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        if (session.getAttribute("employeeId") == null) {
            resp.sendRedirect("auth");
            return;
        }

        List<Cargo> cargos = cargoDAO.getOpenCargos();
        req.setAttribute("cargos", cargos);
        req.getRequestDispatcher("/jsp/cargos.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        if ("close".equals(action)) {
            int cargoId = Integer.parseInt(req.getParameter("cargoId"));
            cargoDAO.closeCargo(cargoId);
        }
        resp.sendRedirect("processing");
    }
}