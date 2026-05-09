package ma.ac.esi.moroccocraft.model;

import java.util.Date;

public class Order {
    private int    id;
    private int    buyerId;
    private int    productId;
    private String buyerName;
    private String buyerPhone;
    private String buyerAddress;
    private String buyerCity;
    private int    quantity;
    private double totalPrice;
    private String status;
    
    private Date   deliveryDate;
    private String artisanNote;
    private Date   createdAt;

    
    private String productTitle;
    private String productCategory;
    private String artisanName;
    private String artisanPhone;
    private int    artisanId;

  
    public int    getId()                         { return id; }
    public void   setId(int id)                   { this.id = id; }
    public int    getBuyerId()                    { return buyerId; }
    public void   setBuyerId(int v)               { this.buyerId = v; }
    public int    getProductId()                  { return productId; }
    public void   setProductId(int v)             { this.productId = v; }
    public String getBuyerName()                  { return buyerName; }
    public void   setBuyerName(String v)          { this.buyerName = v; }
    public String getBuyerPhone()                 { return buyerPhone; }
    public void   setBuyerPhone(String v)         { this.buyerPhone = v; }
    public String getBuyerAddress()               { return buyerAddress; }
    public void   setBuyerAddress(String v)       { this.buyerAddress = v; }
    public String getBuyerCity()                  { return buyerCity; }
    public void   setBuyerCity(String v)          { this.buyerCity = v; }
    public int    getQuantity()                   { return quantity; }
    public void   setQuantity(int v)              { this.quantity = v; }
    public double getTotalPrice()                 { return totalPrice; }
    public void   setTotalPrice(double v)         { this.totalPrice = v; }
    public String getStatus()                     { return status; }
    public void   setStatus(String v)             { this.status = v; }
    public Date   getDeliveryDate()               { return deliveryDate; }
    public void   setDeliveryDate(Date v)         { this.deliveryDate = v; }
    public String getArtisanNote()                { return artisanNote; }
    public void   setArtisanNote(String v)        { this.artisanNote = v; }
    public Date   getCreatedAt()                  { return createdAt; }
    public void   setCreatedAt(Date v)            { this.createdAt = v; }
    public String getProductTitle()               { return productTitle; }
    public void   setProductTitle(String v)       { this.productTitle = v; }
    public String getProductCategory()            { return productCategory; }
    public void   setProductCategory(String v)    { this.productCategory = v; }
    public String getArtisanName()                { return artisanName; }
    public void   setArtisanName(String v)        { this.artisanName = v; }
    public String getArtisanPhone()               { return artisanPhone; }
    public void   setArtisanPhone(String v)       { this.artisanPhone = v; }
    public int    getArtisanId()                  { return artisanId; }
    public void   setArtisanId(int v)             { this.artisanId = v; }

   
    public String getStatusLabel() {
        switch (status) {
            case "EN_ATTENTE":   return "⏳ En attente";
            case "CONFIRMEE":    return "✅ Confirmée";
            case "EN_LIVRAISON": return "🚚 En livraison";
            case "LIVREE":       return "📦 Livrée";
            case "ANNULEE":      return "❌ Annulée";
            default:             return status;
        }
    }

    public String getStatusColor() {
        switch (status) {
            case "EN_ATTENTE":   return "#854d0e;background:#fef9c3";
            case "CONFIRMEE":    return "#166534;background:#dcfce7";
            case "EN_LIVRAISON": return "#1e40af;background:#dbeafe";
            case "LIVREE":       return "#166534;background:#bbf7d0";
            case "ANNULEE":      return "#991b1b;background:#fee2e2";
            default:             return "#5a4a3a;background:#f5f0e8";
        }
    }
}
