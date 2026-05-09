package ma.ac.esi.moroccocraft.model;

public class User {
    private int    id;
    private String name;
    private String email;
    private String password;
    private String role;    
    private String bio;
    private String city;
    private String status;  
    public User() {}

    
    public int    getId()                    { return id; }
    public void   setId(int id)              { this.id = id; }
    public String getName()                  { return name; }
    public void   setName(String name)       { this.name = name; }
    public String getEmail()                 { return email; }
    public void   setEmail(String email)     { this.email = email; }
    public String getPassword()              { return password; }
    public void   setPassword(String p)      { this.password = p; }
    public String getRole()                  { return role; }
    public void   setRole(String role)       { this.role = role; }
    public String getBio()                   { return bio; }
    public void   setBio(String bio)         { this.bio = bio; }
    public String getCity()                  { return city; }
    public void   setCity(String city)       { this.city = city; }
    public String getStatus()                { return status; }
    public void   setStatus(String status)   { this.status = status; }
    public boolean isAdmin()                 { return "ADMIN".equals(role); }
    public boolean isArtisan()               { return "ARTISAN".equals(role); }
    public boolean isBuyer()                 { return "BUYER".equals(role); }
}
