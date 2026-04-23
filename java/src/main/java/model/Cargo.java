package model;

public class Cargo {
    private int id;
    private String number;
    private String receiptTime;
    private int quantity;
    private String status;

    public Cargo() {}

    public Cargo(int id, String number, String receiptTime, int quantity, String status) {
        this.id = id;
        this.number = number;
        this.receiptTime = receiptTime;
        this.quantity = quantity;
        this.status = status;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getNumber() { return number; }
    public void setNumber(String number) { this.number = number; }

    public String getReceiptTime() { return receiptTime; }
    public void setReceiptTime(String receiptTime) { this.receiptTime = receiptTime; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
}