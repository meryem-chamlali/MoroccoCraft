package ma.ac.esi.moroccocraft.util;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import ma.ac.esi.moroccocraft.model.User;
import java.io.IOException;

public class SessionUtil {

 
    public static User getConnectedUser(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) return null;
        return (User) session.getAttribute("user");
    }

    public static boolean isAuthenticated(HttpServletRequest request,
                                          HttpServletResponse response) throws IOException {
        if (getConnectedUser(request) == null) {
            response.sendRedirect(request.getContextPath() + "/index.html");
            return false;
        }
        return true;
    }

    
    public static boolean isAdmin(HttpServletRequest request,
                                  HttpServletResponse response) throws IOException {
        User user = getConnectedUser(request);
        if (user == null || !user.isAdmin()) {
            response.sendRedirect(request.getContextPath() + "/WEB-INF/views/error403.html");
            return false;
        }
        return true;
    }

    public static boolean isArtisan(HttpServletRequest request,
                                    HttpServletResponse response) throws IOException {
        User user = getConnectedUser(request);
        if (user == null || !user.isArtisan()) {
            response.sendRedirect(request.getContextPath() + "/WEB-INF/views/error403.html");
            return false;
        }
        return true;
    }
}
