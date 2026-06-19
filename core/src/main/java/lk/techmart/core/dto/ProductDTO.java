package lk.techmart.core.dto;

import java.math.BigDecimal;

public class ProductDTO {

    private Long productId;
    private String productCode;
    private String productName;
    private String description;
    private String category;
    private String brand;
    private BigDecimal price;
    private BigDecimal costPrice;
    private String imageUrl;
    private BigDecimal weight;
    private String status;

    public ProductDTO() {
    }

    public ProductDTO(Long productId,
                      String productCode,
                      String productName,
                      String description,
                      String category,
                      String brand,
                      BigDecimal price, BigDecimal costPrice, String imageUrl, BigDecimal weight, String status) {
        this.productId = productId;
        this.productCode = productCode;
        this.productName = productName;
        this.description = description;
        this.category = category;
        this.brand = brand;
        this.price = price;
        this.costPrice = costPrice;
        this.imageUrl = imageUrl;
        this.weight = weight;
        this.status = status;
    }

    public Long getProductId() {
        return productId;
    }

    public void setProductId(Long productId) {
        this.productId = productId;
    }

    public String getProductCode() {
        return productCode;
    }

    public void setProductCode(String productCode) {
        this.productCode = productCode;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public String getBrand() {
        return brand;
    }

    public void setBrand(String brand) {
        this.brand = brand;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    public BigDecimal getCostPrice() {
        return costPrice;
    }

    public void setCostPrice(BigDecimal costPrice) {
        this.costPrice = costPrice;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public BigDecimal getWeight() {
        return weight;
    }

    public void setWeight(BigDecimal weight) {
        this.weight = weight;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
}
