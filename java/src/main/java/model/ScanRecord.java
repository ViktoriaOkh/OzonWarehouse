package model;

public class ScanRecord {
    private int id;
    private int cargoId;
    private int productId;
    private int employeeId;
    private int operationTypeId;
    private int quantity;
    private String reason;
    private String comment;
    private String scanTime;
    private String boxNumber;
    
    public ScanRecord() {}
    
    public ScanRecord(int id, int cargoId, int productId, int employeeId, int operationTypeId,
                      int quantity, String reason, String comment, String scanTime, String boxNumber) {
        this.id = id;
        this.cargoId = cargoId;
        this.productId = productId;
        this.employeeId = employeeId;
        this.operationTypeId = operationTypeId;
        this.quantity = quantity;
        this.reason = reason;
        this.comment = comment;
        this.scanTime = scanTime;
        this.boxNumber = boxNumber;
    }
    
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public int getCargoId() { return cargoId; }
    public void setCargoId(int cargoId) { this.cargoId = cargoId; }
    
    public int getProductId() { return productId; }
    public void setProductId(int productId) { this.productId = productId; }
    
    public int getEmployeeId() { return employeeId; }
    public void setEmployeeId(int employeeId) { this.employeeId = employeeId; }
    
    public int getOperationTypeId() { return operationTypeId; }
    public void setOperationTypeId(int operationTypeId) { this.operationTypeId = operationTypeId; }
    
    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }
    
    public String getReason() { return reason; }
    public void setReason(String reason) { this.reason = reason; }
    
    public String getComment() { return comment; }
    public void setComment(String comment) { this.comment = comment; }
    
    public String getScanTime() { return scanTime; }
    public void setScanTime(String scanTime) { this.scanTime = scanTime; }
    
    public String getBoxNumber() { return boxNumber; }
    public void setBoxNumber(String boxNumber) { this.boxNumber = boxNumber; }
}