package vn.iotstar.dto;

public class CategoryInput {
    private String name;
    private String images;
    
    // Constructors
    public CategoryInput() {}
    
    public CategoryInput(String name, String images) {
        this.name = name;
        this.images = images;
    }
    
    // Getters and Setters
    public String getName() {
        return name;
    }
    
    public void setName(String name) {
        this.name = name;
    }
    
    public String getImages() {
        return images;
    }
    
    public void setImages(String images) {
        this.images = images;
    }
}