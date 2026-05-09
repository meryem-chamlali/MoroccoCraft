package ma.ac.esi.moroccocraft;
import ma.ac.esi.moroccocraft.controller.*;
import org.apache.catalina.Context;
import org.apache.catalina.startup.Tomcat;
import java.io.File;

public class Main {
    public static void main(String[] args) throws Exception {
        Tomcat tomcat = new Tomcat();
        tomcat.setPort(7860);
        tomcat.getConnector();

        // Fonctionne dans Eclipse ET dans Docker/JAR
        String webappDir;
        if (new File("src/main/webapp").exists()) {
            webappDir = new File("src/main/webapp").getAbsolutePath();
        } else {
            webappDir = new File("webapp").getAbsolutePath();
        }

        Context ctx = tomcat.addWebapp("/moroccocraft", webappDir);
        ctx.setParentClassLoader(Main.class.getClassLoader());

        Tomcat.addServlet(ctx, "LoginController",          new LoginController()).setLoadOnStartup(1);
        Tomcat.addServlet(ctx, "RegisterController",       new RegisterController()).setLoadOnStartup(1);
        Tomcat.addServlet(ctx, "LogoutController",         new LogoutController()).setLoadOnStartup(1);
        Tomcat.addServlet(ctx, "ProductController",        new ProductController()).setLoadOnStartup(1);
        Tomcat.addServlet(ctx, "SubmitProductController",  new SubmitProductController()).setLoadOnStartup(1);
        Tomcat.addServlet(ctx, "EditProductController",    new EditProductController()).setLoadOnStartup(1);
        Tomcat.addServlet(ctx, "DeleteProductController",  new DeleteProductController()).setLoadOnStartup(1);
        Tomcat.addServlet(ctx, "MyProductsController",     new MyProductsController()).setLoadOnStartup(1);
        Tomcat.addServlet(ctx, "CartController",           new CartController()).setLoadOnStartup(1);
        Tomcat.addServlet(ctx, "CheckoutController",       new CheckoutController()).setLoadOnStartup(1);
        Tomcat.addServlet(ctx, "OrderController",          new OrderController()).setLoadOnStartup(1);
        Tomcat.addServlet(ctx, "AdminController",          new AdminController()).setLoadOnStartup(1);

        ctx.addServletMappingDecoded("/LoginController",         "LoginController");
        ctx.addServletMappingDecoded("/RegisterController",      "RegisterController");
        ctx.addServletMappingDecoded("/LogoutController",        "LogoutController");
        ctx.addServletMappingDecoded("/ProductController",       "ProductController");
        ctx.addServletMappingDecoded("/SubmitProductController", "SubmitProductController");
        ctx.addServletMappingDecoded("/EditProductController",   "EditProductController");
        ctx.addServletMappingDecoded("/DeleteProductController", "DeleteProductController");
        ctx.addServletMappingDecoded("/MyProductsController",    "MyProductsController");
        ctx.addServletMappingDecoded("/CartController",          "CartController");
        ctx.addServletMappingDecoded("/CheckoutController",      "CheckoutController");
        ctx.addServletMappingDecoded("/OrderController",         "OrderController");
        ctx.addServletMappingDecoded("/AdminController",         "AdminController");

        tomcat.start();

        System.out.println("  MoroccoCraft démarré avec succès !");
        System.out.println("  http://localhost:7860/moroccocraft/LoginController");

        Runtime.getRuntime().addShutdownHook(new Thread(() -> {
            try {
                System.out.println("Arrêt du serveur...");
                tomcat.stop();
                tomcat.destroy();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }));

        tomcat.getServer().await();
    }
}