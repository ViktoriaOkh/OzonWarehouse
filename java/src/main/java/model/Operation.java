package model;

import java.sql.Date;

public class Operation {
    private int id;
    private Date date;
    private String productArticle;
    private String productName;
    private String employeeName;
    private String operationType;
    private int quantity;
    private String reason;
    
    public Operation(int id, Date date, String productArticle, String productName, 
                     String employeeName, String operationType, int quantity, String reason) {
        this.id = id;
        this.date = date;
        this.productArticle = productArticle;
        this.productName = productName;
        this.employeeName = employeeName;
        this.operationType = operationType;
        this.quantity = quantity;
        this.reason = reason;
    }
    
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public Date getDate() { return date; }
    public void setDate(Date date) { this.date = date; }
    
    public String getProductArticle() { return productArticle; }
    public void setProductArticle(String productArticle) { this.productArticle = productArticle; }
    
    public String getProductName() { return productName; }
    public void setProductName(String productName) { this.productName = productName; }
    
    public String getEmployeeName() { return employeeName; }
    public void setEmployeeName(String employeeName) { this.employeeName = employeeName; }
    
    public String getOperationType() { return operationType; }
    public void setOperationType(String operationType) { this.operationType = operationType; }
    
    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }
    
    public String getReason() { return reason; }
    public void setReason(String reason) { this.reason = reason; }
}