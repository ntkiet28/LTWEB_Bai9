package vn.iotstar.dto;

import java.math.BigDecimal;

public class ProductInput {
    private String title;
    private Integer quantity;
    private String desc;
    private BigDecimal price;
    private Long userId;
    
    // Constructors
    public ProductInput() {}
    
    public ProductInput(String title, Integer quantity, String desc, BigDecimal price, Long userId) {
        this.title = title;
        this.quantity = quantity;
        this.desc = desc;
        this.price = price;
        this.userId = userId;
    }
    
    // Getters and Setters
    public String getTitle() {
        return title;
    }
    
    public void setTitle(String title) {
        this.title = title;
    }
    
    public Integer getQuantity() {
        return quantity;
    }
    
    public void setQuantity(Integer quantity) {
        this.quantity = quantity;
    }
    
    public String getDesc() {
        return desc;
    }
    
    public void setDesc(String desc) {
        this.desc = desc;
    }
    
    public BigDecimal getPrice() {
        return price;
    }
    
    public void setPrice(BigDecimal price) {
        this.price = price;
    }
    
    public Long getUserId() {
        return userId;
    }
    
    public void setUserId(Long userId) {
        this.userId = userId;
    }
}