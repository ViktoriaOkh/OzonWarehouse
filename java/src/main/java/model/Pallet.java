package model;

public class Pallet {
    private int id;
    private String number;
    private String zone;
    private int quantity;
    private String status;
    private String createdAt;
    private String closedAt;

    public Pallet() {}

    public Pallet(int id, String number, String zone, int quantity, String status, String createdAt, String closedAt) {
        this.id = id;
        this.number = number;
        this.zone = zone;
        this.quantity = quantity;
        this.status = status;
        this.createdAt = createdAt;
        this.closedAt = closedAt;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getNumber() { return number; }
    public void setNumber(String number) { this.number = number; }

    public String getZone() { return zone; }
    public void setZone(String zone) { this.zone = zone; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getCreatedAt() { return createdAt; }
    public void setCreatedAt(String createdAt) { this.createdAt = createdAt; }

    public String getClosedAt() { return closedAt; }
    public void setClosedAt(String closedAt) { this.closedAt = closedAt; }
}