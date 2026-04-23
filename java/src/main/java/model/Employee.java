package model;

public class Employee {
    private int id;
    private String fio;
    private String position;
    private String shift;
    private String barcode;

    public Employee() {}

    public Employee(int id, String fio, String position, String shift, String barcode) {
        this.id = id;
        this.fio = fio;
        this.position = position;
        this.shift = shift;
        this.barcode = barcode;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getFio() { return fio; }
    public void setFio(String fio) { this.fio = fio; }

    public String getPosition() { return position; }
    public void setPosition(String position) { this.position = position; }

    public String getShift() { return shift; }
    public void setShift(String shift) { this.shift = shift; }

    public String getBarcode() { return barcode; }
    public void setBarcode(String barcode) { this.barcode = barcode; }
}