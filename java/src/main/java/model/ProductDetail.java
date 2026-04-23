package model;

import java.util.List;
import java.util.Map;

public class ProductDetail {
    private Product product;
    private Map<String, String> characteristics;
    private List<String> photos;
    private List<String> comments;

    // геттеры и сеттеры
    public Product getProduct() { return product; }
    public void setProduct(Product product) { this.product = product; }

    public Map<String, String> getCharacteristics() { return characteristics; }
    public void setCharacteristics(Map<String, String> characteristics) { this.characteristics = characteristics; }

    public List<String> getPhotos() { return photos; }
    public void setPhotos(List<String> photos) { this.photos = photos; }

    public List<String> getComments() { return comments; }
    public void setComments(List<String> comments) { this.comments = comments; }
}