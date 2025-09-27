package vn.iotstar.entity;

import jakarta.persistence.*;
import java.util.HashSet;
import java.util.Set;

@Entity
@Table(name = "users")
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(nullable = false)
    private String fullname;
    
    @Column(nullable = false, unique = true)
    private String email;
    
    @Column(nullable = false)
    private String password;
    
    private String phone;
    
    // Quan hệ One-to-Many với Product
    @OneToMany(mappedBy = "user", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private Set<Product> products = new HashSet<>();
    
    // Quan hệ Many-to-Many với Category
    @ManyToMany(mappedBy = "users", fetch = FetchType.LAZY)
    private Set<Category> categories = new HashSet<>();
    
    // Constructors
    public User() {}
    
    public User(String fullname, String email, String password, String phone) {
        this.fullname = fullname;
        this.email = email;
        this.password = password;
        this.phone = phone;
    }
    
    // Getters and Setters
    public Long getId() {
        return id;
    }
    
    public void setId(Long id) {
        this.id = id;
    }
    
    public String getFullname() {
        return fullname;
    }
    
    public void setFullname(String fullname) {
        this.fullname = fullname;
    }
    
    public String getEmail() {
        return email;
    }
    
    public void setEmail(String email) {
        this.email = email;
    }
    
    public String getPassword() {
        return password;
    }
    
    public void setPassword(String password) {
        this.password = password;
    }
    
    public String getPhone() {
        return phone;
    }
    
    public void setPhone(String phone) {
        this.phone = phone;
    }
    
    public Set<Product> getProducts() {
        return products;
    }
    
    public void setProducts(Set<Product> products) {
        this.products = products;
    }
    
    public Set<Category> getCategories() {
        return categories;
    }
    
    public void setCategories(Set<Category> categories) {
        this.categories = categories;
    }
}