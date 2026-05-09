package ma.ac.esi.moroccocraft.model;

public class Product {
    private int    id;
    private String title;
    private String description;
    private double price;
    private String category;    
    private String imageUrl;
    private int    artisanId;
    private String artisanName;
    private String artisanCity;
    private String status;      

    public Product() {}

    
    public int    getId()                       { return id; }
    public void   setId(int id)                 { this.id = id; }
    public String getTitle()                    { return title; }
    public void   setTitle(String title)        { this.title = title; }
    public String getDescription()              { return description; }
    public void   setDescription(String d)      { this.description = d; }
    public double getPrice()                    { return price; }
    public void   setPrice(double price)        { this.price = price; }
    public String getCategory()                 { return category; }
    public void   setCategory(String cat)       { this.category = cat; }
    public String getImageUrl()                 { return imageUrl; }
    public void   setImageUrl(String url)       { this.imageUrl = url; }
    public int    getArtisanId()                { return artisanId; }
    public void   setArtisanId(int id)          { this.artisanId = id; }
    public String getArtisanName()              { return artisanName; }
    public void   setArtisanName(String n)      { this.artisanName = n; }
    public String getArtisanCity()              { return artisanCity; }
    public void   setArtisanCity(String c)      { this.artisanCity = c; }
    public String getStatus()                   { return status; }
    public void   setStatus(String status)      { this.status = status; }
}
