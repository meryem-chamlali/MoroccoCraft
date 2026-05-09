package ma.ac.esi.moroccocraft.service;

import ma.ac.esi.moroccocraft.model.User;
import ma.ac.esi.moroccocraft.repository.UserRepository;

public class UserService {

    private final UserRepository userRepo = new UserRepository();

    public User authenticate(String email, String password) {
        if (email == null || password == null) return null;

        User user = userRepo.findByEmail(email.trim().toLowerCase());
        if (user == null) return null;

        if (!password.equals(user.getPassword())) return null;

        if (!"ACTIVE".equals(user.getStatus())) return null;

        return user;
    }

    public String register(String name, String email, String password,
                           String role, String city, String bio) {

        if (name == null || name.trim().isEmpty())      return "Le nom est obligatoire.";
        if (email == null || email.trim().isEmpty())    return "L'email est obligatoire.";
        if (password == null || password.length() < 4) return "Mot de passe trop court (4 caractères min).";
        if (!role.equals("BUYER") && !role.equals("ARTISAN")) return "Rôle invalide.";

        email = email.trim().toLowerCase();
        if (userRepo.emailExists(email)) return "Cet email est déjà utilisé.";

        User user = new User();
        user.setName(name.trim());
        user.setEmail(email);
        user.setPassword(password); 
        user.setRole(role);
        user.setCity(city);
        user.setBio(bio);
       
        user.setStatus("ARTISAN".equals(role) ? "PENDING" : "ACTIVE");

        return userRepo.insert(user) ? null : "Erreur lors de l'inscription. Réessayez.";
    }
}