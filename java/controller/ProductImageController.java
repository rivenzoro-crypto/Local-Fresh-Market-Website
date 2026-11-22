package controller;


import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/product-images/*")
public class ProductImageController extends HttpServlet {

    @Override
    protected void doGet(
            HttpServletRequest req,
            HttpServletResponse resp)
            throws ServletException, IOException {

        String requestedFile = req.getPathInfo();

        if (requestedFile == null || requestedFile.equals("/")) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        String fileName = new File(requestedFile).getName();

        Path uploadDirectory = Path.of(
            System.getProperty("user.home"),
            "online-order-uploads"
        );

        Path imagePath = uploadDirectory
            .resolve(fileName)
            .normalize();

        if (!imagePath.startsWith(uploadDirectory)
                || !Files.exists(imagePath)
                || !Files.isRegularFile(imagePath)) {

            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        String contentType = Files.probeContentType(imagePath);

        if (contentType == null) {
            contentType = "application/octet-stream";
        }

        resp.setContentType(contentType);
        resp.setContentLengthLong(Files.size(imagePath));

        Files.copy(imagePath, resp.getOutputStream());
    }
}
