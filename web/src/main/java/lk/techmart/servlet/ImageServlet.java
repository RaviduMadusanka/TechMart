package lk.techmart.servlet;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;

@WebServlet("/image")
public class ImageServlet extends HttpServlet {

    private static final String UPLOAD_DIR = System.getProperty("user.home") + File.separator + "TechMartImages";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {

        String fileName = request.getParameter("file");

        if (fileName == null || fileName.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "File name is required");
            return;
        }

        File imageFile = new File(UPLOAD_DIR, fileName);

        if (!imageFile.exists() || imageFile.isDirectory()) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Image not found");
            return;
        }

        String mimeType = getServletContext().getMimeType(imageFile.getName());
        if (mimeType == null) {
            mimeType = "application/octet-stream";
        }
        response.setContentType(mimeType);
        response.setContentLength((int) imageFile.length());

        Files.copy(imageFile.toPath(), response.getOutputStream());
    }
}
