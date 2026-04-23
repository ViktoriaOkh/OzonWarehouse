package model;

public class Product {
    private int id;
    private String article;
    private String name;
    private String category;
    private String supplier;
    
    public Product(int id, String article, String name, String category, String supplier) {
        this.id = id;
        this.article = article;
        this.name = name;
        this.category = category;
        this.supplier = supplier;
    }
    
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public String getArticle() { return article; }
    public void setArticle(String article) { this.article = article; }
    
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    
    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }
    
    public String getSupplier() { return supplier; }
    public void setSupplier(String supplier) { this.supplier = supplier; }
}