package ma.ac.esi.moroccocraft.service;

import ma.ac.esi.moroccocraft.model.Product;
import ma.ac.esi.moroccocraft.repository.ProductRepository;

import java.util.List;

public class ProductService {

    private final ProductRepository productRepo = new ProductRepository();


    public String submit(String title, String description, String priceStr,
                         String category, String imageUrl, int artisanId) {
        if (title == null || title.trim().isEmpty())
            return "Le titre est obligatoire.";
        if (category == null || category.trim().isEmpty())
            return "La catégorie est obligatoire.";
        double price;
        try {
            price = Double.parseDouble(priceStr.replace(",", "."));
            if (price <= 0) return "Le prix doit être positif.";
        } catch (NumberFormatException e) {
            return "Prix invalide.";
        }
        Product p = new Product();
        p.setTitle(title.trim());
        p.setDescription(description);
        p.setPrice(price);
        p.setCategory(category.trim());
        p.setImageUrl(imageUrl);
        p.setArtisanId(artisanId);
        return productRepo.insert(p) ? null : "Erreur lors de la soumission.";
    }

   

  
    public List<Product> getApprovedProducts(String category) {
        String cat = (category == null || category.trim().isEmpty()) ? null : category.trim();
        return productRepo.findApproved(cat);
    }

    public List<Product> getArtisanProducts(int artisanId) {
        return productRepo.findByArtisan(artisanId);
    }

    public Product getById(int id) {
        return productRepo.findById(id);
    }

    public List<Product> getPendingProducts() {
        return productRepo.findPending();
    }

    public List<Product> getAllProducts() {
        return productRepo.findAll();
    }

    public String update(int id, String title, String description,
                         String priceStr, String category, String imageUrl) {
        if (title == null || title.trim().isEmpty())
            return "Le titre est obligatoire.";
        double price;
        try {
            price = Double.parseDouble(priceStr.replace(",", "."));
            if (price <= 0) return "Le prix doit être positif.";
        } catch (NumberFormatException e) {
            return "Prix invalide.";
        }
        Product p = new Product();
        p.setId(id);
        p.setTitle(title.trim());
        p.setDescription(description);
        p.setPrice(price);
        p.setCategory(category);
        p.setImageUrl(imageUrl);
        return productRepo.update(p) ? null : "Erreur lors de la modification.";
    }

    public boolean updateStatus(int productId, String action) {
        String newStatus = "approve".equals(action) ? "APPROVED" : "REJECTED";
        return productRepo.updateStatus(productId, newStatus);
    }

 
    public boolean delete(int productId) {
        return productRepo.delete(productId);
    }
}