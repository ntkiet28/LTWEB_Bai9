package vn.iotstar.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import vn.iotstar.entity.Category;
import vn.iotstar.entity.Product;
import vn.iotstar.entity.User;
import vn.iotstar.service.CategoryService;
import vn.iotstar.service.ProductService;
import vn.iotstar.service.UserService;

import java.math.BigDecimal;

@RestController
public class DataController {
    
    @Autowired
    private UserService userService;
    
    @Autowired
    private CategoryService categoryService;
    
    @Autowired
    private ProductService productService;
    
    @GetMapping("/init-data")
    public String initData() {
        try {
            // Check if data already exists
            if (userService.getAllUsers().size() > 0) {
                return "Data already exists!";
            }
            
            // Create Users
            User user1 = new User("Nguyen Van A", "nguyenvana@example.com", "password123", "0123456789");
            User user2 = new User("Tran Thi B", "tranthib@example.com", "password456", "0987654321");
            User user3 = new User("Le Van C", "levanc@example.com", "password789", "0555666777");
            
            user1 = userService.createUser(user1);
            user2 = userService.createUser(user2);
            user3 = userService.createUser(user3);
            
            // Create Categories
            Category category1 = new Category("Electronics", "electronics.jpg");
            Category category2 = new Category("Clothing", "clothing.jpg");
            Category category3 = new Category("Books", "books.jpg");
            
            category1 = categoryService.createCategory(category1);
            category2 = categoryService.createCategory(category2);
            category3 = categoryService.createCategory(category3);
            
            // Link Users with Categories (Many-to-Many)
            userService.addUserToCategory(user1.getId(), category1.getId());
            userService.addUserToCategory(user1.getId(), category2.getId());
            userService.addUserToCategory(user2.getId(), category2.getId());
            userService.addUserToCategory(user2.getId(), category3.getId());
            userService.addUserToCategory(user3.getId(), category1.getId());
            userService.addUserToCategory(user3.getId(), category3.getId());
            
            // Create Products
            Product product1 = new Product("iPhone 15", 10, "Latest Apple smartphone", new BigDecimal("999.99"), user1);
            Product product2 = new Product("Samsung Galaxy S24", 15, "Samsung flagship phone", new BigDecimal("899.99"), user1);
            Product product3 = new Product("Nike Air Max", 25, "Comfortable running shoes", new BigDecimal("149.99"), user2);
            Product product4 = new Product("Adidas Ultraboost", 20, "Premium running shoes", new BigDecimal("179.99"), user2);
            Product product5 = new Product("Spring Boot Guide", 50, "Comprehensive Spring Boot tutorial", new BigDecimal("39.99"), user3);
            Product product6 = new Product("Java Programming", 30, "Learn Java from basics", new BigDecimal("49.99"), user3);
            Product product7 = new Product("MacBook Pro", 5, "Apple laptop for professionals", new BigDecimal("1999.99"), user1);
            Product product8 = new Product("Dell XPS 13", 8, "Windows ultrabook", new BigDecimal("1199.99"), user3);
            
            productService.createProduct(product1);
            productService.createProduct(product2);
            productService.createProduct(product3);
            productService.createProduct(product4);
            productService.createProduct(product5);
            productService.createProduct(product6);
            productService.createProduct(product7);
            productService.createProduct(product8);
            
            return "Sample data loaded successfully!";
            
        } catch (Exception e) {
            return "Error loading sample data: " + e.getMessage();
        }
    }
}